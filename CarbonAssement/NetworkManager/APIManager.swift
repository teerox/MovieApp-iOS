//
//  NetworkRequest.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import Foundation
import SwiftyJSON

public enum CustomError {
    case internetError(String)
    case serverMessage(String)
}


class APIManager {
    
    typealias parameters = [String:Any]
    
    enum ApiResult {
        case success(Data)
        case failure(RequestError)
    }
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    enum RequestError: Error {
        case unknownError
        case connectionError
        case authorizationError(JSON)
        case invalidRequest
        case notFound
        case invalidResponse
        case serverError(JSON)
        case serverUnavailable
    }
    
    // session to be used to make the API call
    let session: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.session = urlSession
    }
    
    
    //Network Request
    func requestData(url:String,method:HTTPMethod,parameters:parameters?,completion: @escaping (ApiResult)->Void) {

        let urlString = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
        var urlRequest = URLRequest(url: URL(string:urlString!)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
       
        urlRequest.httpMethod = method.rawValue
        
        if let parameters = parameters {
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
            urlRequest.httpBody = jsonData
        }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(ApiResult.failure(.connectionError))
                
            }else if let data = data ,let responseCode = response as? HTTPURLResponse {
                do {
                    let responseJson = try JSON(data: data)
                   // print("responseCode : \(responseCode.statusCode)")
                   //print("responseJSON : \(responseJson)")
                    
                    switch responseCode.statusCode {
                    case 200...201:
                        completion(ApiResult.success(data))
                    case 400...499:
                        completion(ApiResult.failure(.authorizationError(responseJson)))
                    case 500...599:
                        completion(ApiResult.failure(.serverError(responseJson)))
                    default:
                        completion(ApiResult.failure(.unknownError))
                        break
                    }
                }
                catch let parseJSONError {
                    completion(ApiResult.failure(.unknownError))
                    print("error on parsing request to JSON : \(parseJSONError)")
                }
            }
        }.resume()
    }
    
  
}
