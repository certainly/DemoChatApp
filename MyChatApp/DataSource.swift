//
//  DataSource.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class DataSource: ChatDataSourceProtocol {

    
    var controller = ChatItemsController()
    
    var chatItems: [ChatItemProtocol] {
        return controller.items
    }
    
    var hasMoreNext: Bool {
        return false
    }
    
    var hasMorePrevious: Bool {
        return false
    }
    
    var delegate: ChatDataSourceDelegateProtocol?
    
    func loadNext() {
        
    }
    
    func loadPrevious() {
        
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {
        
    }
    
    
    func addTextMessage(message: ChatItemProtocol) {
        self.controller.insertItem(message: message)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
}
