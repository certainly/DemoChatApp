//
//  SignUpViewController.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var fullname: UITextField!
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
    
    @IBAction func signUp(_ sender: Any) {
        
        guard let email = email.text, let password = password.text, let fullname = fullname.text else { return  }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if let error = error {
                self?.alert(message: error.localizedDescription)
                return
            }
            
            
//            print("info: \(user!.uid) || \(Database.database().reference()) |333| \(Database.database().reference().child("Users").child(user!.uid))")
//            Database.database().reference().child("Users").child(user!.uid).setValue(["username": "unnn222"]){ (error, ref) -> Void in
//                print(error ?? "noerror")
//            }
            Database.database().reference().child("Users").child(user!.uid).updateChildValues(["email": email, "name": fullname], withCompletionBlock: { [weak self] (error, ref) in
                if let error = error {
                    self?.alert(message: error.localizedDescription)
                    return
                }
                    print("success database \(ref)")
            })

            print("success signUp")
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
