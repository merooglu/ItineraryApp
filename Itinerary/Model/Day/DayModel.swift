//
//  DayModel.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 18.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

struct DayModel {
    var id: String!
    var title = Date()
    var subTitle = ""
    var activityModels = [ActivityModel]()
    
    init(title: Date, subTitle: String, tripData: [ActivityModel]?) {
        id = UUID().uuidString
        self.title = title
        self.subTitle = subTitle
        
        if let tripData = tripData {
            self.activityModels = tripData
        }
    }
}
