import Vapor

open final class AppSystem {
    var clients: WebsocketClients

    init(eventLoop: EventLoop) {
        self.clients = WebsocketClients(eventLoop: eventLoop)
    }

    func connect(_ ws: WebSocket) {
        ws.onBinary { [unowned self] ws, buffer in
            if let msg = buffer.decodeWebsocketMessage(Connect.self) {
                let user = UserClient(id: msg.client, socket: ws)
                self.clients.add(user)
            }
        }
    }
}
