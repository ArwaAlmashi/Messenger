

import UIKit


class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login")

        
    }

    @IBAction func loginButton(_ sender: UIButton) {
    }
    
    @IBAction func signInWithGoogleButton(_ sender: UIButton) {
    }
    
    @IBAction func signInWithFacebookButton(_ sender: UIButton) {
    }
    
}
