//
//  UserData+CoreDataProperties.swift
//  Quizzin
//
//  Created by IPS-108 on 20/06/23.
//
//

import Foundation
import CoreData


extension UserData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }

    @NSManaged public var score: Int16
    @NSManaged public var username: String?

}

extension UserData : Identifiable {

}
