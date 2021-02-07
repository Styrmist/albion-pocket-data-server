//
//  File.swift
//  
//
//  Created by Kirill Danilov on 06/02/2021.
//

import Vapor

//using force unwrap to be sure that all needed variables are provided

extension Environment {
    static let serverDomain: String = Self.get("server_domain")!

    static let serverPort: Int = Int(Self.get("server_port")!)!
}
