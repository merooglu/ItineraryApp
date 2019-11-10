//
//  ResponseError.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class ResponseError: Codable {
    
    var code: String!
    var message: String!
    
    init(code: String, message: String) {
        self.code = code
        self.message = message
    }
}
