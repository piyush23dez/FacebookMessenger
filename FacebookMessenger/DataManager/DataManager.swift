//
//  DataManager.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/17/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import CoreData
import UIKit

class DataManager {
    
    static let sharedManager = DataManager()
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    var messageCount: Int? {
        get {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Message")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "date", ascending: true)]
            do {
                return try delegate?.persistentContainer.viewContext.count(for: fetchRequest)
            }
            catch let error {
                print(error)
            }
            return 0
        }
    }
    
    private init() {
        //clear()
        
        if let friends = fetchFreinds(), friends.count == 0 {
            setup()
            save()
        }
    }

    private func clear() {
        
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
            delegate?.saveContext()
        }
    }
    
    private func setup() {
        
        if let context = delegate?.persistentContainer.viewContext {
            
            //Friend
            let mark = createFriend(name: "Mark Zukerberg", imageName: "zuckprofile", context: context)
            //Message
            createMessage(text: "Hello, my name is Mark, Nice to meet you", minutesAgo: 1 , frind: mark, context: context)
            
            //Friend
            let steve = createFriend(name: "Steve Jobs", imageName: "steve_profile", context: context)
            //Message
            createMessage(text: "Good Morning Johny, How is it going?", minutesAgo: 3, frind: steve, context: context)
            
            //Friend
            let trump = createFriend(name: "Donald Trump", imageName: "donald_trump_profile", context: context)
            //Message
            createMessage(text: "You are hired", minutesAgo: 5, frind: trump, context: context)
            
            //Friend
            let ghandhi = createFriend(name: "Mahatma Ghandhi", imageName: "gandhi", context: context)
            //Message
            createMessage(text: "Love, Peace, and Joy", minutesAgo: 60*24, frind: ghandhi, context: context)
            
            //Friend
            let hillary = createFriend(name: "Hillary Clinton", imageName: "hillary_profile", context: context)
            //Message
            createMessage(text: "Please vote for me, you did for Billy", minutesAgo: 8*60*24, frind: hillary, context: context)
        }
    }
    
    private func createFriend(name: String, imageName: String, context: NSManagedObjectContext) -> Friend {
        let friend = Friend(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
        friend.name = name
        friend.profileImageName = imageName
        return friend
    }
    
    @discardableResult func createMessage(text: String, minutesAgo: Double, frind: Friend, context: NSManagedObjectContext, isSender: Bool = false) -> Message {
        
        let message = Message(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
        message.friend = frind
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo*60) // convert minutes in seconds
        message.isSender = isSender
        frind.lastMessage = message
        return message
    }
    
    private func save() {
        delegate?.saveContext()
    }
    
    private func fetchFreinds() -> [Friend]? {

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
}
