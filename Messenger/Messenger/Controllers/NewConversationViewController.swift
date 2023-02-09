//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class NewConversationViewController: UIViewController {
    var complition: (([String: String]) -> ())?
    
    var users: [[String: String]] = [] {
        didSet { tableView.reloadData() }
    }
    
    private let search: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search for Users..."
       search.becomeFirstResponder()
        return search
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseManager.shared.downloadUsers {[weak self] users in
            self?.users = users
        }
   setViews()
      setLayout()
    }
}

private extension NewConversationViewController {
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    func setViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        search.delegate = self
        navigationController?.navigationBar.topItem?.titleView = search
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dissmisTap))
        tableView.delegate = self
        tableView.dataSource = self
    }
    @objc
    func dissmisTap() {
        dismiss(animated: true)
    }
}
//MARK: - SearchBarDelegate
extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
//MARK: - TableViewDelegate
extension NewConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUser = users[indexPath.row]
        dismiss(animated: false) {[weak self] in
            self?.complition?(targetUser)
        }
        
        
    }
}
//MARK: - TableViewDataSource
extension NewConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell()
        cell.textLabel?.text = users[indexPath.row]["nickName"]
        return cell
    }
    
    
}
