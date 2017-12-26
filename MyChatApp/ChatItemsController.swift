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
import FirebaseDatabase
import SwiftyJSON

class ChatItemsController: NSObject {
    
    
    var initialMessages = [ChatItemProtocol]()
    
    var items = [ChatItemProtocol]()
    var loadMore = false
    var userUID: String!
    typealias compeleteLoading = () -> Void
    
    func loadIntoItemArray(messageNeeded: Int, moreToLoad: Bool) {
        for index in stride(from: initialMessages.count - items.count, to: initialMessages.count - items.count -  messageNeeded, by: -1) {
            self.items.insert(initialMessages[index - 1], at: 0)
        }
        self.loadMore = moreToLoad
    }
    
    func insertItem(message: ChatItemProtocol){
        self.items.append(message)
        
    }
    
    func loadPrevious(Completion: @escaping compeleteLoading) {
        Database.database().reference().child("user-messages").child(Me.uid).child(userUID).queryEnding(atValue: nil, childKey: self.items.first?.uid).queryLimited(toLast: 51).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            var messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
                return lhs["date"].doubleValue < rhs["date"].doubleValue
            })
            
            messages.removeLast()
            self?.loadMore = messages.count > 50
            let converted = self!.convertToChatItemProtocol(messages: messages)
            for index in stride(from: converted.count, to: converted.count - min(messages.count, 50), by: -1) {
                self?.items.insert(converted[index - 1], at: 0)
            }
            Completion()
        }
    }
    
    func adjustWindow() {
        self.items.removeFirst(200)
        self.loadMore = true
    }
}
