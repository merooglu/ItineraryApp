//
//  RequestDelegate.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 20.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Alamofire

protocol RequestDelegate {
    
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters: Parameters? {get set}
    
    func didError( _ error: ResponseError)
    
}

extension RequestDelegate {
    
    func didError(_ error: ResponseError) {}
    
}
