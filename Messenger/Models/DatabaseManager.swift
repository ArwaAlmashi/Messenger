

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Database.database().reference()
    
    // MARK: Insert functions
    // Insert User
    public func insertUser(with user: User, completion: @escaping (Bool) -> Void){
        // take user id
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        // make users root
        let usersRefrence = self.database.child("users").child(userId)
        let userDic : [ String : Any ] = [
            "userId" : userId,
            "fullName" : user.fullName as Any,
            "email" : user.email as Any,
            "profileImage" : user.profileImage as Any
        ]
        usersRefrence.updateChildValues(userDic) { error, refrence in
            if error != nil {
                return
            } else {
                print(refrence)
                print("success adding user into Firebase")
            }
        }
    }
    // Insert conversation into database
    public func insertConversation(with conversation: Conversation, completion: @escaping (Bool) -> Void){
        
        // take user id
        guard let CureentUserId = Auth.auth().currentUser?.uid, let otherUserId = defaults.string(forKey: "otherUserId") else {
            return
        }
        
        // take conversation id
        let conversationId = conversation.conversationId

        // make curren and other t user root
        let currentUserRefrence = self.database.child("users").child(CureentUserId).child("conversations").child("\(conversationId)")
        let otherUserRefrense = self.database.child("users").child(otherUserId).child("conversations").child("\(conversationId)")
        
        let conversationDic : [ String : Any ] = [
            "conversationId" : conversation.conversationId,
            "lastMessage" : conversation.lastMessage,
            "senderUserId" : conversation.senderUserId
        ]

        currentUserRefrence.updateChildValues(conversationDic) { error, refrence in
            if error != nil {
                return
            } else {
                print("success adding conversation to the current user into Firebase")
            }
        }
        
        otherUserRefrense.updateChildValues(conversationDic) { error, refrence in
            if error != nil {
                return
            } else {
                print("success adding conversation to the other user into Firebase")
            }
        }
    }
    
    // MARK: Insert Message into Firebase
    public func insertMessage(with message: Message, completion: @escaping (Bool) -> Void){
        
        // 1) take essentials values
        guard let cureentUserId = Auth.auth().currentUser?.uid,
              let otherUserId = defaults.string(forKey: "otherUserId"),
              let conversationId = defaults.string(forKey: "conversationId") ,
              let messageText =  defaults.string(forKey: "text") else {
                  return
        }
        let conversationDic : [ String : Any ] = [
            "lastMessage" : messageText
        ]

        
        // 2) Insert Messsage to current user
        self.database.child("users").child(cureentUserId).child("conversations").child("\(conversationId)").child("messages").observeSingleEvent(of: .value) { snapshot in
            
            if var usersCollection = snapshot.value as? [[String: Any]] {

                let newElement = [
                    "messageId" : message.messageId,
                    "sentDate" : "\(message.sentDate)",
                    "kind" : message.kind.messageKindString,
                    "text": messageText,
                    "senderId" : message.sender.senderId,
                    "senderName" : message.sender.displayName
                ]
                usersCollection.append(newElement)
                
                self.database.child("users").child(cureentUserId).child("conversations").child("\(conversationId)").child("messages").setValue(usersCollection) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
            }else{
                let newCollection: [[String: Any]] = [
                    [
                        "messageId" : message.messageId,
                        "sentDate" : "\(message.sentDate)",
                        "kind" : message.kind.messageKindString,
                        "text": messageText,
                        "senderId" : message.sender.senderId,
                        "senderName" : message.sender.displayName
                    ]
                ]
                self.database.child("users").child(cureentUserId).child("conversations").child("\(conversationId)").child("messages").setValue(newCollection) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
        
        // 3) Insert Messsage to other user
        self.database.child("users").child(otherUserId).child("conversations").child("\(conversationId)").child("messages").observeSingleEvent(of: .value) { snapshot in
            
            if var usersCollection = snapshot.value as? [[String: Any]] {

                let newElement = [
                    "messageId" : message.messageId,
                    "sentDate" : "\(message.sentDate)",
                    "kind" : message.kind.messageKindString,
                    "text": messageText,
                    "senderId" : message.sender.senderId,
                    "senderName" : message.sender.displayName
                ]
                usersCollection.append(newElement)
                
                self.database.child("users").child(otherUserId).child("conversations").child("\(conversationId)").child("messages").setValue(usersCollection) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
                
            }else{
                let newCollection: [[String: Any]] = [
                    [
                        "messageId" : message.messageId,
                        "sentDate" : "\(message.sentDate)",
                        "kind" : message.kind.messageKindString,
                        "text": messageText,
                        "senderId" : message.sender.senderId,
                        "senderName" : message.sender.displayName
                    ]
                ]
                self.database.child("users").child(otherUserId).child("conversations").child("\(conversationId)").child("messages").setValue(newCollection) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }

        // 4) Update last message in current user
        self.database.child("users").child(cureentUserId).child("conversations").child("\(conversationId)").updateChildValues(conversationDic) { error, refrence in
            if error != nil {
                return
            }
        }

        // 5) Update last message in current user
        self.database.child("users").child(otherUserId).child("conversations").child("\(conversationId)").updateChildValues(conversationDic) { error, refrence in
            if error != nil {
                return
            }
        }
    }
       
    // MARK: Fetch functions
    // Fetch all users
    public func fetchAllUsers(completion: @escaping (Result<[String: Any], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
           guard let value = snapshot.value as? [String: Any] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
           completion(.success(value))
       }
    }
    
    // Fetch all conversations
    public func fetchAllConversations(completion: @escaping (Result<[String: Any], Error>) -> Void){
        
        // take user id and conversation id
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        
        database.child("users").child(currentUserId).child("conversations").observeSingleEvent(of: .value) { snapshot in
           guard let value = snapshot.value as? [String: Any] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
           completion(.success(value))
       }
    }
    
    // Fetch all messages
    public func fetchAllMessages(completion: @escaping (Result<[String: Any], Error>) -> Void){
        // take user id and conversation id
        guard let cureentUserId = Auth.auth().currentUser?.uid, let conversationId = defaults.string(forKey: "conversationId") else {
            return
        }
        database.child("users").child(cureentUserId).child("conversations").child("\(conversationId)").child("messages").observeSingleEvent(of: .value) { snapshot in
           guard let value = snapshot.value as? [String: Any] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
           completion(.success(value))
       }
    }
    

    public func getAllMessagesForConversation(completion: @escaping (Result<[Message], Error>) -> Void) {
        // take user id and conversation id
        guard let cureentUserId = Auth.auth().currentUser?.uid, let conversationId = defaults.string(forKey: "conversationId") else {
            return
        }
        database.child("users").child(cureentUserId).child("conversations").child("\(conversationId)").child("messages").observe( .value) { snapshot in
            print("Get Messages")
            print(snapshot)
           guard let value = snapshot.value as? [[String: Any]] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
            
            let messages : [Message] = value.compactMap { messagesDictionery in
                
                let messageInfo = messagesDictionery as! [String:Any]
                let sendDate = self.convertStringToDate(stringDate: messageInfo["sentDate"]! as! String)
                let sender = Sender(senderId: messageInfo["senderId"]! as! String , displayName: messageInfo["senderName"]! as! String, profileImage: "")
                
                return Message(sender: sender as Sender, messageId: messageInfo["messageId"]! as! String, sentDate: sendDate as Date, kind: .text(messageInfo["text"]! as! String))
                
            }
           completion(.success(messages))
       }

    }
    
    private func convertStringToDate(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: stringDate)
        return date ?? Date()
    }
    
    
    
    
    
    public enum DatabaseError: Error {
        case failedToFetch
    }
    
    

    
}

extension DatabaseManger {    
    public func observeUserInDatabase(with userID: String, completion: @escaping ((Bool) -> Void)) {
        database.child(userID).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            print(snapshot)
            completion(true)
        }
    }
}


