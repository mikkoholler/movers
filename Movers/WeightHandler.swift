//
//  WeightHandler.swift
//  Movers
//
//  Created by Michael Holler on 01/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation

class WeightHandler {

    static func loadWeights() -> [[String:AnyObject]]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let weights = defaults.arrayForKey("Weights") as? [[String:AnyObject]]
        return weights
    }
    
    static func saveWeights(weights: [[String:AnyObject]]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(weights, forKey: "Weights")

    }
}