//
//  SecondViewController.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/5/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import UIKit
import SafariServices

class SecondViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var userViewModel: GithubUserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(userViewModel != nil)
        self.setupTableView()
        self.setupUserViewModel()
    }
    
    private func setupUserViewModel() {
        self.userViewModel.updateViews = {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
        }
        self.userViewModel.fetchRepos()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1: // number of repos
            return self.userViewModel.repoCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return userDetailCell(at: indexPath)
        case 1:
            return repoCell(at: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func userDetailCell(at indexPath: IndexPath) -> UserDetailCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "userDetail", for: indexPath) as! UserDetailCell
        self.userViewModel.avatarImg { (data) in
            var image: UIImage?
            defer {
                DispatchQueue.main.async {
                    cell.avatarImg.image = image
                }
            }
            if let data = data {
                image = UIImage(data: data)
            }
        }
        cell.usernameLbl.text = self.userViewModel.username
        cell.emailLbl.text = self.userViewModel.email
        cell.locationLbl.text = self.userViewModel.location
        cell.joinDateLbl.text = self.userViewModel.joinDate
        cell.followersLbl.text = self.userViewModel.followers
        cell.followingLbl.text = self.userViewModel.following
        cell.bioLbl.text = self.userViewModel.bio
        cell.searchBar.delegate = self
        return cell
    }
    
    private func repoCell(at indexPath: IndexPath) -> RepoCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "repo", for: indexPath) as! RepoCell
        let row = indexPath.row
        cell.repoNameLbl.text = self.userViewModel.repoName(at: row)
        cell.forksLbl.text = self.userViewModel.repoForks(at: row)
        cell.starsLbl.text = self.userViewModel.repoStars(at: row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        guard let url = self.userViewModel.repoLink(at: indexPath.row) else { return }
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
    
}

extension SecondViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.userViewModel.filterRepos(query: searchText)
    }
}
