//
//  Deadlift+CoreDataProperties.swift
//  
//
//  Created by 피수영 on 2021/06/07.
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
