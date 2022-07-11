//
//  ChatTableViewCell.swift
//  Raya
//
//  Created by Yahya haj ali  on 24/04/2022.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

     //MARK:- IBOutlets
    
    
    @IBOutlet weak var avatarImageOutlet: UIImageView!
    @IBOutlet weak var usernameLabelOutlet: UILabel!
    @IBOutlet weak var lastMessageLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var unreadCounterLabelOutlet: UILabel!
    @IBOutlet weak var unreadCounterViewOutlet: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Circle view in un read massege هاي عشان اخلي شكل الي بجي ع عدد الرسائل الغير مقروءة دائري معادله

        
        unreadCounterViewOutlet.layer.cornerRadius = unreadCounterViewOutlet.frame.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure (chatRoom: ChatRoom) {
        usernameLabelOutlet.text = chatRoom.receiverName
        usernameLabelOutlet.minimumScaleFactor = 0.9
        
        lastMessageLabelOutlet.text = chatRoom.lastMessage
        lastMessageLabelOutlet.numberOfLines = 2
        lastMessageLabelOutlet.minimumScaleFactor = 0.9
        
        //un read massege هاي العلامة الي بلون الاورنج حاططها بديش اياها تظهر دايما بس تظهر اذا في مسج
        if chatRoom.unreadCounter != 0 {
            self.unreadCounterLabelOutlet.text = "\(chatRoom.unreadCounter)"
            self.unreadCounterViewOutlet.isHidden = false
        } else {
            self.unreadCounterViewOutlet.isHidden = true
        }
        
        // image نفس الشي اذا ما في صورة ليش احملها من الداتا بيس مهي الصورة الافتراضيه اذا معين صورة لازم احملها واشوف شهي
        if chatRoom.avatarLink != "" {
            
            FileStorage.downloadImage(imageUrl: chatRoom.avatarLink) { (avatarImage) in
                self.avatarImageOutlet.image = avatarImage?.circleMasked
            }
            
        } else {
            self.avatarImageOutlet.image = UIImage(named: "avatar")
        }
        
        dateLabelOutlet.text = timeElapsed(chatRoom.date ?? Date())
        
    }
    


}
