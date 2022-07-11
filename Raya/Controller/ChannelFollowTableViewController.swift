//
//  ChannelFollowTableViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 25/04/2022.
//

import UIKit

protocol ChannelFollowTabelViewContorollerDelegate {
    func didClickFollow()
}

class ChannelFollowTableViewController: UITableViewController {

     //MARK:- Vars
    var channel: Channel!
    var followDelegate : ChannelFollowTabelViewContorollerDelegate?
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var avatarImgeView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        showChannelData()
        configureRightBarButton()
        
        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()

        
    }

    
     //MARK:- Show channel data
    
    private func showChannelData() {
        self.title = channel.name
        nameLabel.text = channel.name
        membersLabel.text = "\(channel.memberIds.count) Members"
        aboutTextView.text = channel.aboutChannel
        
        if channel.avatarLink != "" {
            FileStorage.downloadImage(imageUrl: channel.avatarLink) { (avatarImage) in
                DispatchQueue.main.async {
                    self.avatarImgeView.image = avatarImage != nil ? avatarImage?.circleMasked : UIImage(named: "avatar")
                }
                
            }
        } else {
            self.avatarImgeView.image = UIImage(named: "avatar")
        }
        
    }
    
    
     //MARK:- Right button item
    
    private func configureRightBarButton() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Follow", style: .plain, target: self, action: #selector(followChannel))
    }
    
    @objc func followChannel() {
        channel.memberIds.append(User.currentId)
        FChannelListener.shared.saveChannel(channel)
        followDelegate?.didClickFollow()
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
