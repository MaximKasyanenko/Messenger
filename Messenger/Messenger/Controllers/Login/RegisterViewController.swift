//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class RegisterViewController: UIViewController {
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
    
    private let nickNameField: AutField = {
        let view = AutField()
        view.placeholder = "Enter nick name"
        return view
    }()
    
  
    
    private let register: UIButton = {
        let view = UIButton(type: .custom)
        view.setTitle("Register", for: .normal)
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
private extension RegisterViewController {
     func setViews() {
         
         view.addSubview(emailField)
         view.addSubview(passwordlField)
         view.addSubview(register)
         view.addSubview(nickNameField)
    }
    
    func configure() {
        title = "Register"
        view.backgroundColor = .white
        register.addTarget(self,
                               action: #selector(registerButtonTap),
                               for: .touchUpInside)
        emailField.delegate = self
        passwordlField.delegate = self
    }
    
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            emailField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 50),
            emailField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            emailField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            passwordlField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 30),
            passwordlField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            passwordlField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            
            nickNameField.topAnchor.constraint(equalTo: passwordlField.bottomAnchor, constant: 30),
            nickNameField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            nickNameField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
           
            register.topAnchor.constraint(equalTo: nickNameField.bottomAnchor, constant: 30),
            register.centerXAnchor.constraint(equalTo: passwordlField.centerXAnchor),
            register.widthAnchor.constraint(equalTo: passwordlField.widthAnchor),
            
        ])
    }
    
}
//MARK: - @objc func
@objc
extension RegisterViewController {
    private func registerButtonTap() {
       guard let email = emailField.text,
             let password = passwordlField.text, let nickName = nickNameField.text else { return }
        AuthManager.shared.createUser(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let result):
                let user = result.user
                print(user)
                self?.dismiss(animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        let user = ChatAppUser(nickName: nickName, email: email)
        DatabaseManager.shared.insertUser(user: user)
        guard let data = UIImage(named: "more")?.pngData() else { return }
        
        FBStorageManager.shared.uploadProfilePicture(data, fileName: user.proFileImageNane) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}
//MARK: -
extension RegisterViewController: UITextFieldDelegate {
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


