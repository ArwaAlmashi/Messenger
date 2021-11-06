

import UIKit
import FirebaseAuth


protocol loginDelegate {
    func loginSuccessful()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var delegate : loginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // IBAction
    @IBAction func loginButton(_ sender: UIButton) {
        userLogin()
    }
    
    @IBAction func signInWithGoogleButton(_ sender: UIButton) {
    }
    
    @IBAction func signInWithFacebookButton(_ sender: UIButton) {
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Login user & Firebase authentcation
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
                self.errorMessege(messege: error.localizedDescription)
            } else {
                print("success login user: \(email)")
                self.delegate?.loginSuccessful()
                self.navigationController?.popViewController(animated: false)                
            }
        }
    }

    // Error Message from Firebase
    func errorMessege(messege: String) {
        let alert = UIAlertController(title: "Error", message: messege, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.view.tintColor = UIColor(red: 0.76, green: 0.41, blue: 0.65, alpha: 1.00)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Error Message from valdiation
    func validationAlertMessege(messege: String){
        let alert = UIAlertController(title: "Empty Field", message: messege, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        alert.view.tintColor = UIColor(red: 0.76, green: 0.41, blue: 0.65, alpha: 1.00)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
