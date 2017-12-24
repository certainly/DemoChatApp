//
//  PhotoBuilder.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import ChattoAdditions
import Chatto

class PhotoViewModel: PhotoMessageViewModel<PhotoModel> {
    override init(photoMessage: PhotoModel, messageViewModel: MessageViewModelProtocol) {
        super.init(photoMessage: photoMessage, messageViewModel: messageViewModel)
    }
}

class PhotoBuilder: ViewModelBuilderProtocol {
    
    let defaultBuilder = MessageViewModelDefaultBuilder()
    
    
    func canCreateViewModel(fromModel decoratedPhotoMessage: Any) -> Bool {
        return decoratedPhotoMessage is PhotoModel
    }
    
    func createViewModel(_ decoratedPhotoMessage: PhotoModel) -> PhotoViewModel {
        let photoMessageViewModel = PhotoViewModel(photoMessage: decoratedPhotoMessage, messageViewModel: defaultBuilder.createMessageViewModel(decoratedPhotoMessage))
        return photoMessageViewModel
    }
}
