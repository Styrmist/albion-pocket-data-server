//
//  File.swift
//  
//
//  Created by Kirill Danilov on 01/02/2021.
//

import Foundation

public final class GithubPath {
    let user: String
    let repo: String
    let path: String

    init(user: String, repo: String, path: String) {
        self.user = user
        self.repo = repo
        self.path = path
    }
}
