

import Foundation





struct User {
    
    var fullName : String
    
    var email : String
    
    var profileImage : String
    
    var password : String
    
    var conversation : [[String : Any]]
}


struct UserNSObject {
    
    var userId : String?
    
    var fullName : String?
    
    var email : String?
    
    var profileImage : String?
    
    var conversation : [[String : Any]?]?

}

struct Conversation {
    var friend : Sender?
    var messages : [Message] = []
}
