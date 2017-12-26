//
//  PhotoModel.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import ChattoAdditions
import Chatto

class PhotoModel: PhotoMessageModel<MessageModel>  {
    
    static let chatItemType = "photo"
    override init(messageModel: MessageModel, imageSize: CGSize, image: UIImage) {
        super.init(messageModel: messageModel, imageSize: imageSize, image: image)
    }
    var status: MessageStatus {
        
        get {
            return self._messageModel.status
        } set {
            self._messageModel.status = newValue
        }
    }
}
