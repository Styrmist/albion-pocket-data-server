//
//  WebSocketClient.swift
//  
//
//  Created by Kirill on 03.08.2020.
//

import Vapor

open class WebSocketClient {
    open var id: UUID
    open var socket: WebSocket

    public init(id: UUID, socket: WebSocket) {
        self.id = id
        self.socket = socket
    }
}
