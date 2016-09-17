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
        clearData()
        saveData()
    }
    
    func saveData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            //Friend
            let mark = Friend(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
            mark.name = "Mark Zukerberg"
            mark.profileImageName = "zuckprofile"
            
            //Message
            let markMessage = Message(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
            markMessage.friend = mark
            markMessage.text = "Hello, my name is Mark, Nice to meet you"
            markMessage.date = Date()
            
            //Friend
            let steve = Friend(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
            steve.name = "Steve Jobs"
            steve.profileImageName = "steve_profile"
            
            //Message
            let steveMessage = Message(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
            steveMessage.friend = steve
            steveMessage.text = "Apple creates great iOS devices for the world"
            steveMessage.date = Date()
            
            //messages = [markMessage, steveMessage]
            
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
        }
        
        loadData()
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Message")
            
            do {
                if let allMessages = try context.fetch(fetchRequest) as? [Message] {
                    messages = allMessages
                }
            }
            catch let error {
                print(error)
            }
        }
    }
    
    func clearData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
       
        let allEntities = ["Friend" , "Message"]
        
        if let context = delegate?.persistentContainer.viewContext {
           
            for entity in allEntities {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
                do {
                    if let objects = try context.fetch(fetchRequest) as? [NSManagedObject] {
                        for object in objects {
                            context.delete(object)
                        }
                    }
                }
                catch let error {
                    print(error)
                }
            }
            
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
        }
    }
}

