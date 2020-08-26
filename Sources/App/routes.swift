import Fluent
import Vapor

func routes(_ app: Application, appSystem: AppSystem) throws {
    app.webSocket("api", "v1") { (req, ws) in
        appSystem.connect(ws)
    }

//    try app.register(collection: TodoController())
}
