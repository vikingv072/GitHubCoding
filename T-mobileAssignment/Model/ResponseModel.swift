//
//  ResponseModel.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/5/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import Foundation

struct UserSearchResponse: Codable {
    let items: [User]
}

class User: Codable {
    
    let login: String
    let id: Int
    let avatarUrl: String
    let url: String
    let reposUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
        case url = "url"
        case reposUrl = "repos_url"
    }
    
    init(login: String, id: Int, avatarUrl: String, url: String, reposUrl: String) {
        self.login = login
        self.id = id
        self.avatarUrl = avatarUrl
        self.url = url
        self.reposUrl = reposUrl
    }
}


class UserDetail: Codable {
   
    let login: String
    var email: String?
    let avatarUrl: String?
    var location: String?
    var joinedAt: String?
    var followers: Int
    var following: Int
    var bio: String?
    let url: String
    let reposUrl: String
    let repoNum: Int
    
    enum CodingKeys: String, CodingKey {
        case login, email, location, followers, following, bio, url
        case avatarUrl = "avatar_url"
        case joinedAt = "created_at"
        case repoNum = "public_repos"
        case reposUrl = "repos_url"
    }
    
    init(login: String, avatarUrl: String?,
         email: String?, location: String?,
         joinedAt: String?, followers: Int,
         following: Int, bio: String?,
         url: String, reposUrl: String,
         repoNum: Int) {
        self.login = login
        self.email = email
        self.avatarUrl = avatarUrl
        self.location = location
        self.joinedAt = joinedAt
        self.followers = followers
        self.following = following
        self.bio = bio
        self.url = url
        self.reposUrl = reposUrl
        self.repoNum = repoNum
    }
}


extension UserDetail {
    var avatarImageLink: URL? {
        guard let avatarUrl = avatarUrl else { return nil }
        return URL(string: avatarUrl)
    }
    
    var detailsLink: URL? {
        URL(string: url)
    }
}


struct RepoSearchResponse: Codable {
    let items: [Repo]
}

class Repo: Codable {
    
    let id: Int
    let name: String
    let forks: Int
    let stars: Int
    let link: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case forks = "forks_count"
        case stars = "stargazers_count"
        case link = "svn_url"
    }
    
    init(id: Int, name: String, forks: Int, stars: Int, link: String) {
        self.id = id
        self.name = name
        self.forks = forks
        self.stars = stars
        self.link = link
    }
}
