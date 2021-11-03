

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD



class ConversationViewController: UIViewController {
    

    
    var users = [UserNSObject]()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllUsersInFirebaseDatabase()
    }

    func fetchAllUsersInFirebaseDatabase() {
        DatabaseManger.shared.getAllUsers { value in
          
            var user = UserNSObject()
            do {
                let userRoot = try value.get()
                for (userId , userDic) in userRoot {
                    if userId != Auth.auth().currentUser?.uid {
                        
                        let thisUser = userDic as! [String : Any]
                        user.userId = userId
                        user.fullName = thisUser["fullName"] as? String
                        user.email = thisUser["email"] as? String
                        user.userId = thisUser["userId"] as? String
                        user.profileImage = thisUser["profileImage"] as? String
                        self.users.append(user)
                        print("User ID :\(user.userId!) , Email: \(user.email!), Name: \(user.fullName!)")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                        
                    }
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            } 

        }
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTableView()
        validateAuth()
    }
    
    private func validateAuth(){
        if Auth.auth().currentUser == nil {
            backToGetStarted()
        }
    }
    // IBAction
    @IBAction func newChatButton(_ sender: UIButton) {
        didTapComposeButton()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            backToGetStarted()
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // Set up VC
    private func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // User logout
    private func backToGetStarted(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // Search for user
    private let spinner = JGProgressHUD(style: .dark)
    
    // present new conversation view controller
    @objc private func didTapComposeButton(){
        let  newConversationVC = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: newConversationVC)
        present(navVC,animated: true)
    }
    
    private func hideTableView(){
        if tableView.numberOfRows(inSection: 0) == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
    

}


// MARK: TableView
extension ConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        cell.nameLabel.text = users[indexPath.row].fullName!
        cell.emailLabel.text = users[indexPath.row].email!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.title = users[indexPath.row].fullName!
        chatVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}
