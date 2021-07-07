//
//  ChatViewController.swift
//  Messenger
//
//  Created by Oybek on 7/7/21.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}
class ChatViewController: MessagesViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messages.append(Message(sender: selfSender, messageId: "1", sentDate: Date(), kind: .text("Hello worldssss")))
    }
    // MARK: - Properties
    private var messages = [Message]()
    private var selfSender = Sender(photoURL: "", senderId: "1", displayName: "John Doe")
    // MARK: - Selectors
    // MARK: - API
    // MARK: - Functions
}
// MARK: - MessagesDelegate/DataSource
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return selfSender
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
