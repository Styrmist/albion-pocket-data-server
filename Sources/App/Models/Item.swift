//
//  File.swift
//  
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Fluent
import Foundation
import Vapor

final class Item: Model {
    // Name of the table or collection.
    static let schema = DatabaseTables.items.rawValue

    @ID(key: .id)
    var id: UUID?

    @Field(key: "index")
    var index: String
    @Field(key: "unique_name")
    var uniqueName: String
    @Field(key: "localisation_name_key")
    var localisationNameKey: String
    @Field(key: "localisation_description_key")
    var localisationDescriptionKey: String
    @Children(for: \.$item)
    var localisedNames: [LocalisedItem]
    @Children(for: \.$item)
    var localisedDescriptions: [LocalisedItem]

    enum CodingKeys: String, CodingKey {
        case index = "Index"
        case uniqueName = "UniqueName"
        case localisationNameKey = "LocalizationNameVariable"
        case localisationDescriptionKey = "LocalizationDescriptionVariable"
        case localisedNames = "LocalizedNames"
        case localisedDescriptions = "LocalizedDescriptions"
    }
    //for fluent
    init() { }

    init(id: UUID? = nil,
         index: String,
         uniqueName: String,
         localisationNameKey: String,
         localisationDescriptionKey: String,
         localisedNames: [LocalisedItem],
         localisedDescriptions: [LocalisedItem]) {
        self.id = id
        self.index = index
        self.uniqueName = uniqueName
        self.localisationNameKey = localisationNameKey
        self.localisationDescriptionKey = localisationDescriptionKey
        self.localisedNames = localisedNames
        self.localisedDescriptions = localisedDescriptions
    }

    init(gitItem: GitItem) {
        self.index = gitItem.index
        self.uniqueName = gitItem.uniqueName
        self.localisationNameKey = gitItem.localisationNameKey
        self.localisationDescriptionKey = gitItem.localisationDescriptionKey
    }
}

extension Item: Content { }
