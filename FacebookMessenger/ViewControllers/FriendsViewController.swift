//
//  FriendsViewController.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/16/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit
import CoreData

class FriendsViewController: UICollectionViewController {
    
    fileprivate let cellId = "cellId"
    fileprivate var messages = [Message]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.title = "Recent"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(documentsPath)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chatlLogViewController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatlLogViewController.friend = messages[indexPath.item].friend
        navigationController?.pushViewController(chatlLogViewController, animated: true)
    }
}

private extension FriendsViewController {
    
    func setupData() {
        messages = DataManager.sharedManager.getMessages()
    }
}

