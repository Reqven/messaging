//
//  ConversationListTableViewController.swift
//  Messaging
//
//  Created by Manu on 28/04/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ConversationTableViewController: UITableViewController {
    
    var conversations = [String]()
    var selected: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = self.editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed(_:)))
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        setupData()
        setupTableView()
    }
    
    
    //MARK: - Setup functions
    func setupData() {
        conversations.append("Unique chat")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollsToTop = true
        tableView.showsVerticalScrollIndicator = true
    }
    
    
    //MARK: - TableView functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = conversations[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "fromConversationToChat", sender: self)
    }
    
    
    //MARK: - Buttons actions functions
    @objc func logoutPressed(_ sender: UIBarButtonItem!) {
        SVProgressHUD.show()
        do {
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        SVProgressHUD.dismiss()
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromConversationToChat" {
            let controller = segue.destination as! ChatViewController
            controller.conversation = conversations[selected!]
        }
    }
}
