

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registerButton(_ sender: UIButton) {
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func profileImageButton(_ sender: UIButton) {
        presentPhotoActionSheet()
    }
    
}


extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // get results of user taking picture or selecting from camera roll
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
        self.profileImage.frame = CGRect(x: 125.0, y: 104.0, width: 178.0, height: 178.0)
        self.profileImage.setImage(selectedImage, for: .normal)
   
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func ResizeImage() {
//
//        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
//        // set the frame
//        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
//        // add image
//        button.setBackgroundImage(UIImage(named:"SearchIcon"), for: .normal)
//        // button title
//        button.setTitle("Test Button", for: .normal)
//        // add action
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        // add button on view
//        self.view.addSubview(button)
//        // all constaints
//        let widthContraints =  NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
//        let heightContraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
//        let xContraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
//        let yContraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
//        NSLayoutConstraint.activate([heightContraints,widthContraints,xContraints,yContraints])
//    }
    
    
}
