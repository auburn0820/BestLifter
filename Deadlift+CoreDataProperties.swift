//
//  Deadlift+CoreDataProperties.swift
//  
//
//  Created by νΌμμ on 2021/06/07.
//
//

import Foundation
import CoreData


extension Deadlift {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Deadlift> {
        return NSFetchRequest<Deadlift>(entityName: "Deadlift")
    }

    @NSManaged public var weight: Double
    @NSManaged public var date: Date?

}
