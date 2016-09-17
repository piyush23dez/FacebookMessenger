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
        clearData()
        saveData()
    }
    
    func saveData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        
        if let context = delegate?.persistentContainer.viewContext {
            
            //Friend
            let mark = createFriend(name: "Mark Zukerberg", imageName: "zuckprofile", context: context)
            //Message
            createMessage(text: "Hello, my name is Mark, Nice to meet you", minutesAgo: 1 , frind: mark, context: context)

            //Friend
            let steve = createFriend(name: "Steve Jobs", imageName: "steve_profile", context: context)
            //Message
            createMessage(text: "Good Morning Apple", minutesAgo: 2, frind: steve, context: context)
            createMessage(text: "How Are you?", minutesAgo: 3 ,frind: steve, context: context)
            createMessage(text: "Are you ready for iPhone 7?", minutesAgo: 4, frind: steve, context: context)
            
            //Friend
            let trump = createFriend(name: "Donald Trump", imageName: "donald_trump_profile", context: context)
            createMessage(text: "You are hired", minutesAgo: 5, frind: trump, context: context)

            
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
        }
        
        loadData()
    }
    
    func createFriend(name: String, imageName: String,context: NSManagedObjectContext) -> Friend {
        let friend = Friend(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
        friend.name = name
        friend.profileImageName = imageName
        return friend
    }
    
    func createMessage(text: String, minutesAgo: Double, frind: Friend, context: NSManagedObjectContext) {
        
        let message = Message(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
        message.friend = frind
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo*60)
    }
    
    func loadData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            messages = [Message]()
            
            if let freinds = fetchFreinds() {
                
                for friend in freinds {
                    
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do {
                        if let allMessages = try context.fetch(fetchRequest) as? [Message] {
                            messages.append(contentsOf: allMessages)
                        }
                    }
                    catch let error {
                        print(error)
                    }
                }
                messages.sort { $0.date! > $1.date! } // ascending date order
            }
        }
    }
    
    func fetchFreinds() -> [Friend]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Friend")
            do {
                if let allFriends = try context.fetch(fetchRequest) as? [Friend] {
                    return allFriends
                }
            }
            catch let error {
                print(error)
            }
            
        }
        
        return nil
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

