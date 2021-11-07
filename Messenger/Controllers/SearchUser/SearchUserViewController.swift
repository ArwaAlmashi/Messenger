

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import FirebaseStorage

class SearchUserViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    var users : [User]?
    var selectedUsers : [User] = []
    var delegate : foundUserDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        getAllUsers()
    }
    @IBAction func searchButton(_ sender: UIButton) {
        selectedUsers.removeAll()
        guard let text = searchTextField.text else{
            return
        }
        print(text)
        for user in users! {
            guard let name = user.fullName else {
                return
            }
            if (name.range(of: text, options: .caseInsensitive) != nil){
                print("SUCCESS")
                selectedUsers.append(user)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
                        
                        if self.users == nil {
                            self.users = [User(userId: userId, fullName: user.fullName, email: user.email, profileImage: user.profileImage)]
                        } else {
                            self.users!.append(user)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
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

// TableView
extension SearchUserViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchUserCell", for: indexPath) as! searchUserCell
        cell.nameLabel.text = selectedUsers[indexPath.row].fullName
        cell.emailLabel.text = selectedUsers[indexPath.row].email!

        guard let profileImageUrl = selectedUsers[indexPath.row].profileImage else {
            return cell
        }
        let url = URL(string: profileImageUrl)
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            if error != nil {
                print("Error: \(error!)")
                return
            }
            DispatchQueue.main.async {
                cell.profileImage.image = UIImage(data: data!)
            }
        }).resume()
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let fullName = selectedUsers[indexPath.row].fullName,
              let userId = selectedUsers[indexPath.row].userId,
              let email = selectedUsers[indexPath.row].email,
              let profileImage = selectedUsers[indexPath.row].profileImage else {
                  return
              }
        delegate?.selectUser(user: User(userId: userId, fullName: fullName, email: email, profileImage: profileImage))
        
        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
}

protocol foundUserDelegate{
    func selectUser(user:User)
}

