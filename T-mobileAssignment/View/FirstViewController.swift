//
//  FirstViewController.swift
//  T-mobileAssignment
//
//  Created by Kevin Verghese on 6/4/20.
//  Copyright © 2020 Kevin Verghese. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var userSearch: UISearchBar!
    
    private var userViewModel: GithubViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupUserViewModel()
        self.setupSearchBar()
    }
    
    private func setupUserViewModel() {
        self.userViewModel = GithubViewModel()
        self.userViewModel.updateViews = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupSearchBar() {
        self.userSearch.delegate = self
    }
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        let index = indexPath.row
        
        cell.usernameLbl.text = self.userViewModel.login(at: index)
        cell.repoNumLbl.text = self.userViewModel.repoNum(at: index)
        
        self.userViewModel.fetchImage(for: index) { data in
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
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        secondVC.userViewModel = self.userViewModel.makeUserViewModel(for: indexPath.row)
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
}

extension FirstViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.userViewModel.loadUsers(query: searchText)
    }
}
