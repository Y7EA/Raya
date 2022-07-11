//
//  ChannelTableViewCell.swift
//  Raya
//
//  Created by Yahya haj ali  on 27/04/2022.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

     //MARK:- IBoutlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aboutLable: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var lastMessageDateLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(channel: Channel) {
        nameLabel.text = channel.name
        aboutLable.text = channel.aboutChannel
        memberCountLabel.text = "\(channel.memberIds.count) members"
        lastMessageDateLabel.text = timeElapsed(channel.lastMessageDate ?? Date())
        
        if channel.avatarLink != "" {
            FileStorage.downloadImage(imageUrl: channel.avatarLink) { (avatarImage) in
                DispatchQueue.main.async {
                    self.avatarImageView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "avatar")
                }
                
            }
        } else {
            self.avatarImageView.image = UIImage(named: "avatar")
        }
        
        
    }
    
}
