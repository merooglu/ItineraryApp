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
        // Replace with real data store code
        DispatchQueue.global(qos: .userInteractive).async {
            if TripData.tripModels.count == 0 {
                TripData.tripModels = MockData.createMockTripModelData()
            }
            DispatchQueue.main.async {
                complition()
            }
        }
    }
    
    static func readTrip(by id: UUID, completion: @escaping (TripModel?) -> ()) {
        // Replace with real data store code
        DispatchQueue.global(qos: .userInitiated).async {
            let trip = TripData.tripModels.first(where: {$0.id == id})
            
            DispatchQueue.main.async {
                completion(trip)
            }
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
