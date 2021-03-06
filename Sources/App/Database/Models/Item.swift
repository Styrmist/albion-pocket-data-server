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
    static let schema = "items"

    @ID(key: .id)
    var id: UUID?

    @Field(key: .itemIndex)
    var index: String
    @Field(key: .uniqueName)
    var uniqueName: String
    @Children(for: \.$itemId)
    var localised: [LocalisedItem]

    //for fluent
    init() { }

    init(id: UUID? = nil,
         index: String,
         uniqueName: String,
         localised: [LocalisedItem]) {
        self.id = id
        self.index = index
        self.uniqueName = uniqueName
        self.localised = localised
    }

    init(gitItem: GitItem) {
        self.index = gitItem.index
        self.uniqueName = gitItem.uniqueName
    }

    func update(with gitItem: GitItem) {
        self.index = gitItem.index
        self.uniqueName = gitItem.uniqueName
    }
}

extension Item: Content { }

extension FieldKey {

}
