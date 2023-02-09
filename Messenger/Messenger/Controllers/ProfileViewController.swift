//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class ProfileViewController: UIViewController {

   
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setController()
       
       FBStorageManager.shared.downloadProfilePicture(image: image)
        tableView.dataSource = self
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

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    
}
