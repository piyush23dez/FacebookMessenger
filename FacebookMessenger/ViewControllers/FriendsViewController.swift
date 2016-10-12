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
    private let managedContext = DataManager.sharedManager.delegate?.persistentContainer.viewContext
    
    fileprivate lazy var fetchResultsController: NSFetchedResultsController<Friend> = {
     
        let fetchRequest: NSFetchRequest<Friend> = Friend.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext!)
        return frc
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        managedContext?.performAndWait {
            do {
                try self.fetchResultsController.performFetch()
            }
            catch let error {
                print(error)
            }
        }
        
        navigationItem.title = "Recent"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //print(documentsPath)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
        if (collectionView?.indexPathsForSelectedItems?.count)! > 0 {
            reload()
        }
    }
    
    private func reload() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
}

extension FriendsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let friend = fetchResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MessageCell
        cell?.message = friend.lastMessage
        
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
        let friend = fetchResultsController.object(at: indexPath)       
        chatlLogViewController.friend = friend
        navigationController?.pushViewController(chatlLogViewController, animated: true)
    }
}

