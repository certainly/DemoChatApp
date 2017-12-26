//
//  SignInViewController.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import FirebaseAuth


class SignInViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(showingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification" ), object:  nil)
           NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification" ), object:  nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let email = email.text, let password = password.text else { return  }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                self?.alert(message: error.localizedDescription)
                return
            }
            print("success")
            let table = self?.storyboard?.instantiateViewController(withIdentifier: "table") as! MessagesTableViewController
            self?.navigationController?.show(table, sender: nil)
        }
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SIGNUP") as! SignUpViewController
        self.navigationController?.show(controller, sender: nil)

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
