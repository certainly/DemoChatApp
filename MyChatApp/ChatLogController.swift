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
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseUI
import SwiftyJSON
import FirebaseStorage
import Kingfisher

class ChatLogController: BaseChatViewController, FUICollectionDelegate {
    
    var presenter: BasicChatInputBarPresenter!
    var dataSource: DataSource!
    var decorator = Decorator()
    var userUID = String()
    var MessagesArray: FUIArray!
    
    
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
            let senderID = Me.uid
            let messageUID = ("\(double)"+senderID).replacingOccurrences(of: ".", with: "")
            
             
            let message = MessageModel(uid: messageUID, senderId: senderID, type: TextModel.chatItemType, isIncoming: false, date: Date(), status: .sending)
            let textMessage = TextModel(messageModel: message, text: text)
            self?.dataSource.addMessage(message: textMessage)
            self?.sendOnlineTextMessage(text: text, uid: messageUID, double: double, senderId: senderID)
        }
        return item
    }
    
    func handlePhoto() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] photo in
            let date = Date()
            let double = Double(date.timeIntervalSinceReferenceDate)
            let senderID = "me"
            
            
            let message = MessageModel(uid: "(\(double, senderID))", senderId: senderID, type: PhotoModel.chatItemType, isIncoming: false, date: Date(), status: .sending)
            let photoMessage = PhotoModel(messageModel: message, imageSize: photo.size, image: photo)
            self?.dataSource.addMessage(message: photoMessage)
            self?.uploadToStorage(photo: photoMessage)
        }
        return item
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.chatDataSource = self.dataSource
        self.chatItemsDecorator = self.decorator
        self.constants.preferredMaxMessageCount = 300
        self.MessagesArray.observeQuery()
        self.MessagesArray.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    func sendOnlineTextMessage(text: String, uid: String, double:Double, senderId: String )  {
        let message = ["text": text, "uid": uid, "date": double, "senderId": senderId, "status": "success", "type" : TextModel.chatItemType] as [String: Any]
        let childUpdates = ["/User-messages/\(senderId)/\(self.userUID)/\(uid)" : message,
                            "/User-messages/\(self.userUID)/\(senderId)/\(uid)" : message,
                            "Users/\(Me.uid)/Contacts/\(self.userUID)/lastMessage":  message,
                            "Users/\(self.userUID)/Contacts/\(Me.uid)/lastMessage":  message
                            ]
        Database.database().reference().updateChildValues(childUpdates) { (error, _) in
            if error != nil {
                self.dataSource.updateTextMessage(uid: uid, status: .failed)
                return
            }
            self.dataSource.updateTextMessage(uid: uid, status: .success)
        }
        
//        let childUpdates = ["User-messages/12354/78845/121" : "message",
//                            "User-messages/78845/12354/121" : "message"
//        ]
//        Database.database().reference().updateChildValues(childUpdates) { (error, _) in
//            if error != nil {
//                print("suc")
//                return
//            }
//            print("err")
//        }
    }
    
    
    func uploadToStorage(photo: PhotoModel) {
        let imageName = photo.uid
        let storage = Storage.storage().reference().child("images").child(imageName)
        let data = UIImagePNGRepresentation(photo.image)
        storage.putData(data!, metadata: nil) { [weak self] (metadata, error) in
            
            if let imageURL = metadata?.downloadURL()?.absoluteString {
                self?.sendOnlineImageMessage(photoMessage: photo, imageURL: imageURL)
            } else {
                self?.dataSource.updatePhotoMessage(uid: photo.uid, status: .failed)
            }
        }
        
    }

    
    func sendOnlineImageMessage(photoMessage: PhotoModel, imageURL: String) {
        
        
        let message = ["image": imageURL, "uid": photoMessage.uid, "date": photoMessage.date.timeIntervalSinceReferenceDate, "senderId": photoMessage.senderId, "status": "success", "type": PhotoModel.chatItemType] as [String : Any]
        
        let childUpdates = ["User-messages/\(photoMessage.senderId)/\(self.userUID)/\(photoMessage.uid)": message,
                            "User-messages/\(self.userUID)/\(photoMessage.senderId)/\(photoMessage.uid)": message,
                            "Users/\(Me.uid)/Contacts/\(self.userUID)/lastMessage": message,
                            "Users/\(self.userUID)/Contacts/\(Me.uid)/lastMessage": message,
                            ]
        
        Database.database().reference().updateChildValues(childUpdates) { [weak self] (error, _) in
            
            if error != nil {
                
                self?.dataSource.updatePhotoMessage(uid: photoMessage.uid, status: .failed)
                return
            }
            self?.dataSource.updatePhotoMessage(uid: photoMessage.uid, status: .success)
        }
    }
    
    
    deinit {
        print("deinit")
    }
}

extension ChatLogController {
    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
        let message = JSON((object as! DataSnapshot).value as Any)
        let senderId = message["senderId"].stringValue
        let type = message["type"].stringValue
        let contains = self.dataSource.controller.items.contains { (collectionViewMessage) -> Bool in
            return collectionViewMessage.uid == message["uid"].stringValue
        }
        if contains == false {
            
            
            let model = MessageModel(uid: message["uid"].stringValue, senderId: senderId, type: type, isIncoming: senderId == Me.uid ? false : true, date: Date(timeIntervalSinceReferenceDate: message["date"].doubleValue), status: message["status"] == "success" ? MessageStatus.success : MessageStatus.sending)
            
            if type == TextModel.chatItemType {
            let textMessage = TextModel(messageModel: model, text: message["text"].stringValue)
            self.dataSource.addMessage(message: textMessage)
            } else if type == PhotoModel.chatItemType {
                KingfisherManager.shared.retrieveImage(with: URL(string: message["image"].stringValue)!, options: nil, progressBlock: nil, completionHandler: { [weak self] (image, error, _, _) in
                    if error != nil {
                        self?.alert(message: "error receiving image from friend")
                    } else {
                        let photoMessage = PhotoModel(messageModel: model, imageSize: image!.size, image: image!)
                        self?.dataSource.addMessage(message: photoMessage)
        }
                })
        
            }
        }
        
        
    }
}

