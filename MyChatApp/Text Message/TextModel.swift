//
//  TextModel.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class TextModel: TextMessageModel<MessageModel> {
    
    static let chatItemType = "text"
    
    override init(messageModel: MessageModel, text: String) {
        super.init(messageModel: messageModel, text: text)
    }
}

