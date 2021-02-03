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

enum LocalisedItemType: String, CaseIterable, Codable {
    case name
    case description
}

final class LocalisedItem: Model {
    // Name of the table or collection.
    static let schema = "localised_items"

    @ID(key: .id)
    var id: UUID?
 
    @Parent(key: .item)
    var item: Item

    @Enum(key: .language)
    var language: LocalisationLanguage
    @Field(key: .translation)
    var translation: String
    @Enum(key: .type)
    var type: LocalisedItemType

    init() { }

    init(id: UUID? = nil,
         language: LocalisationLanguage,
         translation: String,
         type: LocalisedItemType) {
        self.id = id
        self.language = language
        self.translation = translation
        self.type = type
    }
}

extension LocalisedItem: Content { }
