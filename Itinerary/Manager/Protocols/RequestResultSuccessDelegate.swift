//
//  RequestResultSuccessDelegate.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 20.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Foundation

protocol RequestResultSuccessDelegate: RequestDelegate {
    
    func didSuccess(_ result: ResponseSuccess)
    
}

extension RequestResultSuccessDelegate {
    
    func request(success: @escaping RequestManager.SuccessClosure, failure: @escaping RequestManager.ErrorClosure) {
        RequestManager.request(self, success: { (result: ResponseSuccess) in
            self.didSuccess(result)
        }) { (error) in
            self.didError(error)
            failure(error)
        }
    }
    
    func didSuccess(_ result: ResponseSuccess) { }
    
}
