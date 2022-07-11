//
//  StatusTableViewController.swift
//  Raya
//
//  Created by Yahya haj ali  on 30/04/2022.
//

import UIKit

class StatusTableViewController: UITableViewController {

    let statuses = ["Available","Busy","I am sleeping" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return statuses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = statuses[indexPath.row]
        let userStatus = User.currentUser?.status
        cell?.accessoryType = userStatus == statuses[indexPath.row] ? .checkmark : .none
        return cell!
        
                
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let userStatus = tableView.cellForRow(at: indexPath)?.textLabel?.text
        tableView.reloadData()
        
        var user = User.currentUser
        user?.status = userStatus!
        saveUserLocally(user!)
        FUserListener.shared.saveUserToFirestore(user!)
       
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "ColorTableview")
        
        return headerView
        
    }

    
}
