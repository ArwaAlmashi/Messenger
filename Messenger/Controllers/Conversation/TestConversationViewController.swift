//
//  TestConversationViewController.swift
//  Messenger
//
//  Created by administrator on 31/10/2021.
//

import UIKit
import FirebaseAuth

class TestConversationViewController: UIViewController {

    override func viewDidLoad() {
           super.viewDidLoad()
       }
    
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        
//        do {
//            try FirebaseAuth.Auth.auth().signOut()
//        }
//        catch {
//        }
    }
    
       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
//           validateAuth()
       }
       
//       private func validateAuth(){
//           
//           if FirebaseAuth.Auth.auth().currentUser == nil {
//               let vc = LoginViewController()
//               let nav = UINavigationController(rootViewController: vc)
//               nav.modalPresentationStyle = .fullScreen
//               present(nav, animated: false)
//           }
//       }
    


}
