//
//  Pagination.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class Pagination: Codable {
    var total: Int!
    var per_page: Int!
    var current_page: Int!
    var last_page: Int
    var first_item: Int!
    var last_item: Int!
}
