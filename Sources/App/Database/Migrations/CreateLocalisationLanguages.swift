//
//  File.swift
//  
//
//  Created by Kirill Danilov on 31/01/2021.
//

import Fluent

//struct CreateLocalisationLanguages: Migration {
//    // Prepares the database for storing Star models.
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        database.enum(DatabaseTables.localisationLanguage.rawValue)
//            .case("en")
//            .case("de")
//            .case("fr")
//            .case("ru")
//            .case("pl")
//            .case("es")
//            .case("pt")
//            .case("zh")
//            .case("ko")
//            .create()
//    }
//
//    // Optionally reverts the changes made in the prepare method.
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        database.enum(DatabaseTables.localisationLanguage.rawValue).delete()
//    }
//}
