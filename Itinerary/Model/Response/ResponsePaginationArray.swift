//
//  ResponsePaginationArray.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

class ResponsePaginationArray <T: Codable>: BaseResponse {
    
    var data: [T]!
    var pagination: Pagination!
    
    enum CodingKeys: String, CodingKey {
        case data
        case pagination
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([T].self, forKey: .data)
        pagination = try container.decode(Pagination.self, forKey: .pagination)
        try super.init(from: decoder)
    }
}
