//
//  HealthHandler.swift
//  Movers
//
//  Created by Michael Holler on 02/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation
import HealthKit

class HealthHandler {

    let healthKitStore:HKHealthStore = HKHealthStore()

    init() {
        // authorizeHealthKit()
    }

    func authorizeHealthKit() -> Bool {
 
        var isOK = true
        
        // If the store is not available (for instance, iPad) return an error and don't go on.
        if (HKHealthStore.isHealthDataAvailable()) {
    
            // Set the types you want to write to HK Store
            let shareTypes = Set(arrayLiteral:HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!)
            let readTypes = Set(arrayLiteral:HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!)
 
            // Request HealthKit authorization
            healthKitStore.requestAuthorizationToShareTypes(shareTypes, readTypes:readTypes) {
                (success, error) -> Void in isOK = success  }
        } else {
          isOK = false
        }
            
        return isOK
    }
    
    func saveWeight(date:NSDate, weight:Double) {
        print("Save weight")
    }
    
    func loadWeights(completion: ([[String:AnyObject]]) -> ()) {
        
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

        // Our search predicate which will fetch data from now until a day ago
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate(timeIntervalSinceNow:-2592000), endDate: NSDate(), options: .None)

        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            print("getting results")
            var weights:[[String:AnyObject]] = Array()

            if results?.count > 0 {
                for result in results as! [HKQuantitySample] {
                    let date = result.startDate
                    let weight = result.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
                    weights.append(["date": date, "weight": weight])
                    print(weight)
                }
            }
            completion(weights)
        }

        healthKitStore.executeQuery(query)
    }
    
}
