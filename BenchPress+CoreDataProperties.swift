//
//  BenchPress+CoreDataProperties.swift
//  
//
//  Created by 피수영 on 2021/06/07.
//
//

import Foundation
import CoreData


extension BenchPress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BenchPress> {
        return NSFetchRequest<BenchPress>(entityName: "BenchPress")
    }

    @NSManaged public var weight: Double
    @NSManaged public var date: Date?

}
