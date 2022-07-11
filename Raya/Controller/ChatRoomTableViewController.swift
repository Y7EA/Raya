//
//  ChatRoomTableViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 24/04/2022.
//

import UIKit

class ChatRoomTableViewController: UITableViewController {

     //MARK:- IBActions
        
    @IBAction func composeButtonPressed(_ sender: UIBarButtonItem) {
        
        let userView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "usersView") as! UsersTableViewController
        
        navigationController?.pushViewController(userView, animated: true)
        
    }
    
    
     //MARK:- Vars
    
    var allChatRooms:[ChatRoom] = []
    var filteredChaRooms:[ChatRoom] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        downloadChatRooms()

        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        
        self.refreshControl = UIRefreshControl ()
        self.tableView.refreshControl = self.refreshControl
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchController.isActive ? filteredChaRooms.count :        allChatRooms.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatTableViewCell
        
        
        // let chatRoom = ChatRoom(id: "123", chatRoomId: "123", senderId: "123", senderName: "Yahya", receiverId: "123", receiverName: "Rahaf", date: Date(), memberIds: [""], lastMessage: "Hi Rahaf i miss you ", unreadCounter: 1, avatarLink: "")

        
        cell.configure(chatRoom: searchController.isActive ? filteredChaRooms[indexPath.row]: allChatRooms[indexPath.row])
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    
     //MARK:- TableView Delegation function (Delete)
    // TableView Delegation Function  في مشكلة ف الحذف مش عارف من هين او من الفنكشن نفسها المشكله ف السحب تغلب طلعت عشان ماوس لازم اضل كابس واسحب من الطرف 

    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let chatRoom = searchController.isActive ? filteredChaRooms[indexPath.row]: allChatRooms[indexPath.row]
            
            FChatRoomListener.shared.deleteChatRoom(chatRoom)
         
            searchController.isActive ? self.filteredChaRooms.remove(at: indexPath.row): allChatRooms.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chatRoomObject = searchController.isActive ? filteredChaRooms[indexPath.row] : allChatRooms[indexPath.row]
        
        goToMSG(chatRoom: chatRoomObject)
       
    }
            
    private func downloadChatRooms() {
        
        FChatRoomListener.shared.downloadChatRooms { (allFBChatRooms) in
            self.allChatRooms = allFBChatRooms
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
     //MARK:- Navigation
    
    func goToMSG(chatRoom: ChatRoom) {
        
        //TODO:- To make sure that both users have chatrooms
        
        restartChat(chatRoomId: chatRoom.chatRoomId, memberIds: chatRoom.memberIds)
        
        let privateMSGView = MSGViewController(chatId: chatRoom.chatRoomId, recipientId: chatRoom.receiverId, recipientName: chatRoom.receiverName)

        navigationController?.pushViewController(privateMSGView, animated: true)

    }
    

}


extension ChatRoomTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

        filteredChaRooms = allChatRooms.filter({ (chatRoom) -> Bool in
            return chatRoom.receiverName.lowercased().contains(searchController.searchBar.text!.lowercased())


        })
        tableView.reloadData()


    }
}
