//
//  ChannlesTableViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 27/04/2022.
//

import UIKit

class ChannelsTableViewController: UITableViewController {

     //MARK:-  Vars
    
    var subscribedChannels : [Channel] = []
    var allChannels : [Channel] = []
    var myChannels : [Channel] = []
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var channelSegmentOutlet: UISegmentedControl!
    
    
     //MARK:- IBActions
    
    
    @IBAction func channelSegmentChanged(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Channel"
        navigationItem.largeTitleDisplayMode = .always
        
        tableView.tableFooterView = UIView()
        
       
        downloadAllChannels()
        downloadUserChannels()
        downlaodSubscribedChannels()
        
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if channelSegmentOutlet.selectedSegmentIndex == 0 {
            return subscribedChannels.count
        } else if channelSegmentOutlet.selectedSegmentIndex == 1 {
            return allChannels.count
        } else {
            return myChannels.count
        }
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChannelTableViewCell
        
        var channel = Channel()
        if channelSegmentOutlet.selectedSegmentIndex == 0 {
            channel = subscribedChannels[indexPath.row]
        } else if channelSegmentOutlet.selectedSegmentIndex == 1 {
            
            channel = allChannels[indexPath.row]
        } else {
            channel = myChannels[indexPath.row]
        }
        
        cell.configure(channel: channel)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
     //MARK:- Downlaod channels
    
    private func downloadAllChannels() {
        
        FChannelListener.shared.downloadAllChannels { (allChannels) in
            self.allChannels = allChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 1 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
    }
    
    private func downlaodSubscribedChannels () {
        FChannelListener.shared.downloadSubscribedChannels { (subscribedChannels) in
            self.subscribedChannels = subscribedChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 0 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
        }
    }
    
    
    private func downloadUserChannels () {
        
        FChannelListener.shared.downloadUserChannels { (userChannels) in
            self.myChannels = userChannels
            
            if self.channelSegmentOutlet.selectedSegmentIndex == 2 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            
        }
    }
    
    
     //MARK:- UIScrollView Delegate
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refreshControl!.isRefreshing {
            self.downloadAllChannels()
            refreshControl!.endRefreshing()
        }
        
        
    }
     //MARK:- Delegates of tableview
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if channelSegmentOutlet.selectedSegmentIndex == 0 {
            
            showChat(channel: subscribedChannels[indexPath.row])
        } else if channelSegmentOutlet.selectedSegmentIndex ==  1{
            showFollowChannelView(channel: allChannels[indexPath.row])
        } else {
            showEditChannelView(channel: myChannels[indexPath.row])
        }
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if channelSegmentOutlet.selectedSegmentIndex == 1 || channelSegmentOutlet.selectedSegmentIndex == 2 {
            return false
        } else {
            return subscribedChannels[indexPath.row].adminId != User.currentId
        }
      
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            var channelToUnfollow = subscribedChannels[indexPath.row]
            subscribedChannels.remove(at: indexPath.row)
            
            if let index = channelToUnfollow.memberIds.firstIndex(of: User.currentId) {
                channelToUnfollow.memberIds.remove(at: index)
            }
            
            FChannelListener.shared.saveChannel(channelToUnfollow)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
    
    
     //MARK:- Navigation
    
    private func showEditChannelView(channel: Channel) {
        
        let channelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "saveChannel") as! AddChannelTableViewController
        
        channelVC.channelToEdit = channel
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    
    
    private func showFollowChannelView(channel: Channel) {
        
        let channelVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "followChannel") as! ChannelFollowTableViewController
        
        channelVC.channel = channel
        channelVC.followDelegate = self
        self.navigationController?.pushViewController(channelVC, animated: true)
    }
    
    private func showChat(channel: Channel) {
        let channelChatVC = ChannelMSGViewController(channel: channel)
        navigationController?.pushViewController(channelChatVC, animated: true)
    }
    
}

extension ChannelsTableViewController: ChannelFollowTabelViewContorollerDelegate {
    func didClickFollow() {
        self.downloadAllChannels()
    }
    
    
}
