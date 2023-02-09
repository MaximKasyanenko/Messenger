//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 09.02.2023.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
   static let identifier = "ConversationTableViewCell"
    private let userImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configure(model: Conversation) {
        userNameLabel.text = model.name
        userMessageLabel.text = model.latestMessage.text
        FBStorageManager.shared.downloadProfilePicture(image: userImageView, email: model.otherUserEmail)
    }
    
    private func setViews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
       
      
        
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
           
            
            
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
           // userImageView.heightAnchor.constraint(equalToConstant: 50),
            userImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            userMessageLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 15),
            userMessageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            userMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
          //  userMessageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
