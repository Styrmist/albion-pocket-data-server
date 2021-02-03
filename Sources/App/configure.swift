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

        for gitItem in gitItems {
            let item = Item(gitItem: gitItem)
            try? save([item], to: app.db)
            let localisedItemNames = gitItem.localisedNames?.localisation.compactMap { dict -> LocalisedItemName in
                return LocalisedItemName(language: dict.key, string: dict.value)
            }
            if let localisedItemNames = localisedItemNames {
                try? save(item.$localisedNames, objects: localisedItemNames, to: app.db).wait()
            }

            let localisedItemDescriptions = gitItem.localisedDescriptions?.localisation.compactMap { dict -> LocalisedItemDescription in
                return LocalisedItemDescription(language: dict.key, string: dict.value)
            }

            if let localisedItemDescriptions = localisedItemDescriptions {
                try? save(item.$localisedDescriptions, objects: localisedItemDescriptions, to: app.db).wait()
            }
        }
    }

    //        app.db(.sqlite).transaction { database -> EventLoopFuture<Void> in
    //            var test = [EventLoopFuture<Void>]()
    //            for (item, _, _) in items {
    //                test.append(item.save(on: database))
    //            }
    //            return .andAllComplete(test, on: eventLoop)
    //        }.always { _ in
    //            app.db(.sqlite).transaction { database -> EventLoopFuture<Void> in
    //                var test1 = [EventLoopFuture<Void>]()
    //                for (item, names, descriptions) in items {
    //                    test1.append(item.$localisedNames.create(names, on: database))
    //                    test1.append(item.$localisedDescriptions.create(descriptions, on: database))
    //                }
    //                return .andAllComplete(test1, on: eventLoop)
    //            }
    //        }

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

func save<T: Model>(_ objects: T..., to db: Database) -> EventLoopFuture<Void> {
    return db.transaction { database -> EventLoopFuture<Void> in
        objects.create(on: database)
    }
}

func save<U: LocalisedItem, T: ChildrenProperty<Item, U>>(_ object: Item, children: [U], to db: Database) -> EventLoopFuture<Void> {
    try? save(object, to: db).wait()
    return db.transaction { database in
        if let names = children as [LocalisedItemName] {
            object.$localisedNames.create(children, on: database)
        } else if let descriptions = children as [LocalisedItemDescription] {
            object.$localisedDescriptions.create(children, on: database)
        }
    }
}

func save<U: LocalisedItem, T: ChildrenProperty<Item, U>>(_ children: T, objects: [U], to db: Database) -> EventLoopFuture<Void> {
    return db.transaction { database -> EventLoopFuture<Void> in
        children.create(objects, on: database)
    }
}

//MARK: Migrations
func performAllMigrations(_ app: Application) throws {

    app.migrations.add(CreateItems())
//    app.migrations.add(CreateLocalisationLanguages())
    app.migrations.add(CreateLocalisedItemDescriptions())
    app.migrations.add(CreateLocalisedItemNames())
    try app.autoMigrate().wait()
}

func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}

