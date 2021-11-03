

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Database.database().reference()
    
    // Insert new user into database
    public func insertUserIntoDatabase(user : User) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let userDic : [ String : Any ] = [
            "user id" : userID,
            "full name" : user.fullName,
            "email" : user.email,
            "profile image" : user.profileImage,
            "conversation" : []
        ]
        database.child(userID).setValue(userDic)
    }
    
//    public func insertMessageIntoDatabase(user : User) {
//        
//        guard let userID = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let messageDic : [ String : Any ] = [
//            "sender" : userID,
//            "messageId" : "",
//            "sentDate" : "",
//            "kind" : ""
//        ]
//        database.child(userID).setValue(messageDic)
//    }
    
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

//struct ChatAppUser {
//    let firstName: String
//    let lastName: String
//    let emailAddress: String
//    //let profilePictureUrl: String
//
//    // create a computed property safe email
//
//    var safeEmail: String {
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
//}


