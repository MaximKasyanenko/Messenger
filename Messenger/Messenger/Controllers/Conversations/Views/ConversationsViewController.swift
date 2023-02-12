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
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
       return tableView
    }()
    
    var conversation = [Conversation]() {
        didSet {
            tableview.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setLayout()
        startListeningForCOnversations()
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
    private func startListeningForCOnversations() {
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        DatabaseManager.shared.getAllConversations(for: email) {[weak self] result in
            switch result {
            case .success(let conversation):
                guard !conversation.isEmpty else { return }
                self?.conversation = conversation
                
            case .failure(let error):
                print("failure \(error)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if conversation.isEmpty {
            startListeningForCOnversations()
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
        vc.complition = { [weak self] result in
            self?.createNewConversation(result: result)
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    func createNewConversation(result: [String: String]) {
        guard let nickName = result["nickName"],
              let email = result["email"] else { return }
        let vc = ChatViewController(UserEmail: email, nickName: nickName, id: nil)
        vc.isNewConversation = true
        vc.title = nickName
        navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK: - TableViewDelegate
extension ConversationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = conversation[indexPath.row]
        let vc = ChatViewController(UserEmail: model.otherUserEmail, nickName: model.name, id: model.id)
        vc.title = model.name
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
//MARK: - TableViewDataSource
extension ConversationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        
        cell.configure(model: conversation[indexPath.row])
        return cell
    }
    
    
}
