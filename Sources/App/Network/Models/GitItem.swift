//
//  File.swift
//
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Foundation
import Vapor

final class GitItem: Content {

    var index: String
    var uniqueName: String
    var localisationNameKey: String
    var localisationDescriptionKey: String
    var localisedNames: GitLocalisationItem?
    var localisedDescriptions: GitLocalisationItem?

    enum CodingKeys: String, CodingKey {
        case index = "Index"
        case uniqueName = "UniqueName"
        case localisationNameKey = "LocalizationNameVariable"
        case localisationDescriptionKey = "LocalizationDescriptionVariable"
        case localisedNames = "LocalizedNames"
        case localisedDescriptions = "LocalizedDescriptions"
    }
    init(index: String,
         uniqueName: String,
         localisationNameKey: String,
         localisationDescriptionKey: String,
         localisedNames: GitLocalisationItem,
         localisedDescriptions: GitLocalisationItem) {
        self.index = index
        self.uniqueName = uniqueName
        self.localisationNameKey = localisationNameKey
        self.localisationDescriptionKey = localisationDescriptionKey
        self.localisedNames = localisedNames
        self.localisedDescriptions = localisedDescriptions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(String.self, forKey: .index)
        self.uniqueName = try container.decode(String.self, forKey: .uniqueName)
        self.localisationNameKey = try container.decode(String.self, forKey: .localisationNameKey)
        self.localisationDescriptionKey = try container.decode(String.self, forKey: .localisationDescriptionKey)
        self.localisedNames = try? container.decode(GitLocalisationItem.self, forKey: .localisedNames)
        self.localisedDescriptions = try? container.decode(GitLocalisationItem.self, forKey: .localisedDescriptions)
    }
}
