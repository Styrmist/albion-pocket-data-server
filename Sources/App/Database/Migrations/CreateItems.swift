//
//  File.swift
//  
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Fluent

struct CreateItems: Migration {
    // Prepares the database for storing Star models.
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Item.schema)
            .id()
            .field(.index, .string, .required)
            .field(.uniqueName, .string, .required)
            .unique(on: .index)
            .unique(on: .uniqueName, .index)
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(DatabaseTables.items.rawValue).delete()
    }
}
