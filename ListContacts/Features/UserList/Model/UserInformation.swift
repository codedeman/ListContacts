//
//  UserInformation.swift
//  ListContacts
//
//  Created by Kevin on 8/5/24.
//

import Foundation

struct Test: Codable {
    let login: String
    let id: Int
    let avatar_url: String

}

enum UserInformationDecodingError: Error {
    case invalidURL(field: String)
    case invalidDate(field: String)
}

struct UserInformation: Codable, Equatable {
    let login: String?
    let id: Int?
    let nodeId: String?
    let avatarUrl: String?
    let gravatarId: String?
    let url: String?
    let htmlUrl: String?
    let followersUrl: String?
    let followingUrl: String?
    let gistsUrl: String?
    let starredUrl: String?
    let subscriptionsUrl: String?
    let organizationsUrl: String?
    let reposUrl: String?
    let eventsUrl: String?
    let receivedEventsUrl: String?
    let type: String?
    let isAdmin: Bool?
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let hireable: Bool?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int?
    let publicGists: Int?
    let followers: Int?
    let following: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeId = "node_id"
        case avatarUrl = "avatar_url"
        case gravatarId = "gravatar_id"
        case url
        case htmlUrl = "html_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
        case gistsUrl = "gists_url"
        case starredUrl = "starred_url"
        case subscriptionsUrl = "subscriptions_url"
        case organizationsUrl = "organizations_url"
        case reposUrl = "repos_url"
        case eventsUrl = "events_url"
        case receivedEventsUrl = "received_events_url"
        case type
        case isAdmin = "site_admin"
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}


class UserInformationBuilder {
    private var login: String = ""
    private var id: Int = 0
    private var nodeId: String = ""
    private var avatarUrl: String = ""
    private var gravatarId: String = ""
    private var url: String = ""
    private var htmlUrl: String = ""
    private var followersUrl: String = ""
    private var followingUrl: String = ""
    private var gistsUrl: String = ""
    private var starredUrl: String = ""
    private var subscriptionsUrl: String = ""
    private var organizationsUrl: String = ""
    private var reposUrl: String = ""
    private var eventsUrl: String = ""
    private var receivedEventsUrl: String = ""
    private var type: String = ""
    private var isAdmin: Bool = false
    private var name: String? = nil
    private var company: String? = nil
    private var blog: String? = nil
    private var location: String? = nil
    private var email: String? = nil
    private var hireable: Bool? = nil
    private var bio: String = ""
    private var twitterUsername: String? = nil
    private var publicRepos: Int = 0
    private var publicGists: Int = 0
    private var followers: Int = 0
    private var following: Int = 0
    private var createdAt: String = ""
    private var updatedAt: String = ""

    func setLogin(_ login: String) -> UserInformationBuilder {
        self.login = login
        return self
    }

    func setId(_ id: Int) -> UserInformationBuilder {
        self.id = id
        return self
    }

    func setNodeId(_ nodeId: String) -> UserInformationBuilder {
        self.nodeId = nodeId
        return self
    }

    func setAvatarUrl(_ avatarUrl: String) -> UserInformationBuilder {
        self.avatarUrl = avatarUrl
        return self
    }

    func setGravatarId(_ gravatarId: String) -> UserInformationBuilder {
        self.gravatarId = gravatarId
        return self
    }

    func setUrl(_ url: String) -> UserInformationBuilder {
        self.url = url
        return self
    }

    func setHtmlUrl(_ htmlUrl: String) -> UserInformationBuilder {
        self.htmlUrl = htmlUrl
        return self
    }

    func setFollowersUrl(_ followersUrl: String) -> UserInformationBuilder {
        self.followersUrl = followersUrl
        return self
    }

    func setFollowingUrl(_ followingUrl: String) -> UserInformationBuilder {
        self.followingUrl = followingUrl
        return self
    }

