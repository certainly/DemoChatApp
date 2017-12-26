//
//  Me.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/26.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import FirebaseAuth

class Me {
    static var uid: String {
        return Auth.auth().currentUser!.uid
    }
}
