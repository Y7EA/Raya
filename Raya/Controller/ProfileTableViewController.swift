//
//  ProfileTableViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 23/04/2022.
//


import UIKit

class ProfileTableViewController: UITableViewController {

    var user: User?
    
    //MARK:- IB Outlets
    
    @IBOutlet weak var avatarImageViewOutlet: UIImageView!
    @IBOutlet weak var usernaemLabelOutlet: UILabel!
    @IBOutlet weak var statusLabelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        tableView.tableFooterView = UIView()
        
        setupUI()
       
    }
    
    
    private func setupUI() {
        
        if user != nil {
            self.title = user!.username
        
            usernaemLabelOutlet.text = user?.username
            statusLabelOutlet.text = user?.status
            
            if user!.avatarLink != "" {
                FileStorage.downloadImage(imageUrl: user!.avatarLink) { [self] (avatarImage) in
                    avatarImageViewOutlet.image = avatarImage?.circleMasked
                }
            }
            
        }
        
    }
    

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 :5.0
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableview")
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            print ("Start chating ")
            
            let chatId = startChat(sender: User.currentUser!, receiver: user!)
            
            
            let privateMSGView = MSGViewController(chatId: chatId, recipientId: user!.id, recipientName: user!.username)
            
            navigationController?.pushViewController(privateMSGView, animated: true)
            
            
        }
    }
    
    
    
}
