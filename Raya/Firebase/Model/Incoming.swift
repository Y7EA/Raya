//
//  Incoming.swift
//  Raya
//
//  Created by Yahya haj ali  on 28/04/2022.
//

import Foundation
import MessageKit
import CoreLocation

class Incoming {
    
    var messageViewController: MessagesViewController
    
    init (messageViewController: MessagesViewController) {
        
        self.messageViewController = messageViewController
    }
    
    func createMKMessage (localMessage: LocalMessage) -> MKMessage {
        
        let mkMessage = MKMessage(message: localMessage)
        
        if localMessage.type == kPHOTO {
            
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (image) in
                
                mkMessage.photoItem?.image = image
                
                self.messageViewController.messagesCollectionView.reloadData()                
            }
        }
        
        if localMessage.type == kVIDEO {
            FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (thumbnail) in
                FileStorage.downloadVideo(videoUrl: localMessage.videoUrl) { (readyToPlay, fileName) in
                    
                    let videoLink = URL (fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))
                    let videoItem = VideoMessage(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    
                    mkMessage.videoItem?.image = thumbnail
                    self.messageViewController.messagesCollectionView.reloadData()
                    
                }
            }        
        }
        
        if localMessage.type == kLOCATION {
            
            let locationItem = LocationMessage(location: CLLocation(latitude: localMessage.latitude, longitude: localMessage.longitude))
            
            mkMessage.kind = MessageKind.location(locationItem)
            mkMessage.locationItem = locationItem
        }
        
        
        if localMessage.type == kAUDIO {
            
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)

            FileStorage.downloadAudio(audioUrl: localMessage.audioUrl) { (fileName) in
                
                let audioURL = URL(fileURLWithPath: fileInDocumentsDirectory(fileName: fileName))

                mkMessage.audioItem?.url = audioURL
                
                
                
                
            }
            self.messageViewController.messagesCollectionView.reloadData()
            
            
        }
        
        
        return mkMessage
    }
    
}
