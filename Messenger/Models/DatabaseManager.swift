

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Database.database().reference()
    
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
            "fullName" : user.fullName,
            "email" : user.email,
            "profileImage" : user.profileImage,
            "conversation" : user.conversation,
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
        
    // Get all users
    public func getAllUsers(completion: @escaping (Result<[String: Any], Error>) -> Void){

        database.child("users").observeSingleEvent(of: .value) { snapshot in
           guard let value = snapshot.value as? [String: Any] else {
               completion(.failure(DatabaseError.failedToFetch))
               return
           }
           completion(.success(value))
       }
    }
    
    // Add message into database
    public func insertMessage(with conversation: Conversation, completion: @escaping (Bool) -> Void){
        // take user id
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        // make users root
        let usersRefrence = self.database.child("users").child(userId)
        let userConversation : [ String : Any ] = [
            "conversation" : conversation.messages
        ]
        usersRefrence.updateChildValues(userConversation) { error, refrence in
            if error != nil {
                return
            } else {
                print(refrence)
                print("success adding user into Firebase")
            }
        }
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
