//
//  MessageReceivedTableViewCell.swift
//  Messaging
//
//  Created by Manu on 01/05/2019.
//  Copyright © 2019 Manu Marchand. All rights reserved.
//

import UIKit

class MessageReceivedTableViewCell: UITableViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var bubble: UIView!
    @IBOutlet weak var message: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup() {
        bubble.layer.cornerRadius = 17.5
        bubble.layer.masksToBounds = false
        bubble.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1.0)
        
        message.backgroundColor = .clear
        message.textColor = .black
        
        backgroundColor = .clear
        
        let maxWidth = 0.75 * view.frame.width
        let constraint = NSLayoutConstraint(item: bubble!, attribute: .width, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .notAnAttribute, multiplier: .nan, constant: maxWidth)
        
        addConstraint(constraint)
    }
}
