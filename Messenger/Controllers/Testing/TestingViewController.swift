//
//  TestingViewController.swift
//  Messenger
//
//  Created by administrator on 03/11/2021.
//

import UIKit

class TestingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//
//
//import UIKit
//import MessageKit
//
//import FirebaseAuth
//import FirebaseDatabase
//
//import InputBarAccessoryView
//
//class ChatViewController: MessagesViewController {
//    
//    var messages = [Message]()
//    
//    // Testing varibels
//    //let testuserID = Auth.auth().currentUser?.uid
//    //let senderUser = Sender(senderId: "2", displayName: "Nada", profileImage: "")
//    
//    
//    // Platform Varibles
//    public var otherUserEmail: String?
//    private var conversationId: String?
//    public var isNewConversation = false
//    
//    //Date Formating to string
//    public static var dateFormatter: DateFormatter = {
//            let formatter = DateFormatter()
//            formatter.dateStyle = .medium
//            formatter.timeStyle = .long
//            formatter.locale = .current
//            return formatter
//    }()
//    
//    // Returen self sender
//    private var selfSender: Sender? {
//        guard let userID = UserDefaults.standard.value(forKey: "user id") as? String else {
//            return nil
//        }
//        return Sender(senderId: userID, displayName: "Me", profileImage: "")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setUpChat()
//        removeMessageAvatars()
//    }
//    
//    // Set up ChatVC
//    func setUpChat(){
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.95, green: 0.52, blue: 0.44, alpha: 1.00)
//        self.navigationController?.isNavigationBarHidden = false
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
//    }
//    
//    // Insert new message in UI
//    private func insertNewMessage(_ message: Message) {
//        if messages.contains(where: {$0.messageId == message.messageId}) {
//           return
//        }
//        messages.append(message)
//        messagesCollectionView.reloadData()
//        messagesCollectionView.scrollToLastItem(animated: true)
//    }
//    
////    Test Messages
////    override func viewDidAppear(_ animated: Bool) {
////      super.viewDidAppear(animated)
////        let testMessage = Message(sender: currentSender(), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello"))
////        insertNewMessage(testMessage)
////        let testMessage2 = Message(sender: senderUser, messageId: "2", sentDate: Date().addingTimeInterval(-70000), kind: .text("Hi"))
////        insertNewMessage(testMessage2)
////    }
//    
//    
//    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
////        DatabaseManger.shared.getAllMessagesForConversation(with: id) { [weak self] result in
////        switch result {
////
////            case .success(let messages):
////                print("success in getting messages: \(messages)")
////                guard !messages.isEmpty else {
////                    print("messages are empty")
////                    return
////                }
////                self?.messages = messages
////
////                DispatchQueue.main.async {
////                    self?.messagesCollectionView.reloadDataAndKeepOffset()
////                    if shouldScrollToBottom {
////                        self?.messagesCollectionView.scrollToLastItem()
////                    }
////                }
////
////            case .failure(let error):
////                print("failed to get messages: \(error)")
////            }
////        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        messageInputBar.inputTextView.becomeFirstResponder()
//        if let conversationId = conversationId {
//            listenForMessages(id:conversationId, shouldScrollToBottom: true)
//        }
//    }
//}
//
//
//// MARK: - MessagesDataSource
//extension ChatViewController: MessagesDataSource {
//    
//    // 1 Number of messages
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//    return messages.count
//    }
//
//    // 2 Current sender = current user
//    func currentSender() -> SenderType {
//        if let sender = selfSender {
//            return sender
//        }
//        return Sender(senderId: "12", displayName: "erroe", profileImage: "")
//    }
//
//    // 3 Show messsages
//    func messageForItem( at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView ) -> MessageType {
//    return messages[indexPath.section]
//    }
//
//    // 4 Name above messages
//    func messageTopLabelAttributedText( for message: MessageType, at indexPath: IndexPath ) -> NSAttributedString? {
//        let name = message.sender.displayName
//            return NSAttributedString(string: name, attributes: [.font:
//                                                                UIFont.preferredFont(forTextStyle: .caption1),
//                                                                 .foregroundColor: UIColor(white: 0.3, alpha: 1)])
//    }
//}
//
//// MARK: - MessagesLayoutDelegate
//extension ChatViewController: MessagesLayoutDelegate {
//  // 1
//  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
//    return CGSize(width: 0, height: 8)
//  }
//
//  // 2
//  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//    return 20
//  }
//}
//
//// MARK: - MessagesDisplayDelegate
//extension ChatViewController: MessagesDisplayDelegate {
//  
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        // color if every user message
//      return isFromCurrentSender(message: message) ?
//        UIColor(red: 0.95, green: 0.52, blue: 0.44, alpha: 1.00) :
//        UIColor(red: 0.86, green: 0.45, blue: 0.67, alpha: 1.00)
//    }
//    
//    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
//        return false
//    }
//    
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.isHidden = true
//    }
//    
//    // style of image shape
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .curved)
//    }
//    
//    private func removeMessageAvatars() {
//      guard
//        let layout = messagesCollectionView.collectionViewLayout
//          as? MessagesCollectionViewFlowLayout
//      else {
//        return
//      }
//      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
//      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
//      layout.setMessageIncomingAvatarSize(.zero)
//      layout.setMessageOutgoingAvatarSize(.zero)
//      let incomingLabelAlignment = LabelAlignment(
//        textAlignment: .left,
//        textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
//      layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
//      let outgoingLabelAlignment = LabelAlignment(
//        textAlignment: .right,
//        textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
//      layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
//    }
//}
//
//
////extension ChatViewController:
//
//
//extension ChatViewController: InputBarAccessoryViewDelegate {
//    
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let selfSender = self.selfSender, let messageId = createMessageId()  else {
//            return
//        }
//        print("sending \(text)")
//        
//        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
//        
//        // Send message
//        if isNewConversation {
//            // create convo in database
//            // message ID should be a unique ID for the given message, unique for all the message
//            // use random string or random number
////            DatabaseManger.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message) { [weak self] success in
////                if success {
////                    print("message sent")
////                    self?.isNewConversation = false
////                }else{
////                    print("failed to send")
////                }
////            }
//            
//        }else {
//            guard let conversationId = conversationId, let name = self.title else {
//                return
//            }
//            
//            // append to existing conversation data
////            DatabaseManger.shared.sendMessage(to: conversationId, name: name, newMessage: message) { success in
////                if success {
////                    print("message sent")
////                }else {
////                    print("failed to send")
////                }
////            }
//            
//        }
//        
//    }
//    private func createMessageId() -> String? {
//        // date, otherUserEmail, senderEmail, randomInt possibly
//        // capital Self because its static
//    
//        guard let currentUserEmail = Auth.auth().currentUser?.email else {
//            return nil
//        }
//        
//        let dateString = Self.dateFormatter.string(from: Date())
//        let newIdentifier = "\(currentUserEmail)_\(dateString)"
//        
//    
//        print("created message id: \(newIdentifier)")
//        return newIdentifier
//        
//    }
//}
