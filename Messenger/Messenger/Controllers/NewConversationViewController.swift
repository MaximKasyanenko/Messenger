//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class NewConversationViewController: UIViewController {
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
   setViews()
       
    }
}

private extension NewConversationViewController {
    func setViews() {
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
    
}
//MARK: - TableViewDataSource
extension NewConversationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}
