//
//  ChatViewController.swift
//  Messenger
//
//  Created by Oybek on 7/7/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

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
        messageInputBar.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
    }
    init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Properties
    public var isNewConversation = false
    public let otherUserEmail: String
    
    private var messages = [Message]()
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") else {return nil}
        Sender(photoURL: "", senderId: email, displayName: "John Doe")
    }
    // MARK: - Selectors
    // MARK: - API
    // MARK: - Functions
}
// MARK: - MessagesDelegate/DataSource
extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("Self Sender is nil, email should be cached")
        return Sender(photoURL: "", senderId: "12", displayName: "John Doe")
    }
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        if !text.replacingOccurrences(of: " ", with: "").isEmpty,
           let selfSender = self.selfSender,
           let messageId = createMessageId() {
            // send message
            if isNewConversation {
                // create conversation in database
                let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
                DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: , completion: <#T##(Bool) -> Void#>)
            } else {
                // append to existing conversation data
            }
        }
        private func createMessageId() -> String? {
            // date, otherUserEmail, senderEmail, randomInt
            guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") else {
                return nil
            }
            let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)"
            return newIdentifier
        }
    }
}
