//
//  Extensions.swift
//  Raya
//
//  Created by Yahya haj ali  on 21/04/2022.


//This class How to set image in circle in swift an stackoverflow

import Foundation
import UIKit
// image هاي للتعديل ع الصوره ونخليها دائرية من ال stackOverfolww 
extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
// Date هاي اعملنا تحسن للوقت لانه الكومباير بحسب من اول ما بلش زي فكرة النوتبينز ف الجافا لهيك احنا مناش التاريخ كامل بس منا اليوم والشهر والسنه وهيك مش بثواني والى اخره

extension Date {
    
    func longDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
    
    func time() ->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func interval(ofComponent comp: Calendar.Component, to date: Date )->Float {
        
        let currentCalendar = Calendar.current
        
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: date) else {return 0}
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: self) else {return 0}
        
        return Float(end - start)
        
        
        
    }
    
    
}
