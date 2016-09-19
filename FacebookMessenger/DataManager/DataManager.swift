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
    fileprivate var messages = [Message]()
    fileprivate let delegate = UIApplication.shared.delegate as? AppDelegate

    private init() {
        clear()
        setup()
        save()
        load()
    }
    
    func getMessages() -> [Message] {
        return messages
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
            
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
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
            createMessage(text: "Good Morning Johny", minutesAgo: 2, frind: steve, context: context)
            createMessage(text: "How is it going?", minutesAgo: 3 ,frind: steve, context: context)
            
            //Response message
            createMessage(text: "Everything is going good", minutesAgo: 1, frind: steve, context: context, isSender: true)
            createMessage(text: "What is preogress on iPhone 7?", minutesAgo: 1, frind: steve, context: context)
            createMessage(text: "We are almost done with design", minutesAgo: 1, frind: steve, context: context,isSender: true)
            createMessage(text: "Thats good, we soon gonna launch new iPhone 7", minutesAgo: 1, frind: steve, context: context)
            createMessage(text: "Perfect", minutesAgo: 1, frind: steve, context: context,isSender: true)
            createMessage(text: "What is the status on Apple TV?", minutesAgo: 1, frind: steve, context: context)
            createMessage(text: "We are making progress on it", minutesAgo: 1, frind: steve, context: context,isSender: true)

            
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
    
    private func createFriend(name: String, imageName: String,context: NSManagedObjectContext) -> Friend {
        let friend = Friend(entity: NSEntityDescription.entity(forEntityName: "Friend", in: context)!, insertInto: context)
        friend.name = name
        friend.profileImageName = imageName
        return friend
    }
    
    private func createMessage(text: String, minutesAgo: Double, frind: Friend, context: NSManagedObjectContext, isSender: Bool = false) {
        
        let message = Message(entity: NSEntityDescription.entity(forEntityName: "Message", in: context)!, insertInto: context)
        message.friend = frind
        message.text = text
        message.date = Date().addingTimeInterval(-minutesAgo*60) // convert minutes in seconds
        message.isSender = isSender
    }
    
    private func save() {
        
        if let context = delegate?.persistentContainer.viewContext {
            do {
                try context.save()
            }
            catch let error {
                print(error)
            }
        }
    }
    
    private func loadFreinds() -> [Friend]? {

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
    
    private func load() {
        
        if let context = delegate?.persistentContainer.viewContext {
            
            messages = [Message]()
            
            if let freinds = loadFreinds() {
                
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
}
