//
//  Todo+CoreDataProperties.swift
//  
//
//  Created by doyeon kim on 2023/05/29.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var date: Date?
    @NSManaged public var detail: String?
    @NSManaged public var id: Int64
    @NSManaged public var isAlarmOn: Bool
    @NSManaged public var isArchive: Bool
    @NSManaged public var isDone: Bool

}
