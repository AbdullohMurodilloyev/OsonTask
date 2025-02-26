//
//  AddressEntity+CoreDataProperties.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//
//

import Foundation
import CoreData


extension AddressEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AddressEntity> {
        return NSFetchRequest<AddressEntity>(entityName: "AddressEntity")
    }

    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var city: String?
    @NSManaged public var zipcode: String?

}

extension AddressEntity : Identifiable {

}
