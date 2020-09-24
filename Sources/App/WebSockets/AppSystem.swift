import Vapor

final class AppSystem {
    var clients: WebsocketClients
    

    init(eventLoop: EventLoop) {
        self.clients = WebsocketClients(eventLoop: eventLoop)
    }

    func connect(_ ws: WebSocket) {
        var count = 0

        ws.onBinary { [unowned self] ws, buffer in
            if let msg = buffer.decodeWebsocketMessage(Connect.self) {
                let user = UserClient(id: msg.client, socket: ws)
                self.clients.add(user)
            }
        }
        ws.onText { [unowned self] ws, buffer in
            guard let json = buffer.parseJSONString else {
//                let logger = Logger(label: "WebSocket.Logger")
//                logger.log(level: Logger.Level.detect(from: &Environment.detect()), "asdasdas")
                return
            }
                do {
                let json = try JSONDecoder().decode(Connect.self, from: buffer.data(using: .utf8)!)
                print(json)
                ws.send(json.connect.description)
            } catch {
                print(count)
            }
            
        }
    }
}

extension String {

    var parseJSONString: Any? {
        if let data = self.data(using: .utf8, allowLossyConversion: false) {
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
