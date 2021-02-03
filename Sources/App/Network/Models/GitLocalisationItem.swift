//
//  File.swift
//
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Foundation
import Vapor

// to convert response from items.json from git
//
// "EN-US": "Hideout Construction Kit",
// "DE-DE": "Unterschlupf-Baukasten",
// "FR-FR": "Kit de construction de repaire"...

final class GitLocalisationItem: Content {

    let localisation: [LocalisationLanguage: String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: LocalisationLanguage.self)
        var localisation = [LocalisationLanguage: String]()
        for language in LocalisationLanguage.allCases {
            localisation[language] = try container.decode(String.self, forKey: language)
        }
        self.localisation = localisation
    }
}
