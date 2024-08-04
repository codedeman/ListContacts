//
//  User.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation

public struct User: Identifiable, Codable {
    public let login: String
    public let id: Int
    public let avatarUrl: String
    public let htmlUrl: String
    public let followersUrl: String
    public let followingUrl: String
    public let reposUrl: String
    public let type: String
    public let siteAdmin: Bool

    public enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case reposUrl = "repos_url"
        case type
        case siteAdmin = "site_admin"
    }
}
