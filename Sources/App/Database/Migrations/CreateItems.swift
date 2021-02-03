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
        database.schema(DatabaseTables.items.rawValue)
            .id()
            .field("index", .string)
            .field("unique_name", .string)
            .field("localisation_name_key", .string)
            .field("localisation_description_key", .string)
//            .field("localised_names", .array(of: .uuid), .references("LocalisedItemNames", "item"))
//            .field("localised_descriptions", .array(of: .uuid), .references("LocalisedItemDescriptions", "item"))
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(DatabaseTables.items.rawValue).delete()
    }
}
