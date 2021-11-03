

import UIKit
import MessageKit

import FirebaseAuth
import FirebaseDatabase

import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    var conversation = Conversation()
    var messages = [Message]()
    
    public var friendId : String?
    public var friendName : String?
    
    // Platform Varibles
    public var isNewConversation = false
    
    //Date Formating to string
    public static var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .long
            formatter.locale = .current
            return formatter
    }()
    
    // Returen self sender
    private var selfSender: Sender? {
        guard let userID = Auth.auth().currentUser?.uid else {
            return nil
        }
        return Sender(senderId: userID, displayName: "Me", profileImage: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChat()
        let testMessage = Message(sender: Sender(senderId: "0", displayName: "defulte", profileImage: ""), messageId: "2", sentDate: Date().addingTimeInterval(-70000), kind: .text("Hello World!"))
        insertNewMessage(testMessage)
    }
    
    // Set up ChatVC
    func setUpChat(){
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.95, green: 0.52, blue: 0.44, alpha: 1.00)
        self.navigationController?.isNavigationBarHidden = false
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        removeMessageAvatars()
    }
     
    // Insert new message in UI
    private func insertNewMessage(_ message: Message) {
        if messages.contains(where: {$0.messageId == message.messageId}) {
           return
        }
        messages.append(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
        
        self.conversation.messages.append(message)
//        DatabaseManger.shared.insertMessage(with: conversation) { success in
//            print("success add message")
//        }
    }
    
//    Test Messages
//    override func viewDidAppear(_ animated: Bool) {
//      super.viewDidAppear(animated)
//        let testMessage = Message(sender: currentSender(), messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello"))
//        insertNewMessage(testMessage)
//        let testMessage2 = Message(sender: senderUser, messageId: "2", sentDate: Date().addingTimeInterval(-70000), kind: .text("Hi"))
//        insertNewMessage(testMessage2)
//    }

}


// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    // 1 Number of messages
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
    }

    // 2 Current sender = current user
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        return Sender(senderId: "12", displayName: "erroe", profileImage: "")
    }

    // 3 Show messsages
    func messageForItem( at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView ) -> MessageType {
        return messages[indexPath.section]
    }

    // 4 Name above messages
    func messageTopLabelAttributedText( for message: MessageType, at indexPath: IndexPath ) -> NSAttributedString? {
        let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [.font:
                                                                UIFont.preferredFont(forTextStyle: .caption1),
                                                                 .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
  // 1
  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  // 2
  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 20
  }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
  
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
      return isFromCurrentSender(message: message) ?
        UIColor(red: 0.95, green: 0.52, blue: 0.44, alpha: 1.00) :
        UIColor(red: 0.86, green: 0.45, blue: 0.67, alpha: 1.00)
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    // style of message shape
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    private func removeMessageAvatars() {
      guard
        let layout = messagesCollectionView.collectionViewLayout
          as? MessagesCollectionViewFlowLayout
      else {
        return
      }
      layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
      layout.textMessageSizeCalculator.incomingAvatarSize = .zero
      layout.setMessageIncomingAvatarSize(.zero)
      layout.setMessageOutgoingAvatarSize(.zero)
      let incomingLabelAlignment = LabelAlignment(
        textAlignment: .left,
        textInsets: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0))
      layout.setMessageIncomingMessageTopLabelAlignment(incomingLabelAlignment)
      let outgoingLabelAlignment = LabelAlignment(
        textAlignment: .right,
        textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15))
      layout.setMessageOutgoingMessageTopLabelAlignment(outgoingLabelAlignment)
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard  let selfSender = self.selfSender, let messageId = createMessageId() else {
            print("something in message is wrong")
            return
        }
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        print("sending: \(text)")
        insertNewMessage(message)
        inputBar.inputTextView.text = ""
        
    }
    
    func createMessageId() -> String? {
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(selfSender?.senderId ?? "null" )_\(dateString)"
        print(newIdentifier)
        return newIdentifier
    }
    
    
}


