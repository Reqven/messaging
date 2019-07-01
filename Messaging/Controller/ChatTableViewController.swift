//
//  MessagingViewController.swift
//  Messaging
//
//  Created by Manu on 28/04/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var conversation: String?
    var messages = [Message]()
    var user: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        user = Auth.auth().currentUser?.email
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = conversation
        
        setupTableView()
        retrieveMessages()
    }
    
    //MARK: - Setup functions
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.scrollsToTop = true
        tableView.showsVerticalScrollIndicator = true
        tableView.register(UINib(nibName: "MessageSentTableViewCell", bundle: nil), forCellReuseIdentifier: "sent")
        tableView.register(UINib(nibName: "MessageReceivedTableViewCell", bundle: nil), forCellReuseIdentifier: "received")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func retrieveMessages() {
        let database = Database.database().reference().child("Messages")
        database.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let message = Message(sender: snapshotValue["sender"]!, message: snapshotValue["message"]!)
            self.messages.append(message)
            self.tableView.reloadData()
            self.scrollDown()
        }
        scrollDown()
    }

    
    //MARK: - TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        if message.sender == user {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sent", for: indexPath) as! MessageSentTableViewCell
            cell.message.text = message.message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "received", for: indexPath) as! MessageReceivedTableViewCell
            cell.message.text = message.message
            return cell
        }
    }
    
    
    //MARK: - Keyboard related functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if messageViewHeightConstraint.constant != 75 {return}
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
    
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.messageViewHeightConstraint.constant += (keyboardFrame.height - 38)
            self.view.layoutIfNeeded()
        })
        scrollDown()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            self.messageViewHeightConstraint.constant = 75
            self.view.layoutIfNeeded()
        })
    }
    
    
    //MARK: - Buttons actions functions
    @IBAction func sendPressed(_ sender: Any) {
        messageTextField.endEditing(true)
        
        if messageTextField.text! == "" {
            return
        }
        let database = Database.database().reference().child("Messages")
        let message = [
            "sender": Auth.auth().currentUser?.email,
            "message": messageTextField.text!
        ]
        database.childByAutoId().setValue(message) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Message saved")
                self.messageTextField.text = ""
            }
        }
    }
    
    
    //MARK: - Others
    @objc func scrollDown() {
        if !self.messages.isEmpty {
            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        }
    }
    
    @objc func tableViewTapped() {
        messageTextField.endEditing(true)
    }
}