    func setGistsUrl(_ gistsUrl: String) -> UserInformationBuilder {
        self.gistsUrl = gistsUrl
        return self
    }

    func setStarredUrl(_ starredUrl: String) -> UserInformationBuilder {
        self.starredUrl = starredUrl
        return self
    }

    func setSubscriptionsUrl(_ subscriptionsUrl: String) -> UserInformationBuilder {
        self.subscriptionsUrl = subscriptionsUrl
        return self
    }

    func setOrganizationsUrl(_ organizationsUrl: String) -> UserInformationBuilder {
        self.organizationsUrl = organizationsUrl
        return self
    }

    func setReposUrl(_ reposUrl: String) -> UserInformationBuilder {
        self.reposUrl = reposUrl
        return self
    }

    func setEventsUrl(_ eventsUrl: String) -> UserInformationBuilder {
        self.eventsUrl = eventsUrl
        return self
    }

    func setReceivedEventsUrl(_ receivedEventsUrl: String) -> UserInformationBuilder {
        self.receivedEventsUrl = receivedEventsUrl
        return self
    }

    func setType(_ type: String) -> UserInformationBuilder {
        self.type = type
        return self
    }

    func setIsAdmin(_ isAdmin: Bool) -> UserInformationBuilder {
        self.isAdmin = isAdmin
        return self
    }

    func setName(_ name: String?) -> UserInformationBuilder {
        self.name = name
        return self
    }

    func setCompany(_ company: String?) -> UserInformationBuilder {
        self.company = company
        return self
    }

    func setBlog(_ blog: String?) -> UserInformationBuilder {
        self.blog = blog
        return self
    }

    func setLocation(_ location: String?) -> UserInformationBuilder {
        self.location = location
        return self
    }

    func setEmail(_ email: String?) -> UserInformationBuilder {
        self.email = email
        return self
    }

    func setHireable(_ hireable: Bool?) -> UserInformationBuilder {
        self.hireable = hireable
        return self
    }

    func setBio(_ bio: String) -> UserInformationBuilder {
        self.bio = bio
        return self
    }

    func setTwitterUsername(_ twitterUsername: String?) -> UserInformationBuilder {
        self.twitterUsername = twitterUsername
        return self
    }

    func setPublicRepos(_ publicRepos: Int) -> UserInformationBuilder {
        self.publicRepos = publicRepos
        return self
    }

    func setPublicGists(_ publicGists: Int) -> UserInformationBuilder {
        self.publicGists = publicGists
        return self
    }

    func setFollowers(_ followers: Int) -> UserInformationBuilder {
        self.followers = followers
        return self
    }

    func setFollowing(_ following: Int) -> UserInformationBuilder {
        self.following = following
        return self
    }

    func setCreatedAt(_ createdAt: String) -> UserInformationBuilder {
        self.createdAt = createdAt
        return self
    }

    func setUpdatedAt(_ updatedAt: String) -> UserInformationBuilder {
        self.updatedAt = updatedAt
        return self
    }

    func build() -> UserInformation {
        return UserInformation(
            login: login,
            id: id,
            nodeId: nodeId,
            avatarUrl: avatarUrl,
            gravatarId: gravatarId,
            url: url,
            htmlUrl: htmlUrl,
            followersUrl: followersUrl,
            followingUrl: followingUrl,
            gistsUrl: gistsUrl,
            starredUrl: starredUrl,
            subscriptionsUrl: subscriptionsUrl,
            organizationsUrl: organizationsUrl,
            reposUrl: reposUrl,
            eventsUrl: eventsUrl,
            receivedEventsUrl: receivedEventsUrl,
            type: type,
            isAdmin: isAdmin,
            name: name,
            company: company,
            blog: blog,
            location: location,
            email: email,
            hireable: hireable,
            bio: bio,
            twitterUsername: twitterUsername,
            publicRepos: publicRepos,
            publicGists: publicGists,
            followers: followers,
            following: following,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}


