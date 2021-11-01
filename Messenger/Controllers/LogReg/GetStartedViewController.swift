

import UIKit
import Firebase
import FirebaseAuth

class GetStartedViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
      
            validateAuth()
        }

    @IBAction func getStartedButton(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)

    }
    @IBAction func loginButton(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }

    private func validateAuth(){
        if Auth.auth().currentUser != nil {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
    }
    
}
