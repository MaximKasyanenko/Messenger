//
//  ConversationsViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class ConversationsViewController: UIViewController {
    private let tableview: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
       return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let isLogged = AuthManager.shared.checkAuth()
        if !isLogged {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
        }
    }
   
}

private extension ConversationsViewController {
    func setViews() {
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addChat))
    }
    
     func setLayout() {
         let safeArea = view.safeAreaLayoutGuide
         NSLayoutConstraint.activate([
            tableview.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableview.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableview.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
         ])
    }
    @objc func addChat() {
        let vc = NewConversationViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
//MARK: - TableViewDelegate
extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "max"
     
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TableViewDataSource
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "one"
        
        return cell
    }
    
    
}
