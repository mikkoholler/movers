//
//  Weight.swift
//  Movers
//
//  Created by Michael Holler on 01/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation

class Weight {

    var date = NSDate()
    var weight = Double()

    init(date: NSDate, weight: Double) {
        self.date = date
        self.weight = weight
    }
}