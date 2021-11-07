

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        validateAuth()
        showImage()
        
    }
    
    private func showImage(){
        let url = URL(string: defaults.string(forKey: "cuerrentUserProfileImage")!)
        URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
            if error != nil {
                print("Error: \(error!)")
                return
            }
            DispatchQueue.main.async {
                self.profileImage.image = UIImage(data: data!)
            }
        }).resume()
    }
    
    private func validateAuth(){
        if Auth.auth().currentUser == nil {
            backToGetStarted()
        }
    }
    @IBAction func backToConversationButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            backToGetStarted()
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func imageApperance() {
        
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 286/2

        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.white.cgColor

    }
    
    // User logout
    private func backToGetStarted(){
        if FirebaseAuth.Auth.auth().currentUser == nil {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
}
