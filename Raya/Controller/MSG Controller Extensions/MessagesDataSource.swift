//
//  MessagesDataSource.swift
//  Raya
//
//  Created by Yahya haj ali  on 28/04/2022.
//

import Foundation
import MessageKit

extension MSGViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    
     //MARK:- Cell top lables
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
        if indexPath.section % 3 == 0 {
            
            let showLoadMore = (indexPath.section == 0) && (allLocalMessges.count > dispayingMessagesCount)
            let text = showLoadMore ? "Pull to load more": MessageKitDateFormatter.shared.string(from: message.sentDate)
          
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        }
        return nil
        
    }
    
     //MARK:- cell bottom label
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if isFromCurrentSender(message: message) {
            
            let message = mkMessages[indexPath.section]
            let status = indexPath.section == mkMessages.count - 1 ? message.status + " " + message.readDate.time() : ""
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            
            return NSAttributedString(string: status, attributes: [.font: font, .foregroundColor: color])
            
        }
        
        return nil
        
    }
    
    
     //MARK:- message bottom label
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section != mkMessages.count - 1 {
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time(), attributes: [.font: font, .foregroundColor: color])
            
            
        }
        return nil
    }
    
}


//Channel

extension ChannelMSGViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }
    
    
     //MARK:- Cell top lables
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
        if indexPath.section % 3 == 0 {
            
            let showLoadMore = (indexPath.section == 0) && (allLocalMessges.count > dispayingMessagesCount)
            let text = showLoadMore ? "Pull to load more": MessageKitDateFormatter.shared.string(from: message.sentDate)
          
            let font = showLoadMore ? UIFont.systemFont(ofSize: 13) : UIFont.boldSystemFont(ofSize: 10)
            let color = showLoadMore ? UIColor.systemBlue : UIColor.darkGray
            
            return NSAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        }
        return nil
        
    }
    

     //MARK:- message bottom label
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        
            
            let font = UIFont.boldSystemFont(ofSize: 10)
            let color = UIColor.darkGray
            return NSAttributedString(string: message.sentDate.time(), attributes: [.font: font, .foregroundColor: color])
                    
        
    }
    
}

