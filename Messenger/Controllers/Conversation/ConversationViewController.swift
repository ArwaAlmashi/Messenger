

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import FirebaseStorage
import SDWebImage

public let defaults = UserDefaults.standard

class ConversationViewController: UIViewController {
    
    var users = [User]()
    var conversations = [Conversation]()
    var userURL : String?
    
    public var otherUserName: String?
    public var otherUserEmail: String?
    public var otherUserId: String?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        getAllConversations()
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
    @IBAction func searchForUserButton(_ sender: UIButton) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchUserViewController") as! SearchUserViewController
        self.navigationController?.present(searchVC, animated: true, completion: nil)
    }
    
    @IBAction func profileSettingButton(_ sender: UIButton) {
        let profileVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // Set up conversation UI
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
    
    private func hideTableView(){
        if tableView.numberOfRows(inSection: 0) == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    // MARK: Deal with Firebsae
    private func createNewConversation(){

        guard let currentUserId = Auth.auth().currentUser?.uid, let otherUserId = defaults.string(forKey: "otherUserId") else {
            return
        }
        if conversations.count == 0 {
            let conversation = Conversation(conversationId: "\(currentUserId)_\(otherUserId)", lastMessage: "..", senderUserId: currentUserId)
            insertNewConversation(conversation)
            conversations.append(conversation)
            defaults.set(conversation.conversationId, forKey: "conversationId")
        } else {
            for i in 0..<conversations.count {
                if conversations[i].conversationId == "\(currentUserId)_\(otherUserId)" || conversations[i].conversationId == "\(otherUserId)_\(currentUserId)" {
                    defaults.set(conversations[i].conversationId, forKey: "conversationId")
                } else {
                    let conversation = Conversation(conversationId: "\(currentUserId)_\(otherUserId)", lastMessage: "..", senderUserId: currentUserId)
                    insertNewConversation(conversation)
                    conversations.append(conversation)
                    defaults.set(conversation.conversationId, forKey: "conversationId")
                }
            }
        }
    }
    
    private func insertNewConversation(_ conversation: Conversation) {
        DatabaseManger.shared.insertConversation(with: conversation) { success in
            print("success add Conversation")
        }

    }
    
    func getAllUsers() {
        DatabaseManger.shared.fetchAllUsers { value in
            var user = User()
            do {
                let userRoot = try value.get()  // "users" is the root in database
                for (userId , userInfo) in userRoot {  // loop in dictionery [Key = userId : Value = user info]
                    if userId != Auth.auth().currentUser?.uid {   // get all users except current user
                        
                        let thisUser = userInfo as! [String : Any]  // conver userInfo to dictionery to save in User Object
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
                        
                    } else {
                        let currentUser = userInfo as! [String : Any]  // conver userInfo to dictionery to save in User Object
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
    
    func getAllConversations() {
        DatabaseManger.shared.fetchAllConversations { value in
            var conversation : Conversation?
            do {
                let conversationRoot = try value.get()
                for (conversationId , conversationInfo) in conversationRoot {
                    let thisConversation = conversationInfo as! [String : Any]
                    let lastMessage = thisConversation["lastMessage"]!
                    let sendUseerId = thisConversation["senderUserId"]!
                    
                    conversation = Conversation(conversationId: conversationId, lastMessage: lastMessage as! String, senderUserId: sendUseerId as! String)
                    self.conversations.append(conversation!)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
            }

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
    
        guard let profileImageUrl = users[indexPath.row].profileImage else {
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
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.title = users[indexPath.row].fullName!
        chatVC.navigationItem.largeTitleDisplayMode = .never
        
        defaults.set(users[indexPath.row].fullName!, forKey: "otherUserName")
        defaults.set(users[indexPath.row].userId!, forKey: "otherUserId")
        
        createNewConversation()
        
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}
