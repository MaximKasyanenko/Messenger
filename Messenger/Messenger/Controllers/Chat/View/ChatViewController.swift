//
//  ChatViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 07.02.2023.
//

import InputBarAccessoryView
import MessageKit
import UIKit

class ChatViewController: MessagesViewController {
    var isNewConversation = true
    let otherUserEmail: String
    let id: String?
    let nickName: String
    private var messages:[Message] = [] {
        didSet {
            messagesCollectionView.reloadData()
            if !messages.isEmpty {
                isNewConversation = false
            }
            messagesCollectionView.scrollToLastItem()
        }
    }
    private var sender: Sender {
        if let email = UserDefaults.standard.string(forKey: "email") {
            return   Sender(photoURL: "",
                            senderId: email,
                            displayName: "Max")
        }
        return Sender(photoURL: "", senderId: "", displayName: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        listenForMessages()
    }
    
    init(UserEmail: String, nickName: String, id: String?) {
        self.id = id
        self.otherUserEmail = UserEmail
        self.nickName = nickName
        super.init(nibName: nil, bundle: nil)
           
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK: - private func
private extension ChatViewController {
    func setViews() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    func listenForMessages() {
        guard let id = id else { return }
        DatabaseManager.shared.getAllMessagesForConversation(with: id) {[weak self] result in
            switch result {
            case .success(let result):
                self?.messages = result
            case .failure(let error):
                print(error)
            }
        }
    }
}


//MARK: - MessagesDataSource
extension ChatViewController:  MessagesDataSource {
    func currentSender() -> MessageKit.SenderType {
        sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        messages.count
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
            return NSAttributedString(
              string: name,
              attributes: [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: UIColor(white: 0.3, alpha: 1)
              ])
    }
}
//MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
   
}
//MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    
    

    
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? UIColor.blue : UIColor.red
//      }

      // 2
      func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView
      ) -> Bool {
        return false
      }

      // 3
      func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
          let image = UIImageView()
          FBStorageManager.shared.downloadProfilePicture(image: image, email: message.sender.senderId)
          let avatar = Avatar(image: image.image, initials: "sadfad")
          avatarView.set(avatar: avatar)
      }

    
//      // 4
//      func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
//      }
}
//MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        // send message
        let message = Message(sender: sender ,
                              messageId: UUID().uuidString,
                              sentDate: Date(),
                              kind: .text(text))
        if isNewConversation {
            //create database
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, nickName: nickName ) {[weak self] isSucces in
                if isSucces {
                    print("okay")
                    self?.isNewConversation = false
                    inputBar.inputTextView.text = ""
                } else {
                    print("failure")
                }
            }
        } else {
            // append to existing conversation data
            print("next massege")
            guard let id = id else { return }
            DatabaseManager.shared.sendMessage(id: id,otherUserEmail: otherUserEmail, message: message) { succes in
                if succes {
                    inputBar.inputTextView.text = ""
                } else {
                    print("send error")
                }
            }
        }
    }
}
