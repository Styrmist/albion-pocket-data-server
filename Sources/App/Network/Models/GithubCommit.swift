//
//  File.swift
//  
//
//  Created by Kirill on 21.09.2020.
//

import Foundation

// MARK: - CommitElement
struct CommitElement: Codable {
    let sha, nodeID: String?
    let commit: CommitClass?
    let url, htmlURL, commentsURL: String?
    let author, committer: CommitAuthor?
//    let parents: [Parent]?
}

// MARK: - CommitAuthor
struct CommitAuthor: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url, htmlURL, followersURL: String?
    let followingURL, gistsURL, starredURL: String?
    let subscriptionsURL, organizationsURL, reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: String?
    let siteAdmin: Bool?
}

// MARK: - CommitClass
struct CommitClass: Codable {
    let author, committer: CommitAuthorClass?
    let message: String?
    let tree: Tree?
    let url: String?
    let commentCount: Int?
    let verification: Verification?
}

// MARK: - CommitAuthorClass
struct CommitAuthorClass: Codable {
    let name, email: String?
    let date: Date?
}

// MARK: - Tree
struct Tree: Codable {
    let sha: String?
    let url: String?
}

// MARK: - Verification
struct Verification: Codable {
    let verified: Bool?
    let reason: String?
}

// MARK: - Parent
//struct Parent: Codable {
//    let sha: String?
//    let url, htmlURL: String?
//}
