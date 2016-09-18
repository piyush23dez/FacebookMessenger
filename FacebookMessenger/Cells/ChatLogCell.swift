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
        addSubview(bubbleTextView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintWith(format: "H:|[v0(30)]|", views: profileImageView)
        addConstraintWith(format: "V:[v0(30)]|", views: profileImageView)

    }
    
    var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    var bubbleTextView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var messageTextView: UITextView = {
        let messageTextView = UITextView()
        messageTextView.isScrollEnabled = false
        messageTextView.font = UIFont.systemFont(ofSize: 18)
        messageTextView.backgroundColor = UIColor.clear
        return messageTextView
    }()
}
