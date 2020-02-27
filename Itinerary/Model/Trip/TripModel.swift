//
//  TripModel.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

struct TripModel {
    let id: UUID
    var title: String
    var image: UIImage?
    var dayModels = [DayModel]() {
        didSet {
            // Called when a new value assigned to dayModels
//            dayModels = dayModels.sorted(by: { (dayModel1, dayModel2) -> Bool in
//                dayModel1.title < dayModel2.title
//            })
            // alternative
//            dayModels = dayModels.sorted(by: { $0.title < $1.title })
            
            // to use this function use shold use comparable protocol inside DayModel model
            dayModels = dayModels.sorted(by: < )
        }
    }
    
    init(title: String, image: UIImage? = nil, dayModels: [DayModel]? = nil) {
        id = UUID()
        self.title = title
        self.image = image
        
        if let dayModels = dayModels {
            self.dayModels = dayModels
        }
    }
}
