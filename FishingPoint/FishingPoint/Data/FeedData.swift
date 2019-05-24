//
//  FeedData.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import Foundation
import UIKit

struct FeedData {
    let feedImage: String!
    let pointName: String!
    let rodName: String!
    let reelName: String!
    let lureName: String!
    
    init(feedImage: String, pointName: String, rodName: String, reelName: String, lureName: String) {
        self.feedImage = feedImage
        self.pointName = pointName
        self.rodName = rodName
        self.reelName = reelName
        self.lureName = lureName
    }
}
