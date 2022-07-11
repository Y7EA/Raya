//
//  GlobalFunctions.swift
//  Raya
//
//  Created by Yahya haj ali  on 23/04/2022.
//
import Foundation
import UIKit
import AVFoundation

//return the imag in fierstore هاي عشان اوخذ الرابط تاع الصوره من الداتا بيس عشان احملها واحطها ف الاعدادات بعد ما المستخدم يغير الصورة

func fileNameFrom(fileUrl: String) -> String {
    
    let name = fileUrl.components(separatedBy: "_").last
    
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name1?.components(separatedBy: ".").first
    
    return name2!
    
}

//time هاي للوقت الي مضى من بعت اخر مسج

func timeElapsed (_ date: Date)-> String {
    let seconds = Date ().timeIntervalSince(date)
    var elapsed = ""
    
    if seconds < 60 {
        elapsed = "Just now"
    }
    else if seconds < 60 * 60 {
        
        let minutes = Int(seconds/60)
        let minText = minutes > 1 ? "mins" : "min"
        elapsed = "\(minutes) \(minText)"
    }
    else if seconds < 24 * 60 * 60 {
        
        let hours = Int(seconds / (60*60))
        let hourText = hours > 1 ? "hours" : "hour"
        elapsed = "\(hours) \(hourText)"
        
    }
    else {
        elapsed = "\(date.longDate())"
        
        
    }
    
    
    return elapsed
}

//video image هاي ضفنا انه بقدر يرفع فيديو متحرك ك صورة كنوع من التغيري هو موجودة ف بعض التطبيقات ك فيس بوك 
func videoThumbnail(videoURL: URL) -> UIImage {
    do {
        let asset = AVURLAsset(url: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return UIImage(named: "photoPlaceholder")!
    }
}


