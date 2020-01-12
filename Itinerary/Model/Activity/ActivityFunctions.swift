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
    
    static func deleteActivity(at tripIndex: Int, for dayIndex: Int, using activityModel: ActivityModel) {
        // Replace with real data source code
        let dayModel = TripData.tripModels[tripIndex].dayModels[dayIndex]
        if let index = dayModel.activityModels.firstIndex(of: activityModel) {
            TripData.tripModels[tripIndex].dayModels[dayIndex].activityModels.remove(at: index)
        }
    }
    
    static func updateActivity(at tripIndex: Int, oldDayIndex: Int, newDayIndex:Int, using activityModel: ActivityModel) {
        // Replace with real data source code
        if oldDayIndex != newDayIndex {
            // Move activity to different day
            let lastIndex = TripData.tripModels[tripIndex].dayModels[newDayIndex].activityModels.count
            reorderActivity(at: tripIndex, oldDayIndex: oldDayIndex, newDayIndex: newDayIndex, newActivityIndex: lastIndex, activityModel: activityModel)
        } else {
            // Update activity in same day
            let dayModel = TripData.tripModels[tripIndex].dayModels[oldDayIndex]
            let activityIndex = (dayModel.activityModels.firstIndex(of: activityModel))!
            TripData.tripModels[tripIndex].dayModels[newDayIndex].activityModels[activityIndex] = activityModel
        }
    }
    
    static func reorderActivity(at tripIndex: Int, oldDayIndex: Int, newDayIndex: Int, newActivityIndex: Int, activityModel: ActivityModel) {
        // Replace with real data source code
        
        // 1. Remove activity from old location
        let oldDayModel = TripData.tripModels[tripIndex].dayModels[oldDayIndex]
        let oldActivityIndex = (oldDayModel.activityModels.firstIndex(of: activityModel))!
        TripData.tripModels[tripIndex].dayModels[oldDayIndex].activityModels.remove(at: oldActivityIndex)
        
        // 2.Insert Activity into new location
        TripData.tripModels[tripIndex].dayModels[newDayIndex].activityModels.insert(activityModel, at: newActivityIndex)
        
    }
}
