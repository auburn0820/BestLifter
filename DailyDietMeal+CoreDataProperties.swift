//
//  DailyDietMeal+CoreDataProperties.swift
//  
//
//  Created by νΌμμ on 2021/06/07.
//
//

import Foundation
import CoreData


extension DailyDietMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyDietMeal> {
        return NSFetchRequest<DailyDietMeal>(entityName: "DailyDietMeal")
    }

    @NSManaged public var dailyDiet: String?

}
