//
//  ChatLogCell.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/17/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

class ChatCell: BaseCell {
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatCell.grayBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    var bubbleTextView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var messageTextView: UITextView = {
        let messageTextView = UITextView()
        messageTextView.isEditable = false
        messageTextView.isScrollEnabled = false
        messageTextView.font = UIFont.systemFont(ofSize: 18)
        messageTextView.backgroundColor = UIColor.clear
        return messageTextView
    }()
    
    static var grayBubbleImage: UIImage {
        return UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
    }
    
    static var blueBubbleImage: UIImage {
        return UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22,left: 26,bottom: 22,right: 26)).withRenderingMode(.alwaysTemplate)
    }
    
    override func setupViews() {
        
        super.setupViews()
        
        addSubview(bubbleTextView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        bubbleTextView.addSubview(bubbleImageView)
        
        addConstraintWith(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintWith(format: "V:[v0(30)]|", views: profileImageView)
        
        bubbleTextView.addConstraintWith(format: "H:|[v0]|", views: bubbleImageView)
        bubbleTextView.addConstraintWith(format: "V:|[v0]|", views: bubbleImageView)
        
    }
}
