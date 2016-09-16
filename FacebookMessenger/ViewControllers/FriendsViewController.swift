//
//  FriendsViewController.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/16/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit


class FriendsViewController: UICollectionViewController {
    
    let cellId = "cellId"
    fileprivate var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recent"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        setupData()
    }
}

extension FriendsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCell
        cell?.message = messages[indexPath.item]
        return cell!
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        collectionViewLayout.invalidateLayout()
    }
}

extension FriendsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

private extension FriendsViewController {
    
    func setupData() {
        
        let mark = Friend()
        mark.name = "Mark"
        mark.profileImageName = "zuckprofile"
        
        let markMessage = Message()
        markMessage.friend = mark
        markMessage.text = "Hello, my name is Mark, Nice to meet you"
        markMessage.date = Date()
        
        let steve = Friend()
        steve.name = "Steve"
        steve.profileImageName = "steve_profile"
        
        let steveMessage = Message()
        steveMessage.friend = steve
        steveMessage.text = "Apple creates great iOS devices for the world"
        steveMessage.date = Date()
        
        messages.append(markMessage)
        messages.append(steveMessage)

    }

}

