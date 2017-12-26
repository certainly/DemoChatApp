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
    var currentlyLoading = false
    
    var chatItems: [ChatItemProtocol] {
        return controller.items
    }
    

    
    init(initialMessages: [ChatItemProtocol], uid: String) {
        controller.initialMessages = initialMessages
        controller.userUID = uid
        controller.loadIntoItemArray(messageNeeded: min(initialMessages.count,50), moreToLoad: initialMessages.count > 50)
    }
    
    var hasMoreNext: Bool {
        return false
    }
    
    var hasMorePrevious: Bool {
        return controller.loadMore
    }
    
    weak var delegate: ChatDataSourceDelegateProtocol?
    
    func loadNext() {
        
    }
     
    func loadPrevious() {
        if currentlyLoading == false {
            currentlyLoading = true
            controller.loadPrevious() {
                
                self.delegate?.chatDataSourceDidUpdate(self, updateType: .pagination  )
                self.currentlyLoading = false
            }
        }
    }
    
    func adjustNumberOfMessages(preferredMaxCount: Int?, focusPosition: Double, completion: (Bool) -> Void) {
        if focusPosition > 0.9 {
            self.controller.adjustWindow()
            completion(true)
        } else {
            completion(false)
        }
        
       
    }
    
    
    func addMessage(message: ChatItemProtocol) {
        self.controller.insertItem(message: message)
        self.delegate?.chatDataSourceDidUpdate(self)
    }
    
    func updateTextMessage(uid: String, status: MessageStatus) {
        if let index = self.controller.items.index(where: { (message) -> Bool in
            return message.uid == uid
        }) {
            let message = self.controller.items[index] as! TextModel
            message.status = status
            self.delegate?.chatDataSourceDidUpdate(self)
            
        }
    }
    
}
