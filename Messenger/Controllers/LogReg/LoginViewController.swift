

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login")

        
    }
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        userLogin()
    }
    
    @IBAction func signInWithGoogleButton(_ sender: UIButton) {
    }
    
    @IBAction func signInWithFacebookButton(_ sender: UIButton) {
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func userLogin() {
        guard let email = emailAddressTextField.text, !email.isEmpty else {
            validationAlertMessege(messege: "email field can not be empty")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            validationAlertMessege(messege: "password field can not be empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) {
            (autherResult: AuthDataResult?, error: Error? )  in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("success login user: \(email)")
                let ConversationVC = self.storyboard?.instantiateViewController(withIdentifier: "TestConversationViewController") as! TestConversationViewController
                self.navigationController?.pushViewController(ConversationVC, animated: true)
                
            }
            
        }
        
    }
    
    func validationUserInput() {
        
      
    }
    
    func validationAlertMessege(messege: String){
        let alert = UIAlertController(title: "Empty Field", message: messege, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
