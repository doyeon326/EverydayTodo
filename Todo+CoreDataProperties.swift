//
//  Todo+CoreDataProperties.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2020/12/28.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var id: Int64
    @NSManaged public var detail: String?
    @NSManaged public var date: String?

}

extension Todo : Identifiable {

}
