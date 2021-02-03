//
//  File.swift
//
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Fluent
import FluentSQLiteDriver
import Foundation
import Vapor

final class LocalisedItem: LocalisedItem {
    // Name of the table or collection.
    static let schema = DatabaseTables.localisedItem.rawValue

    @ID(key: .id)
    var id: UUID?
 
    @Parent(key: "item")
    var item: Item

    @Enum(key: "language")
    var language: LocalisationLanguage
    @Field(key: "string")
    var string: String

    init() { }

    init(id: UUID? = nil,
         language: LocalisationLanguage,
         string: String) {
        self.id = id
        self.language = language
        self.string = string
    }
}

extension LocalisedItem: Content { }
