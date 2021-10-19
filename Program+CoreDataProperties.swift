//
//  Program+CoreDataProperties.swift
//  
//
//  Created by 피수영 on 2021/06/07.
//
//

import Foundation
import CoreData


extension Program {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Program> {
        return NSFetchRequest<Program>(entityName: "Program")
    }

    @NSManaged public var date: Date?
    @NSManaged public var routine: String?
    @NSManaged public var total_weight: Int16

}
