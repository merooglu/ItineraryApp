//
//  TripFunctions.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class TripFunctions {
    // static keyword means you don't need the initiate the TripFunction class every time, when you call the functions in this class
    static func createTrip(tripModel: TripModel) {
        TripData.tripModels.append(tripModel)
    }
    
    static func readTrips(complition: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if TripData.tripModels.count == 0 {
                TripData.tripModels.append(TripModel(title: "Trip to Bali"))
                TripData.tripModels.append(TripModel(title: "Mexico"))
                TripData.tripModels.append(TripModel(title: "Russian Trip"))
            }
        }
        
        DispatchQueue.main.async {
            complition()
        }
    }
    
    static func updateTrip(at index: Int, title: String, image: UIImage? = nil) {
        TripData.tripModels[index].title = title
        TripData.tripModels[index].image = image
    }
    
    static func deleteTrip(index: Int) {
        TripData.tripModels.remove(at: index)
    }
}
