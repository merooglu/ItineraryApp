//
//  ActivityFunctions.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 5.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class ActivityFunctions {
    static func createActivity(at tripIndex: Int, for dayIndex: Int, using activityModel: ActivityModel) {
        // Replace with real data source code
        
        TripData.tripModels[tripIndex].dayModels[dayIndex].activityModels.append(activityModel)
    }
}
