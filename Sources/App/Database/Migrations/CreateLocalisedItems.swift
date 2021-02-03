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
        database.schema(DatabaseTables.localisedItemNames.rawValue)
            .id()
            .field("language", .string)
            .field("string", .string)
            .field("item", .uuid, .references("items", "id"))
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(DatabaseTables.localisedItemNames.rawValue).delete()
    }
}
