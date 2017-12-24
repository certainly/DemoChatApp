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
    
    
    var totalMessages = [ChatItemProtocol]()
    
    var items = [ChatItemProtocol]()
    
    func loadIntoItemArray(messageNeeded: Int) {
        for index in stride(from: totalMessages.count - items.count, to: totalMessages.count - items.count -  messageNeeded, by: -1) {
            self.items.insert(totalMessages[index - 1], at: 0)
        }
    }
    
    func insertItem(message: ChatItemProtocol){
        self.items.append(message)
        totalMessages.append(message)
    }
    
    func loadPrevious() {
        self.loadIntoItemArray(messageNeeded: min(totalMessages.count - items.count, 50))
    }
    
    func adjustWindow() {
        self.items.removeFirst(200)
    }
}
