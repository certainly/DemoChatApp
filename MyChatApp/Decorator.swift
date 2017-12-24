//
//  Decorator.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import Foundation
import Chatto
import ChattoAdditions

class Decorator: ChatItemsDecoratorProtocol {
    func decorateItems(_ chatItems: [ChatItemProtocol]) -> [DecoratedChatItem] {
        var decoratedItems = [DecoratedChatItem]()
        
        for item in chatItems {
            let decorateItem = DecoratedChatItem(chatItem: item, decorationAttributes: ChatItemDecorationAttributes(bottomMargin: 10, messageDecorationAttributes: BaseMessageDecorationAttributes()))
            decoratedItems.append(decorateItem)
        }
        return decoratedItems
    }
}
