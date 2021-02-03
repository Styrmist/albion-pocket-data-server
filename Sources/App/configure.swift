import Fluent
import Vapor
import FluentSQLiteDriver  // added
import PromiseKit

public func configure(_ app: Application) throws {
    
    guard let environment = try? Environment.detect() else {
        return
    }
    
    if environment.isRelease {
        app.http.server.configuration.hostname = "127.0.0.1"
        app.http.server.configuration.port = 9877
    } else {
        app.http.server.configuration.hostname = "127.0.0.1"
        app.http.server.configuration.port = 9877
    }

    app.logger.logLevel = .warning
    
    let appSystem = AppSystem(eventLoop: app.eventLoopGroup.next())
    try routes(app, appSystem: appSystem)


    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.databases.default(to: .sqlite)
    try performAllMigrations(app)

    let gitPath = GithubPath(user: "broderickhyman", repo: "ao-bin-dumps", path: "master/formatted/items.json")
    NetworkManager().getFileContent(gitPath: gitPath) { (gitItems, error) in
        if let error = error {
            print(error)
            return
        }

        guard let gitItems = gitItems else {
            print("oops")
            return
        }

        app.db.transaction { database -> EventLoopFuture<Void> in
            let operations: [EventLoopFuture<Void>] = gitItems.compactMap { gitItem in
                let item = Item(gitItem: gitItem)
                return item.create(on: database).flatMap { _ in
                    return item.$localised.create(localisedItems(for: gitItem), on: database)//.transform(to: ())
                }
            }
            return operations.flatten(on: database.eventLoop)
        }.whenComplete { result in
            print(result)
        }
    }

    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//    ), as: .psql)
//
//    app.migrations.add(CreateTodo())
}

@discardableResult
func save<T: Model>(_ objects: T..., to db: Database) -> EventLoopFuture<Void> {
    return db.transaction { database in
        objects.create(on: database)
    }
}

//@discardableResult
//func save(_ object: Item, children: [LocalisedItem], type: LocalisedItemType, to db: Database) -> EventLoopFuture<Void> {
//    return db.transaction { database in
//        switch type {
//            case .name:
//                return object.$localisedNames.create(children, on: database)
//            case .description:
//                return object.$localisedDescriptions.create(children, on: database)
//        }
//    }
//}

func localisedItems(for item: GitItem) -> [LocalisedItem] {

    var localisedItems = [LocalisedItem]()
    item.localisedNames?.localisation.forEach { dict in
        localisedItems.append(LocalisedItem(language: dict.key, translation: dict.value, type: .name))
    }
    item.localisedDescriptions?.localisation.forEach { dict in
        localisedItems.append(LocalisedItem(language: dict.key, translation: dict.value, type: .description))
    }
    return localisedItems
}

//MARK: Migrations
func performAllMigrations(_ app: Application) throws {

    app.migrations.add(CreateItems())
    app.migrations.add(CreateLocalisedItemNames())
    try app.autoMigrate().wait()
}

func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}

