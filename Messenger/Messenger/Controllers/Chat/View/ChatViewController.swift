//
//  ChatViewController.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 07.02.2023.
//
import MessageKit
import UIKit

class ChatViewController: MessagesViewController {
    private var messages:[Message] = []
    private var sender = Sender(photoURL: "", senderId: "1", displayName: "Max")
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        messages.append(Message(sender: sender , messageId: "122", sentDate: Date(), kind: .text("hallo")))
    }
    
    
}
extension ChatViewController {
    func setViews() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
}

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
    
    
   
    
}

extension ChatViewController: MessagesLayoutDelegate {
    
}

extension ChatViewController: MessagesDisplayDelegate {
    
}
