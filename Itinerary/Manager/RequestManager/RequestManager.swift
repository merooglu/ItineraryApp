//
//  RequestManager.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 10.11.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Alamofire

class RequestManager {
    typealias SuccessClosure = ((ResponseSuccess) -> Void)
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
                success(ResponseSuccess.decode(response.result.value!)!)
            case .failure:
                handleFailure(response: response, failure: failure)
            }
        }
    }
    
    static func request<T: Codable>(_ request: RequestDelegate, success: @escaping ObjectClosure<T>, failure: @escaping ErrorClosure) {
        let request = createRequest(request)
        request.responseData { (response) in
            switch response.result {
            case .success:
                success(ResponseObject<T>.decode(response.result.value!)!)
            case .failure:
                handleFailure(response: response, failure: failure)
            }
        }
    }
    
    static func request<T: Codable>(_ request: RequestDelegate, success: @escaping ArrayClosure<T>, failure: @escaping ErrorClosure) {
        let request = createRequest(request)
        request.responseData { (response) in
            switch response.result {
            case .success:
                success(ResponseArray<T>.decode(response.result.value!)!)
            case .failure:
                handleFailure(response: response, failure: failure)
            }
        }
    }
    
    static func request<T: Codable>(_ request: RequestDelegate, success: @escaping ArrayPaginationClosure<T>, failure: @escaping ErrorClosure) {
        let request = createRequest(request)
        request.responseData { (response) in
            switch response.result {
            case .success:
                success(ResponsePaginationArray<T>.decode(response.result.value!)!)
            case .failure:
                handleFailure(response: response, failure: failure)
            }
        }
    }
    
    // MARK: - Image Data
    static func upload<T: Codable>(_ request: RequestDelegate, success: @escaping ObjectClosure<T>, failure: @escaping ErrorClosure) {
        var currentMethod = request.method
        
        switch request.method {
        case .put:
            currentMethod = .post
        default:
            break
        }
        
        Alamofire.upload(multipartFormData: { (data) in
            if request.method == .put {
                data.append("put".data(using: String.Encoding.utf8)!, withName: "_method")
            }
            if let values = request.parameters {
                for (key, value) in values {
                    if let value = value as? String {
                        data.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    } else if let value = value as? Data {
                        data.append(value, withName: key, fileName: "\(key).jpeg", mimeType: "image/jpeg")
                    } else {
                        assertionFailure("Enable for String and Data types")
                    }
                }
            }
        }, usingThreshold: UInt64(), to: apiUrl+request.path, method: currentMethod, headers: generateHeader()) { (result) in
            switch result {
            case .success(let request, _, _):
                request.validate()
                request.responseData { (response) in
                    switch response.result {
                    case .success:
                        success(ResponseObject<T>.decode(response.result.value!)!)
                    case .failure:
                        handleFailure(response: response, failure: failure)
                    }
                }
            case .failure(let error):
                handleError(statusCode: nil, localError: error, serviceError: nil, failure: failure)
            }
        }
    }
    
    // MARK: Image data only success closure
    static func uploadNonData(_ request: RequestDelegate, success: @escaping SuccessClosure, failure: @escaping ErrorClosure) {
        var currentMethod = request.method
        
        switch request.method {
        case .put:
            currentMethod = .post
        default:
            break
        }
        
        Alamofire.upload(multipartFormData: { (data) in
            if request.method == .put {
                data.append("put".data(using: String.Encoding.utf8)!, withName: "_method")
            }
            if let values = request.parameters {
                for (key, value) in values {
                    if let value = value as? String {
                        data.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    else if let value = value as? Data {
                        data.append(value, withName: key, fileName: "\(key).jpg", mimeType: "image/jpeg")
                    }
                    else {
                        assertionFailure("Enable for String and Data types.")
                    }
                }
            }
        }, usingThreshold: UInt64(), to: apiUrl+request.path, method: currentMethod, headers: generateHeader()) { (result) in
            switch result {
            case .success(let request, _, _):
                request.responseData { (response) in
                    switch response.result {
                    case .success:
                        success(ResponseSuccess.decode(response.result.value!)!)
                    case .failure:
                        handleFailure(response: response, failure: failure)
                    }
                }
            case .failure(let error):
                handleError(statusCode: nil, localError: error, serviceError: nil, failure: failure)
            }
        }
    }
    
    // MARK: - Handle failure
    private static func handleFailure(response: DataResponse<Data>, failure: @escaping ErrorClosure) {
        if let statusCode = response.response?.statusCode, statusCode == 401 {
            // TODO: - after create auth class uncomment this line
//            Auth.delete()
//            AppDelegate.shared.gotoAuth()
            return
        }
        if let data = response.data, let serviceError = ResponseError.decode(data) {
            if let json = String(data: data, encoding: .utf8) {
                print("Response JSON: \n\(json)")
            }
            handleError(statusCode: response.response?.statusCode, localError: nil, serviceError: serviceError, failure: failure)
        } else if let error = response.result.error {
            handleError(statusCode: nil, localError: error, serviceError: nil, failure: failure)
        } else {
            handleError(statusCode: nil, localError: nil, serviceError: nil, failure: failure)
        }
    }
    
    private static func handleError(statusCode: Int?, localError: Error?, serviceError: ResponseError?, failure: @escaping ErrorClosure) {
        if let error = serviceError {
            failure(error)
        } else if let error = localError as? URLError, error.code == .notConnectedToInternet {
            failure(ResponseError(code: errorCodeConnection, message: error.localizedDescription))
        } else if let error = localError {
            failure(ResponseError(code: errorCodeLocal, message: error.localizedDescription))
        } else {
            failure(ResponseError(code: errorCodeUnknown, message: "Unknown Error"))
        }
    }
    
    
    private static func generateHeader() -> [String: String]? {
        let parameters: [String: String] = [:]
        // TODO: - After writing Auth class uncomment this line
//        if let auth = Auth.save() {
//            parameters["Authorization"] = "Bearer \(auth.token!)"
//        }
        print("Header:")
        print(parameters)
        return parameters
    }
}
