//
//  RequestManager.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Alamofire

class RequestManager {
    typealias SuccessClosure = ((ResponseSucces) -> Void)
    typealias ErrorClosure = ((ResponseError) -> Void)
    typealias ObjectClosure<T: Codable> = ((ResponseObject<T>) -> Void)
    typealias ArrayClosure<T: Codable> = ((ResponseArray<T>) -> Void)
    typealias ArrayPaginationClosure<T: Codable> = ((ResponsePaginationArray<T>) -> Void)
    
    static let errorCodeConnection = "error.connection"
    static let errorCodeLocal = "error.local"
    static let errorCodeUnknown = "error.unknown"
    
    static var apiUrl: String {
        get {
            #if DEVELOPMENT
            return "https://birebirdiyet.mobillium.com/api/"
            #else
            return "https://birebirdiyet.mobillium.com/api/"
            #endif
        }
    }
    
    private static func createRequest(_ request: RequestDelegate) -> DataRequest {
        
        print("\n\nRequest Path: \(request.path)")
        print("\nRequest Method: \(request.method)")
        print("Requests Parameters:")
        print(request.parameters ?? "There is no parameters")
        
        let request = Alamofire.request(apiUrl+request.path, method: request.method, parameters: request.parameters, encoding: URLEncoding.default, headers: generateHeader())
        
        request.validate()
        request.responseData { (response) in
            if let value = response.result.value {
                if let json = String(data: value, encoding: .utf8) {
                    print("Response JSON: \n\(json)")
                }
            }
        }
        return request
    }
    
    static func request(_ request: RequestDelegate, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        let request = createRequest(request)
        request.responseData { (response) in
            switch response.result {
            case .success:
                print("sfs")
//                success(ResponseSucces.decode(response.result.value!)!)
            case .failure:
                print("sfs")
//                handleFailure(response: response, failure: failure)
            }
        }
    }
    
    
    
    private static func generateHeader() -> [String: String]? {
        var parameters: [String: String] = [:]
        // TODO: - After writing Auth class uncomment this line
//        if let auth = Auth.save() {
//            parameters["Authorization"] = "Bearer \(auth.token!)"
//        }
        print("Header:")
        print(parameters)
        return parameters
    }
}
