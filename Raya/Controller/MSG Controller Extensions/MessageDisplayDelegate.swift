//
//  MessageDisplayDelegate.swift
//  Raya
//
//  Created by Yahya haj ali  on 28/04/2022.
//

import Foundation
import MessageKit

extension MSGViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return .label
        
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorOutgoing = UIColor(named: "ColorOutgoingBubble")
        let bubbleColorIncoming = UIColor(named: "ColorIncomingMessage")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing! : bubbleColorIncoming!
        
        
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
        
        
    }
    
}


//Channel
extension ChannelMSGViewController: MessagesDisplayDelegate {
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return .label
        
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorOutgoing = UIColor(named: "ColorOutgoingBubble")
        let bubbleColorIncoming = UIColor(named: "ColorIncomingMessage")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing as! UIColor : bubbleColorIncoming as! UIColor
        
        
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
        
        
    }
    
}

