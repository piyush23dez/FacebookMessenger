//
//  ChatLogController.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/17/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController {
    
    fileprivate let cellId = "cellId"
    
    var friend: Friend? {
        
        didSet {
            messages = friend?.messages?.allObjects as! [Message]
            messages.sort { $0.date! < $1.date! } //ascending date order
        }
    }
    
    var messages = [Message]()
    var bottomConstraint: NSLayoutConstraint?
    
    var inputMessageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var inputTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Type"
        return textField
    }()
    
    var sendButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor.init(red: 0, green: 131/255, blue: 249/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = friend?.name
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        view.addSubview(inputMessageView)
        view.addConstraintWith(format: "H:|[v0]|", views: inputMessageView)
        view.addConstraintWith(format: "V:[v0(40)]", views: inputMessageView)
        bottomConstraint = NSLayoutConstraint(item: inputMessageView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        setupInputView()
        addKeyboardObservers()
    }
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_ :)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(_ :)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                
                let isKeyboardShowing = notification.name.rawValue == Notification.Name.UIKeyboardWillShow.rawValue
                self.bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height : 0
               
                //Animate input textfield alongwith keyboard
                UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: nil)

                DispatchQueue.main.async {
                    
                    UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
                        if isKeyboardShowing {
                            let indexPath = IndexPath(item: self.messages.count-1, section: 0)
                            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
                        }
                    }, completion: nil)
                }
            }
        }
    }
    
    private func setupInputView() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        inputMessageView.addSubview(topBorderView)
        inputMessageView.addSubview(inputTextField)
        inputMessageView.addSubview(sendButton)

        inputMessageView.addConstraintWith(format: "H:|-8-[v0][v1(60)]|", views: inputTextField,sendButton)
        inputMessageView.addConstraintWith(format: "V:|[v0]|", views: inputTextField)
        inputMessageView.addConstraintWith(format: "V:|[v0]|", views: sendButton)
        inputMessageView.addConstraintWith(format: "H:|[v0]|", views: topBorderView)
        inputMessageView.addConstraintWith(format: "V:|[v0(0.5)]", views: topBorderView)
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatCell
        cell.messageTextView.text = messages[indexPath.item].text
        
        if let messageText = messages[indexPath.item].text, let profileImageName = messages[indexPath.item].friend?.profileImageName {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            //Calculate estimated frame based on estimated width and height
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
           
            if !messages[indexPath.item].isSender {
                cell.messageTextView.frame = CGRect(x: 48+10, y: 0, width: estimatedFrame.width+16, height: estimatedFrame.height + 20)
               
                cell.bubbleTextView.frame = CGRect(x: 48-10, y: -4, width: estimatedFrame.width+16+8+16, height: estimatedFrame.height + 20 + 6)

                cell.profileImageView.isHidden = false
                cell.messageTextView.textColor = UIColor.black
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.image = ChatCell.grayBubbleImage
            }
            else {
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 2, y: 0, width: estimatedFrame.width+16, height: estimatedFrame.height + 20)
                
                cell.bubbleTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width+44, height: estimatedFrame.height+20+6)
                
                cell.profileImageView.isHidden = true
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1.0)
                cell.messageTextView.textColor = UIColor.white
                cell.bubbleImageView.image = ChatCell.blueBubbleImage
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let messageText = messages[indexPath.item].text {
          
            //Calculate estimated frame based on estimated width and height
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18)]
            
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismissKeyboard()
    }
    
    private func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
}
