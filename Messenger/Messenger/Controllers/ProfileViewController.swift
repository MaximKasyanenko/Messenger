//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
       
    }
    
}
//MARK: - @objc func
@objc
extension ProfileViewController {
    func signOut() {
        let alert = UIAlertController(title: "", message: "Do you really want to log out of your account?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Log Out", style: .destructive) { alert in
            AuthManager.shared.signOut()
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
//MARK: - private func
private extension ProfileViewController {
    func setController() {
        let image = UIImage(systemName: "figure.walk.arrival")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(signOut))
    }
}
