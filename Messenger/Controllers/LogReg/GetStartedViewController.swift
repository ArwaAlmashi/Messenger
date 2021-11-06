

import UIKit
import Firebase
import FirebaseAuth

class GetStartedViewController: UIViewController, registerDelegate, loginDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.95, green: 0.52, blue: 0.44, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        validateAuth()
    }
    
    // IBAction: Regiser & Login
    @IBAction func getStartedButton(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)

    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    // Login Delegate func
    func loginSuccessful() {
        goToConversationViewController()
    }
    
    // Register Delegate func
    func registerSuccessful() {
        goToConversationViewController()
    }
    
    // Valdiate user existe 
    private func validateAuth(){
        if Auth.auth().currentUser != nil {
            goToConversationViewController()
        }
    }
    
    func goToConversationViewController() {
        let conversationVC = self.storyboard?.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        self.navigationController?.pushViewController(conversationVC, animated: false)
    }
    

}

