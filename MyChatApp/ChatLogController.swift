//
//  ViewController.swift
//  MyChatApp
//
//  Created by certainly on 2017/12/24.
//  Copyright © 2017年 certainly. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions

class ChatLogController: BaseChatViewController {
    
    var presenter: BasicChatInputBarPresenter!
    var dataSource: DataSource!
    var decorator = Decorator()
    var totalMessages = [ChatItemProtocol]()
    
    
    
    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
        let textmessageBuilder = TextMessagePresenterBuilder(viewModelBuilder: TextBuilder(), interactionHandler: TextHandler())
        let photoPresenterBuilder = PhotoMessagePresenterBuilder(viewModelBuilder: PhotoBuilder(), interactionHandler: PhotoHandler ())
        
        return [TextModel.chatItemType : [textmessageBuilder],
                PhotoModel.chatItemType: [photoPresenterBuilder]
        ]
    }
    
    override func createChatInputView() -> UIView {
        let inputbar = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = "send"
        appearance.textInputAppearance.placeholderText = "Type a message"
        self.presenter = BasicChatInputBarPresenter(chatInputBar: inputbar, chatInputItems: [handleSend(), handlePhoto()], chatInputBarAppearance: appearance)
        return inputbar
        
    }
    
    func handleSend() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = {[weak self] text in
            let date = Date()
            let double = Double(date.timeIntervalSinceReferenceDate)
            let senderID = "me"
            
            
            let message = MessageModel(uid: "(\(double, senderID))", senderId: senderID, type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .success)
            let textMessage = TextModel(messageModel: message, text: text)
            self?.dataSource.addMessage(message: textMessage)
        }
        return item
    }
    
    func handlePhoto() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] photo in
            let date = Date()
            let double = Double(date.timeIntervalSinceReferenceDate)
            let senderID = "me"
            
            
            let message = MessageModel(uid: "(\(double, senderID))", senderId: senderID, type: PhotoModel.chatItemType, isIncoming: false, date: Date(), status: .success)
            let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
            self?.dataSource.addMessage(message: photoMessage)
        }
        return item
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...295 {
            let message = MessageModel(uid: "\(i)", senderId: "", type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .success)
            self.totalMessages.append(TextModel(messageModel: message, text: "\(i)"))
        }
        self.dataSource = DataSource(totalMessages: totalMessages)
        self.chatDataSource = self.dataSource
        self.chatItemsDecorator = self.decorator
        self.constants.preferredMaxMessageCount = 300
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

