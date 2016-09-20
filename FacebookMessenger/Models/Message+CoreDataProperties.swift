//
//  Message+CoreDataProperties.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/20/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import Foundation
import CoreData

extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var date: Date?
    @NSManaged public var isSender: Bool
    @NSManaged public var text: String?
    @NSManaged public var friend: Friend?

}
