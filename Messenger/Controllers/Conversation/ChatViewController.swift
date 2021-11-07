

import UIKit
import MessageKit

import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import InputBarAccessoryView

class ChatViewController: MessagesViewController {
    
    var conversation : Conversation?
    var messages = [Message]()
    

    // Platform Varibles
    public var otherUserName: String?
    public var otherUserEmail: String?
    public var otherUserId: String?
    public var isNewConversation = false
    
    // Date Formating to string
    public static var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .long
            formatter.locale = .current
            return formatter
    }()
    
    // Returen self sender who is current user
    private var selfSender: Sender? {
        guard let userID = Auth.auth().currentUser?.uid, let userName = defaults.string(forKey: "cuerrentUserName") else {
            return nil
        }
        return Sender(senderId: userID, displayName: userName, profileImage: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChat()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        listenForMessages(shouldScrollToBottom: true)
    }
    
    // Set up chat UI
    private func setUpChat(){
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.95, green: 0.52, blue: 0.44, alpha: 1.00)
        self.navigationController?.isNavigationBarHidden = false
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        removeMessageAvatars()
    }
    
    // Insert new message in chat UI and store in firebase
    private func insertNewMessage(_ message: Message) {
        if messages.contains(where: {$0.messageId == message.messageId}) {
           return
        }
        //listenForMessages(shouldScrollToBottom: true)
        messages.append(message)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
        
        DatabaseManger.shared.insertMessage(with: message) { success in
            print("success add message")
        }
    }

    private func convertStringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: stringDate)
        return date ?? Date()
    }

    private func listenForMessages(shouldScrollToBottom: Bool) {
        DatabaseManger.shared.getAllMessagesForConversation { [weak self] messagesResult in            
            switch messagesResult {
                case .success(let messages):
                    print("success in getting messages: \(messages)")
                    guard !messages.isEmpty else {
                        print("messages are empty")
                        return
                    }
                    self?.messages = messages
                    DispatchQueue.main.async {
                        self?.messagesCollectionView.reloadDataAndKeepOffset()
                        if shouldScrollToBottom {
                            self?.messagesCollectionView.scrollToLastItem()
                        }
                    }
                    
                case .failure(let error):
                    print("failed to get messages: \(error)")
            }
        }
    }
}
 

// message data with MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    // (1) Number of messages
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
    return messages.count
    }

    // (2) Current sender = current user
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        return Sender(senderId: "error", displayName: "erroe", profileImage: "")
    }

    // (3) Show messsages
    func messageForItem( at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView ) -> MessageType {
        return messages[indexPath.section]
    }

    // (4) Name above messages
    func messageTopLabelAttributedText( for message: MessageType, at indexPath: IndexPath ) -> NSAttributedString? {
        let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [.font:
                                                                UIFont.preferredFont(forTextStyle: .caption1),
                                                                 .foregroundColor: UIColor(white: 0.3, alpha: 1)])
    }
}

//  Design chat UI with MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {

  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 20
  }
    
}


// Design chat UI with MessagesDisplayDelegate
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

// Inputbar functions
extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        guard  let selfSender = self.selfSender, let messageId = createMessageId() else {
            print("something in message is wrong")
            return
        }
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        defaults.set(text, forKey: "text")
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
