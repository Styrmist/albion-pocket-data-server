//import Fluent
//import FluentPostgresDriver
import Vapor

public func configure(_ app: Application) throws {
    
    getEnvironmentVar(<#T##name: String##String#>)
    
    app.http.server.configuration.hostname = "127.0.0.1"
    app.http.server.configuration.port = 9876
    
    let appSystem = AppSystem(eventLoop: app.eventLoopGroup.next())
    try routes(app, appSystem: appSystem)
    
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

func getEnvironmentVar(_ name: String) -> String? {
    guard let rawValue = getenv(name) else { return nil }
    return String(utf8String: rawValue)
}
