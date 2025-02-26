//
//  TodosEntity+CoreDataProperties.swift
//  OsonTask
//
//  Created by Abdulloh Murodilloyev on 26/02/25.
//
//

import Foundation
import CoreData


extension TodosEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodosEntity> {
        return NSFetchRequest<TodosEntity>(entityName: "TodosEntity")
    }

    @NSManaged public var id: Int16
    @NSManaged public var userId: Int16
    @NSManaged public var title: String?
    @NSManaged public var completed: Bool

}

extension TodosEntity : Identifiable {

}
