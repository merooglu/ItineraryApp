//
//  TripFunctions.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class TripFunctions {
    // static keyword means you don't need the initiate the TripFunction class every time, when you call the functions in this class
    static func createTrip(tripModel: TripModel) {
        
    }
    
    static func readTrips(complition: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if TripData.tripModels.count == 0 {
                TripData.tripModels.append(TripModel(title: "Trip to Bali"))
                TripData.tripModels.append(TripModel(title: "Mexico"))
                TripData.tripModels.append(TripModel(title: "Russian Trip"))
                TripData.tripModels.append(TripModel(title: "Vocation on Hawaii"))
            }
        }
        
        DispatchQueue.main.async {
            complition()
        }
    }
    
    static func updateTrip(tripModel: TripModel) {
        
    }
    
    static func deleteTrip(tripModel: TripModel) {
        
    }
}
