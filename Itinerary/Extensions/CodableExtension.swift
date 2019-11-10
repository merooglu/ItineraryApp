//
//  CodableExtension.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        encoder.dataEncodingStrategy = .deferredToData
        return try? encoder.encode(self)
    }
}


extension Decodable {
    static func decode(_ data: Data) -> Self? {
        let decoder = JSONDecoder()
        decoder.dataDecodingStrategy = .deferredToData
        return try? decoder.decode(self, from: data)
    }
}
