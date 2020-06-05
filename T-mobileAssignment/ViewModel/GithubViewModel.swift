//
//  GithubViewModel.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/5/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import Foundation

class GithubViewModel {
    
//    var imgData = Data()
    var updateViews: (() -> ())?
    
    private var _users = [UserDetail]() { // private array of users (everyone)
        didSet {
            users = _users
        }
    }
    private var users = [UserDetail]() { // what is shown & available
        didSet {
            self.updateViews?()
        }
    }
    var currentQuery: DispatchWorkItem?
    
    func loadUsers(query: String) {
        guard !query.isEmpty else { return }
        currentQuery?.cancel()
        guard let url = RequestPoint.makeURL(query: query) else { return }
        let newQuery = DispatchWorkItem {
            self.getUsers(url)
        }
        currentQuery = newQuery
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.45, execute: newQuery)
    }
    
    private func getUsers(_ url: URL) {
        NetworkManager.shared.downloadData(from: url, type: UserSearchResponse.self) { [weak self] (response) in
            self?.getDetails(for: response.items)
        }
    }
    
    private func getDetails(for items: [User]) {
        var users = [UserDetail]()
        let queue = DispatchQueue(label: "loadUsers:query", qos: .userInitiated, attributes: .concurrent)
        let group = DispatchGroup()
        items.forEach {
            guard let url = URL(string: $0.url) else { return }
            group.enter()
            NetworkManager.shared.downloadData(from: url, type: UserDetail.self) { infoDetails in
                queue.sync(flags: .barrier) {
                    users.append(infoDetails)
                    group.leave()
                }
            }
        }
        group.notify(queue: .global(qos: .userInitiated)) { [weak self] in
            self?._users = users
        }
    }
    
}

// MARK: - Encapsulated Data Accessors

extension GithubViewModel {
    
    var count: Int {
        return self.users.count
    }
    
    func login(at index: Int) -> String {
        return self.users[index].login
    }
    
    func repoNum(at index: Int) -> String {
        return "Repos: " + String(self.users[index].repoNum)
    }

    func fetchImage(for index: Int, _ completion: @escaping (Data?) -> ()) {
        guard let imageUrl = self.users[index].avatarImageLink else {
            completion(nil)
            return
        }

        completion(nil)
        NetworkManager.shared.downloadAvatar(from: imageUrl) { (data) in
            completion(data)
        }
    }
    
    func makeUserViewModel(for index: Int) -> GithubUserViewModel {
        return GithubUserViewModel(user: self.users[index])
    }
}
