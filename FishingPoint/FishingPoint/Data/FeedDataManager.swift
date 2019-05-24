//
//  FeedDataManager.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import Foundation
import FirebaseUI

class FeedDataManager {
    static let shard = FeedDataManager()
    
    private init() {}
    
    var allFeedData: [FeedData] = []
    var allImageData: [StorageReference] = []
    var ImageData: Data!
    
    var pointName: String?
}
