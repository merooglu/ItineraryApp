//
//  DateExtension.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

extension Date {
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: Date())!
    }
    
    func mediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
}
