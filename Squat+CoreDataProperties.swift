//
//  Squat+CoreDataProperties.swift
//  
//
//  Created by νΌμμ on 2021/06/07.
//
//

import Foundation
import CoreData


extension Squat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Squat> {
        return NSFetchRequest<Squat>(entityName: "Squat")
    }

    @NSManaged public var weight: Double
    @NSManaged public var date: Date?

}
