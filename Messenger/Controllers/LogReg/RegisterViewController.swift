

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol registerDelegate {
    func registerSuccessful()
}

class RegisterViewController: UIViewController {
    

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageButtonOutlet: UIButton!
    
    var delegate : registerDelegate?
    var user : User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // IBAction
    @IBAction func registerButton(_ sender: UIButton) {
        createNewUser()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
    @IBAction func profileImageButton(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    
    // Register User & Firebase authentcation & Insert into RealDB
    func createNewUser() {
        validationUserInput()
        
        if let user = user {
            Auth.auth().createUser(withEmail: user.email, password: user.password) {
                (authResult: AuthDataResult?, error: Error?) in
                
                if let error = error {
                    self.errorMessege(messege: error.localizedDescription)
                } else {
                    DatabaseManger.shared.insertUser(with: user) { isUserdInsert in
                        if isUserdInsert {
                            print("sucess adding the user account: \(user.email)")
                        }
                    }
                    self.delegate?.registerSuccessful()
                    self.navigationController?.popViewController(animated: false)
                }
                
            }
        }
    }
    
    // Valdiation user inputs
    func validationUserInput() {
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            validationAlertMessege(messege: "first name field can not be empty")
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            validationAlertMessege(messege: "last name field can not be empty")
            return
        }
        guard let email = emailAddressTextField.text, !email.isEmpty else {
            validationAlertMessege(messege: "email field can not be empty")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            validationAlertMessege(messege: "password field can not be empty")
            return
        }
//        guard let profileImage = profileImageButtonOutlet else {
//        validationAlertMessege(messege: "profile image can not be empty")
//            return
//        }
        
        let tempProfileImageURL = "URL image"
        self.user = User(fullName: "\(firstName) \(lastName)", email: email, profileImage: tempProfileImageURL, password: password, conversation: [])

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

// MARK: Image Picker
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func presentPhotoActionSheet(){
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        insertProfilePhoto(image: selectedImage)
    }

    func insertProfilePhoto(image : UIImage) {
        profileImageButtonOutlet.layer.cornerRadius = 89
        profileImageButtonOutlet.layer.masksToBounds = true
        profileImageButtonOutlet.layer.borderWidth = 5
        profileImageButtonOutlet.layer.borderColor = UIColor.white.cgColor
        profileImageButtonOutlet.setBackgroundImage(image, for: .normal)
    }

    
    
}
