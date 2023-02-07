//
//  LoginViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class LoginViewController: UIViewController {
    private let emailField: AutField = {
        let view = AutField()
        view.placeholder = "Email Address.."
        view.keyboardType = .emailAddress
        return view
    }()
    
    private let passwordlField: AutField = {
        let view = AutField()
        view.placeholder = "Password.."
        view.isSecureTextEntry = true
        return view
    }()
    
    private let loginButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Log In", for: .normal)
        view.backgroundColor = .link
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        view.layer .borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       configure()
        setViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setLayout()
    }
}
//MARK: - Private func
private extension LoginViewController {
     func setViews() {
         view.addSubview(emailField)
         view.addSubview(passwordlField)
         view.addSubview(loginButton)
    }
    
    func configure() {
        title = "Login in"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        loginButton.addTarget(self,
                               action: #selector(loginButtonTap),
                               for: .touchUpInside)
        emailField.delegate = self
        passwordlField.delegate = self
    }
    //MARK: - Layout
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            emailField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            emailField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            passwordlField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30),
            passwordlField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            passwordlField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
           
            loginButton.topAnchor.constraint(equalTo: passwordlField.bottomAnchor, constant: 30),
            loginButton.centerXAnchor.constraint(equalTo: passwordlField.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: passwordlField.widthAnchor)
      
        ])
    }
    
}
//MARK: - @objc func
@objc
extension LoginViewController {
    private func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func loginButtonTap() {
        guard let email = emailField.text,
              let password = passwordlField.text else { return }
        AuthManager.shared.logIn(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let result):
                let user = result.user
                print(user)
                    self?.dismiss(animated: true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
//MARK: - TextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailField:
            passwordlField.becomeFirstResponder()
        case passwordlField:
            passwordlField.resignFirstResponder()
            break
        default: break
        }
        return true
    }
}