//self.database.child("users").child(userId).observeSingleEvent(of: .value) { snapshot in
//    // if array of users exist
//    if var usersCollection = snapshot.value as? [[String: Any]] {  // String: user id , Any: userDic
//        let userDic : [ String : Any ] = [
//            "user id" : userId,
//            "full name" : user.fullName,
//            "email" : user.email,
//            "profile image" : user.profileImage,
//            "conversations" : user.conversation,
//        ]
//        let user = [userId: userDic]
//        usersCollection.append(user)
//        self.database.child("users").setValue(usersCollection) { error, _ in
//        guard error == nil else {
//            completion(false)
//            return
//        }
//        completion(true)
//        }
//    } else {
//        let userDic : [ String : Any ] = [
//            "user id" : userId,
//            "full name" : user.fullName,
//            "email" : user.email,
//            "profile image" : user.profileImage,
//            "conversations" : user.conversation,
//        ]
//        let user : [String: Any] = [userId: userDic]
//        let newCollection: [[String: Any]] = [user]
//        self.database.child("users").setValue(newCollection) { error, _ in
//            guard error == nil else {
//                completion(false)
//                return
//            }
//            completion(true)
//        }
//    }
//}



//if var collectionDic = snapshot.value as? [String : Any] {
//    var messageArray = collectionDic["messages"] as? [[String:Any]]
//
//    let newElement = [
//        "messageId" : message.messageId,
//        "sentDate" : "\(message.sentDate)",
//        "kind" : message.kind.messageKindString,
//        "text": messageText,
//        "senderId" : message.sender.senderId,
//        "senderName" : message.sender.displayName
//    ]
//    messageArray?.append(newElement)
//    collectionDic["messages"] = messageArray
//
//    self.database.child("users").child(otherUserId).child("conversations").child("\(conversationId)").setValue(collectionDic) { error, _ in
//        guard error == nil else {
//            completion(false)
//            return
//        }
//        completion(true)
//    }
//}
