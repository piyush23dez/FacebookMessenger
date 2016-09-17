//
//  MessageCell.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/16/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit


class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() { }
}

class MessageCell: BaseCell {
    
    override var isHighlighted: Bool {
        
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1.0) : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.darkGray
            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var message: Message? {
        
        didSet {
            nameLabel.text = message?.friend?.name
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            messageLabel.text = message?.text
            
            if let date = message?.date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm:a"
                timeLabel.text = dateFormatter.string(from: date as Date)
            }
        }
    }
    
    var profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var dividerLine: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Your friend's message and something else"
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "12:23 pm"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    var hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLine)
        
        setupContainerView()
        
        addConstraintWith(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintWith(format: "V:[v0(68)]", views: profileImageView)
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        addConstraintWith(format: "H:|-82-[v0]|", views: dividerLine)
        addConstraintWith(format: "V:[v0(1)]|", views: dividerLine)
        
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(messageLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(hasReadImageView)
        
        addConstraintWith(format: "H:|-90-[v0]|", views: containerView)
        addConstraintWith(format: "V:[v0(50)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addConstraintWith(format: "H:|[v0][v1(80)]-12-|", views: nameLabel,timeLabel)
        containerView.addConstraintWith(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLabel,hasReadImageView)
        containerView.addConstraintWith(format: "V:|[v0(24)]", views: timeLabel)
        containerView.addConstraintWith(format: "V:[v0(20)]|", views: hasReadImageView)
        containerView.addConstraintWith(format: "V:|[v0][v1(24)]|", views: nameLabel,messageLabel)
        
    }
}
