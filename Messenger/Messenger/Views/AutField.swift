//
//  AutField.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import UIKit

class AutField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        autocapitalizationType = .none
        autocorrectionType = .no
        returnKeyType = .continue
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        font = .systemFont(ofSize: 20, weight: .bold)
        leftView = .init(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        leftViewMode = .always
        backgroundColor = .white
        
    }
}
