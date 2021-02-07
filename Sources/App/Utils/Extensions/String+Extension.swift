//
//  File.swift
//  
//
//  Created by Kirill Danilov on 06/02/2021.
//

import Foundation

extension String {

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
