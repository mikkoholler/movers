//
//  FeedItem.swift
//  Movers
//
//  Created by Michael Holler on 14/03/16.
//  Copyright © 2016 Holler. All rights reserved.
//

import Foundation
import UIKit

struct FeedItem {
    var id = Int()
    var type = String()
    var name = String()
    var date = String()
    var sport = String()
    var title = String()
    var desc = String()
    var mood = Int()
    var weight = Double()
    var avatarurl = String()
    var avatar = UIImage()
    var commentedby = String()
    var commentcount = Int()
    var comments = [Comment]()
    var cheeredby = String()
    var cheercount = Int()
    var hasCheered = false
}

struct Comment {
    var name = String()
    var text = String()
}
