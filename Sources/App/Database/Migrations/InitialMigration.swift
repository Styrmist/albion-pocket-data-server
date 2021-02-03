//
//  File.swift
//  
//
//  Created by Kirill Danilov on 03/02/2021.
//

import Fluent

struct InitialMigration: Migration {

    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(Item.schema)
                .id()
                .field(.itemIndex, .string, .required)
                .field(.uniqueName, .string, .required)
                .unique(on: .itemIndex, .uniqueName)
                .create(),
            database.schema(LocalisedItem.schema)
                .id()
                .field(.language, .string, .required)
                .field(.translation, .string, .required)
                .field(.type, .enum(.init(name: "localised_item_type",
                                          cases: LocalisedItemType.allCases.compactMap { $0.rawValue })), .required)
                .field(.itemId, .uuid, .required)
                .foreignKey(.itemId, references: Item.schema, .id, onDelete: .cascade, onUpdate: .cascade)
                .create()
        ])
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.eventLoop.flatten([
            database.schema(Item.schema).delete(),
            database.schema(LocalisedItem.schema).delete()
        ])
    }
}
