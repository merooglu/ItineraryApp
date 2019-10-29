//
//  TripFunctions.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class TripFunctions {
    
    static func createTrip(tripModel: TripModel) {
        
    }
    
    static func readTrips() {
        if Data.tripModels.count == 0 {
            Data.tripModels.append(TripModel(title: "Trip to Bali"))
            Data.tripModels.append(TripModel(title: "Mexico"))
            Data.tripModels.append(TripModel(title: "Russian Trip"))
        }
    }
    
    static func updateTrip(tripModel: TripModel) {
        
    }
    
    static func deleteTrip(tripModel: TripModel) {
        
    }
}
