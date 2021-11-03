

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD


class ConversationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpTableView()
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
        
        if tableView.numberOfRows(inSection: 0) == 0 {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
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
    
    private func fetchConversations(){
        // fetch from firebase and either show table or label
        tableView.isHidden = false
    }
    
    

}


// MARK: TableView
extension ConversationViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.title = "Jenny Smith"
        chatVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    
}
