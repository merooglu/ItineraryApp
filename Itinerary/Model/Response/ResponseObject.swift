//
//  ResponseObject.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class ResponseObject<T: Codable>: BaseResponse {
    
    var data: T!
    
    enum codingKeys: String, CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)
        data = try container.decode(T.self, forKey: .data)
        try super.init(from: decoder)
    }
}
