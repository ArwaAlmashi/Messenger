

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import FirebaseStorage

class SearchUserViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!

    var users = [User()]
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
    }
    @IBAction func searchButton(_ sender: UIButton) {
        for user in users {
            guard let text = searchTextField.text, !text.isEmpty else{
                return
            }
            print("Search:\(user.fullName)")
        }
        
    }
    
    func searchUser(_ searchBar : UISearchBar){
        
    }
    
    func getAllUsers() {
        DatabaseManger.shared.fetchAllUsers { value in
            var user = User()
            do {
                let userRoot = try value.get()
                for (userId , userInfo) in userRoot {
                    if userId != Auth.auth().currentUser?.uid {
                        
                        let thisUser = userInfo as! [String : Any]
                        user.userId = userId
                        user.fullName = thisUser["fullName"] as? String
                        user.email = thisUser["email"] as? String
                        user.userId = thisUser["userId"] as? String
                        user.profileImage = thisUser["profileImage"] as? String
                        
                        self.users.append(user)
                        print("User ID :\(user.userId!) , Email: \(user.email!), Name: \(user.fullName!)")
                    } else {
                        let currentUser = userInfo as! [String : Any]
                        defaults.set(currentUser["fullName"], forKey: "cuerrentUserName")
                        defaults.set(currentUser["email"], forKey: "cuerrentUserEmail")
                        defaults.set(currentUser["profileImage"], forKey: "cuerrentUserProfileImage")
                    }
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }

        }
    }

}
