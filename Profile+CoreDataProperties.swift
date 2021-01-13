//
//  Profile+CoreDataProperties.swift
//  EverydayTodo
//
//  Created by Tony Jung on 2021/01/13.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var nickName: String?
    @NSManaged public var profileImg: Data?
    @NSManaged public var themeColor: String?

}

extension Profile : Identifiable {

}
