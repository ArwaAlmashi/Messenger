

import UIKit

class GetStartedViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getStartedButton(_ sender: UIButton) {
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    @IBAction func loginButton(_ sender: UIButton) {
        let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(registerVC, animated: true)
    }

    
}



/**
 @IBAction func addTask(_ sender: UIButton) {
         goToEditVC(taskType:.add)
     }
     
     //MARK: Navigation logic
     func goToEditVC(taskItem:TaskModel? = nil, taskType: TaskType) {
         let editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditScreen") as! EditVC
         editVC.delegate = self
         editVC.taskItem = taskItem
         editVC.taskType = taskType // task operation type
         self.navigationController?.pushViewController(editVC, animated: true)
     }
 */
