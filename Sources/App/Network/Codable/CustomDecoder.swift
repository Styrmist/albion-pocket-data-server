//
//  File.swift
//  
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Foundation

final class CustomDecoder {
    static var camelCase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
//public extension JSONDecoder.KeyDecodingStrategy {
//
//    static let convertFromKebabCase = JSONDecoder.KeyDecodingStrategy.custom({ keys in
//        // Should never receive an empty `keys` array in theory.
//        guard let lastKey = keys.last else {
//            return
//        }
//        // Represents an array index.
//        if lastKey.intValue != nil {
//            return lastKey
//        }
//        let components = lastKey.stringValue.split(separator: "-")
//        guard let firstComponent = components.first?.lowercased() else {
//            return lastKey
//        }
//        let trailingComponents = components.dropFirst().map {
//            $0.capitalized
//        }
//        let lowerCamelCaseKey = ([firstComponent] + trailingComponents).joined()
//        return lowerCamelCaseKey
//    })
//
//}
