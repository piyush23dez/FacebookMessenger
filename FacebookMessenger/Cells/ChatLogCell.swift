//
//  ChatLogCell.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/17/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

class ChatCell: BaseCell {
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(messageTextView)
        addConstraintWith(format: "H:|[v0]|", views: messageTextView)
        addConstraintWith(format: "V:|[v0]|", views: messageTextView)
    }
    
    var messageTextView: UITextView = {
        let messageTextView = UITextView()
        messageTextView.text = "Sample"
        messageTextView.font = UIFont.systemFont(ofSize: 16)
        return messageTextView
    }()
}
