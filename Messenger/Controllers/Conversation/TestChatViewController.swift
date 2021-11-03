

import UIKit
import MessageKit


class TestChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {

   
    
    let senderUser = Sender(senderId: "1", displayName: "Arwa", profileImage: "")
    let reciverUser = Sender(senderId: "1", displayName: "Amal", profileImage: "")
    var messages = [MessageType]()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMessages()

        messages.append(Message(sender: senderUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello")))
        messages.append(Message(sender: reciverUser, messageId: "2", sentDate: Date().addingTimeInterval(-70000), kind: .text("hi")))
    }

    private func setUpMessages() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }



    func currentSender() -> SenderType {
        return senderUser
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    // 1
    func footerViewSize(
      for message: MessageType,
      at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView
    ) -> CGSize {
      return CGSize(width: 0, height: 8)
    }

    // 2
    func messageTopLabelHeight(
      for message: MessageType,
      at indexPath: IndexPath,
      in messagesCollectionView: MessagesCollectionView
    ) -> CGFloat {
      return 20
    }


}

