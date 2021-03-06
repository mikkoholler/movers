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
    
        let type = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!
        let quantity = HKQuantity(unit: HKUnit.gramUnitWithMetricPrefix(.Kilo), doubleValue: weight)
        let sample = HKQuantitySample(type: type, quantity: quantity, startDate: date, endDate: date)
 
        healthKitStore.saveObject(sample) { success, error in
            if (error != nil) {
                print("Error saving")
            }
        }
    }
    
    func loadWeights(completion: ([Weight]) -> ()) {
        
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)

        // get weights from last month (2592000 in seconds)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate(timeIntervalSinceNow:-2592000), endDate: NSDate(), options: .None)
        let sort = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: [sort]) { query, results, error in
            var weights:[Weight] = Array()

            if results?.count > 0 {
                for result in results as! [HKQuantitySample] {
                    let date = result.startDate
                    let weight = result.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo))
                    weights.append(Weight(date: date, kg: weight))
                }
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(weights)
            }
        }

        healthKitStore.executeQuery(query)
    }
    
}
