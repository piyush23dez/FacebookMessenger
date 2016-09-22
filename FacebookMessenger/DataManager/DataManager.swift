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
    
    private init() {
        
        if let friends = fetchFreinds(), friends.count == 0 {
           
            let moc = delegate?.persistentContainer.viewContext
            moc!.performAndWait {
                self.setup(context: moc!)
            }
            save()
        }
    }

    private func clear() {
        
        let allEntities = ["Friend" , "Message"]
        
        let moc = delegate?.persistentContainer.viewContext
        moc?.performAndWait {
            
            for entity in allEntities {
                let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
                do {
                    if let objects = try moc!.fetch(request) as? [NSManagedObject] {
                        for object in objects {
                            moc!.delete(object)
                        }
                    }
                }
                catch let error {
                    print(error)
                }
            }
            self.delegate?.saveContext()
        }
    }
    
    private func setup(context moc: NSManagedObjectContext) {
        
        //Friend
        let mark = createFriend(name: "Mark Zukerberg", imageName: "zuckprofile", context: moc)
        //Message
        createMessage(text: "Hello, my name is Mark, Nice to meet you", minutesAgo: 1 , frind: mark, context: moc)
        
        //Friend
        let steve = createFriend(name: "Steve Jobs", imageName: "steve_profile", context: moc)
        //Message
        createMessage(text: "Good Morning Johny, How is it going?", minutesAgo: 3, frind: steve, context: moc)
        
        //Friend
        let trump = createFriend(name: "Donald Trump", imageName: "donald_trump_profile", context: moc)
        //Message
        createMessage(text: "You are hired", minutesAgo: 5, frind: trump, context: moc)
        
        //Friend
        let ghandhi = createFriend(name: "Mahatma Ghandhi", imageName: "gandhi", context: moc)
        //Message
        createMessage(text: "Love, Peace, and Joy", minutesAgo: 60*24, frind: ghandhi, context: moc)
        
        //Friend
        let hillary = createFriend(name: "Hillary Clinton", imageName: "hillary_profile", context: moc)
        //Message
        createMessage(text: "Please vote for me, you did for Billy", minutesAgo: 8*60*24, frind: hillary, context: moc)
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
    
    func save() {
        delegate?.saveContext()
    }
    
    private func fetchFreinds() -> [Friend]? {
        
        let moc = delegate?.persistentContainer.viewContext
        var allFriends = [Friend]()
        
        moc?.performAndWait {
            let request: NSFetchRequest<Friend> = Friend.fetchRequest()
            do {
                allFriends = try moc!.fetch(request)
            }
            catch let error {
                print(error)
            }
        }
        return (allFriends.count > 0) ? allFriends : []
    }
}
