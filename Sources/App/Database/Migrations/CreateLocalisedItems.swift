//
//  File.swift
//  
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Fluent

struct CreateLocalisedItemNames: Migration {
    // Prepares the database for storing Star models.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(LocalisedItem.schema)
            .id()
            .field(.language, .string, .required)
            .field(.string, .string, .required)
            .field(.type, .enum(.init(name: "localised_item_type",
                                       cases: LocalisedItemType.allCases.compactMap { $0.rawValue })), .required)
            .field(.item, .uuid, .references("items", "id"), .required)
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(DatabaseTables.localisedItems.rawValue).delete()
    }
}
