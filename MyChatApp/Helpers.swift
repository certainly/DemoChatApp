//
//  Helpers.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
     @objc func showingKeyboard(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as?  NSValue)?.cgRectValue.height {
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    @objc func hidingKeyboard() {
        self.view.frame.origin.y = 0
    }
    
    func alert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
