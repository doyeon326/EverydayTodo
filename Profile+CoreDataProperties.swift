//
//  Profile+CoreDataProperties.swift
//  
//
//  Created by doyeon kim on 2023/05/29.
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
