//
//  TextBuilder.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class ViewModel: TextMessageViewModel<TextModel> {
    override init(textMessage: TextModel, messageViewModel: MessageViewModelProtocol) {
        super.init(textMessage: textMessage, messageViewModel: messageViewModel)
    }
}

class TextBuilder: ViewModelBuilderProtocol {
    func canCreateViewModel(fromModel decoratedTextMessage: Any) -> Bool {
        return decoratedTextMessage is TextModel
    }
    
    func createViewModel(_ decoratedTextMessage: TextModel) -> ViewModel {
        let textmessageViewModel = ViewModel(textMessage: decoratedTextMessage, messageViewModel: MessageViewModelDefaultBuilder().createMessageViewModel(decoratedTextMessage))
        return textmessageViewModel
    }
}
