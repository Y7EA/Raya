//
//  PhotoMessage.swift
//  Raya
//
//  Created by Yahya haj ali  on 25/04/2022.
//


import Foundation
import MessageKit

class PhotoMessage: NSObject, MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init (path: String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "photoPlaceholder")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
}
