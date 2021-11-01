

import UIKit
import Firebase

class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            
        }
    @IBAction func logoutButton(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
        backToGetStarted()
    }
    
    private func backToGetStarted(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let getStartedVC = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedViewController") as! GetStartedViewController
            self.navigationController?.pushViewController(getStartedVC, animated: true)
        }
    }

}
