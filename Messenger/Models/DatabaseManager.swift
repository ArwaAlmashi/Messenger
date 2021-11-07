

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Database.database().reference()
    
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

// MARK: Users
extension DatabaseManger{
    // insert user
    public func insertUser(with user: User, completion: @escaping (Bool) -> Void){
       
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
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
    // get all users
    public func fetchAllUsers(completion: @escaping (Result<[String: Any], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value) { snapshot in
           guard let value = snapshot.value as? [String: Any] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
           completion(.success(value))
       }
    }
}

// MARK: Conversations
extension DatabaseManger {
    
    // Insert into firebsae
    public func insertConversation(with conversation: Conversation, completion: @escaping (Bool) -> Void){
        
        guard let CureentUserId = Auth.auth().currentUser?.uid, let otherUserId = defaults.string(forKey: "otherUserId") else {
            return
        }
        
        let conversationId = conversation.conversationId

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
    
    // get all conversations
    public func fetchAllConversations(completion: @escaping (Result<[String: Any], Error>) -> Void){
        
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
    
    public func getAllConversation(completion: @escaping (Result<[Conversation], Error>) -> Void) {
        guard let cureentUserId = Auth.auth().currentUser?.uid else {
            return
        }
        database.child("users").child(cureentUserId).child("conversations").observe( .value) { snapshot in
           guard let value = snapshot.value as? [String: Any] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
            let conversations : [Conversation] = value.compactMap { conversationDictionery in
                guard let conversationDictionery = conversationDictionery.value as? [String:Any] else {
                return nil
                }
                        
                guard let conversationsId = conversationDictionery["conversationId"] as? String,
                      let lastMessage = conversationDictionery["lastMessage"] as? String,
                      let senderUserId = conversationDictionery["senderUserId"] as? String else {
                          return nil
                      }
                print("Last message = \(lastMessage)")
                

                return Conversation(conversationId: conversationsId, lastMessage: lastMessage, senderUserId: senderUserId)

            }
           completion(.success(conversations))
       }

    }
    
}
// MARK: Messages
extension DatabaseManger{
    // insert messages
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
    
    // get all messages
    public func getAllMessagesForConversation(completion: @escaping (Result<[Message], Error>) -> Void) {
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
    
}
