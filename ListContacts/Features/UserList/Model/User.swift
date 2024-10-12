//
//  User.swift
//  UserProfile
//
//  Created by Kevin on 8/2/24.
//

import Foundation

public struct User: Identifiable, Codable, Equatable {
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

public class UserBuilder : Codable {
    private var login: String = ""
    private var id: Int = 0
    private var avatarUrl: String = ""
    private var htmlUrl: String = ""
    private var followersUrl: String = ""
    private var followingUrl: String = ""
    private var reposUrl: String = ""
    private var type: String = ""
    private var siteAdmin: Bool = false

    public init() {}

    public func setLogin(_ login: String) -> UserBuilder {
        self.login = login
        return self
    }

    public func setId(_ id: Int) -> UserBuilder {
        self.id = id
        return self
    }

    public func setAvatarUrl(_ avatarUrl: String) -> UserBuilder {
        self.avatarUrl = avatarUrl
        return self
    }

    public func setHtmlUrl(_ htmlUrl: String) -> UserBuilder {
        self.htmlUrl = htmlUrl
        return self
    }

    public func setFollowersUrl(_ followersUrl: String) -> UserBuilder {
        self.followersUrl = followersUrl
        return self
    }

    public func setFollowingUrl(_ followingUrl: String) -> UserBuilder {
        self.followingUrl = followingUrl
        return self
    }

    public func setReposUrl(_ reposUrl: String) -> UserBuilder {
        self.reposUrl = reposUrl
        return self
    }

    public func setType(_ type: String) -> UserBuilder {
        self.type = type
        return self
    }

    public func setSiteAdmin(_ siteAdmin: Bool) -> UserBuilder {
        self.siteAdmin = siteAdmin
        return self
    }

    public func build() -> User {
        return User(
            login: login,
            id: id,
            avatarUrl: avatarUrl,
            htmlUrl: htmlUrl,
            followersUrl: followersUrl,
            followingUrl: followingUrl,
            reposUrl: reposUrl,
            type: type,
            siteAdmin: siteAdmin
        )
    }
}


