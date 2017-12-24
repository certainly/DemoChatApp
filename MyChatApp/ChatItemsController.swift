//
//  ChatItemController.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ChatItemsController {
    
    
    
    var items = [ChatItemProtocol]()
    
    func insertItem(message: ChatItemProtocol){
        self.items.append(message)
    }
}
