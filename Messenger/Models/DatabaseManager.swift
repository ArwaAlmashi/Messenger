

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Database.database().reference()

    
    public func test(user : User) {
        
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        let userDic : [ String : Any ] = [
            "full name" : user.fullName,
            "email" : user.email,
            "profile image" : user.profileImage
        ]
        database.child(userID).setValue(userDic)
    }
}


