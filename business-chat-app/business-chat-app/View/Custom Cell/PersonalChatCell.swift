//
//  PersonalChatCell.swift
//  business-chat-app
//
//  Created by Timofei Sopin on 2018-03-18.
//  Copyright © 2018 Brogrammers. All rights reserved.
//

import UIKit
import Kingfisher

class PersonalChatCell: UITableViewCell {

    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var contactEmail: UILabel!
    
    @IBOutlet weak var lastMessage: UILabel!
    
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var userpicImage: UIImageView!
    
    
    func configeureCell(contactName: String, contactEmail: String, lastMessage: String, statusImage: UIImage) {
        
        let placeHolder = UIImage(named: "userpic_placeholder_small" )
        
        userpicImage.layer.masksToBounds = true
        userpicImage.layer.cornerRadius = 20
        
        self.contactName.text = contactName
        self.contactEmail.text = contactEmail
        self.lastMessage.text = lastMessage
        self.statusImage.image = statusImage
        self.userpicImage.image = placeHolder
    }
    
    
}
