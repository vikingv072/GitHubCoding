//
//  GithubUserViewModel.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/5/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import Foundation

class GithubUserViewModel {
    
    private let user: UserDetail
    private var _repos = [Repo]() {
        didSet {
            repos = _repos
        }
    }
    private var repos = [Repo]() {
        didSet {
            self.updateViews?()
        }
    }
    var updateViews: (() -> ())?
    
    init(user: UserDetail) {
        self.user = user
    }
    
}

extension GithubUserViewModel {
    
    func fetchRepos() {
        guard let url = URL(string: user.reposUrl) else { return }
        NetworkManager.shared.downloadData(from: url, type: [Repo].self) { [weak self] repos in
            self?._repos = repos
        }
    }
    
    func filterRepos(query: String) {
        guard !query.isEmpty else {
            repos = _repos
            return
        }
        let query = query.lowercased()
        repos = _repos.filter {
            $0.name.lowercased().contains(query)
        }
    }
    
}

// MARK: - Encapsulated Data Accessors

extension GithubUserViewModel {

    func avatarImg(_ completion: @escaping (Data?) -> ()) {
        guard let imageUrl = self.user.avatarImageLink else {
            completion(nil)
            return
        }
        
        completion(nil)
        NetworkManager.shared.downloadAvatar(from: imageUrl) { (data) in
            completion(data)
        }
    }
    var username: String {
        return self.user.login
    }
    var email: String {
        return self.user.email ?? "no email"
    }
    var location: String {
        return self.user.location ?? "no location"
    }
    var joinDate: String {
        return self.user.joinedAt ?? "unknown join date"
    }
    var followers: String {
        return String(self.user.followers) + " Followers"
    }
    var following: String {
        return "Following " + String(self.user.following)
    }
    var bio: String {
        return self.user.bio ?? "no bio"
    }
    
}

// MARK: - Encapsulated Repo Data Accessors

extension GithubUserViewModel {
    
    var repoCount: Int {
        return repos.count
    }
    
    func repoName(at index: Int) -> String {
        return repos[index].name
    }
    
    func repoForks(at index: Int) -> String {
        return String(repos[index].forks) + " Forks"
    }
    
    func repoStars(at index: Int) -> String {
        return String(repos[index].stars) + " Stars"
    }
    
    func repoLink(at index: Int) -> URL? {
        return URL(string: repos[index].link)
    }

}
