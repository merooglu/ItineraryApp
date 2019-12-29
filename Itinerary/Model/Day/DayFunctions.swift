//
//  DayFunctions.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class DayFunctions {
    static func createDays(at tripIndex: Int, using dayModel: DayModel) {
        // Replace with real data source code
        
        TripData.tripModels[tripIndex].dayModels.append(dayModel)
    }
}
