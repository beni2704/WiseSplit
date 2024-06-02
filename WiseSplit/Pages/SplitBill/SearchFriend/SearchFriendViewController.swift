//
//  SearchFriendViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 17/05/24.
//

import Foundation
import UIKit

class SearchFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let viewModel = SearchFriendViewModel()
    let titleLabel = UILabel()
    let tableView = UITableView()
    let searchBar = UISearchBar()
    
    weak var delegate: SearchFriendDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
        
        
        searchBar.delegate = self
    }
    
    private func setupSearchBar() {
        titleLabel.text = "Search Friend"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchFriendTableViewCell.self, forCellReuseIdentifier: SearchFriendTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchFriendTableViewCell.identifier, for: indexPath) as? SearchFriendTableViewCell else {
            return UITableViewCell()
        }
        let user = viewModel.filteredUsers[indexPath.row]
        cell.configure(with: user)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterUsers(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        viewModel.searchUsers(byNickname: searchText) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedUser = viewModel.filteredUsers[indexPath.row]
        
        let newPerson = PersonTotal(personUUID: selectedUser.uuid ?? "0", personName: selectedUser.nickname, personPhoneNumber: selectedUser.phone, totalAmount: 0, items: [], isPaid: false, imagePaidUrl: "")
        print(newPerson)
        delegate?.didSelectUser(newPerson)
        
        self.dismiss(animated: true, completion: nil)
    }
}
