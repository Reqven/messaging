//
//  Message.swift
//  Messaging
//
//  Created by Manu on 01/05/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

struct Message {
    
    var sender: String
    var message: String
    
    init(sender: String, message: String) {
        self.sender = sender
        self.message = message
    }
}
