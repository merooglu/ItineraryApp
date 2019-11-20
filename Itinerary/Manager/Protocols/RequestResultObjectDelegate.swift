//
//  RequestResultObjectDelegate.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 20.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

protocol RequestResultObjectDelegate: RequestDelegate {
    
    associatedtype ResultObjectType: Codable
    
    func didSuccess(_ result: ResponseObject<ResultObjectType>)
    
}

extension RequestResultObjectDelegate {
    
    func request(success: @escaping RequestManager.ObjectClosure<ResultObjectType>, failure: @escaping RequestManager.ErrorClosure) {
        RequestManager.request(self, success: { (result: ResponseObject<ResultObjectType>) in
            self.didSuccess(result)
            success(result)
        }) { (error) in
            self.didError(error)
            failure(error)
        }
    }
    
    func didSuccess(_ result: ResponseObject<ResultObjectType>) {}
}
