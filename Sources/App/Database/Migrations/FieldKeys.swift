//
//  File.swift
//  
//
//  Created by Kirill Danilov on 03/02/2021.
//

import Fluent

extension FieldKey {
    // item
    static var itemIndex: Self { "index" }
    static var uniqueName: Self { "unique_name" }
    // localised item
    static var item: Self { "item" }
    static var language: Self { "language" }
    static var translation: Self { "translation" }
    static var type: Self { "type" }
}
