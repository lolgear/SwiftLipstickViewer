//
//  NetworkRequestSerializer.swift
//  NetworkWorm
//
//  Created by Lobanov Dmitry on 29.03.2018.
//  Copyright © 2018 Home. All rights reserved.
//

import Foundation

protocol RequestSerializerProtocol {
    func serialize(parameters: [String : AnyObject]?, urlRequest: URLRequest) throws -> URLRequest?
}

extension RequestSerializerProtocol {
    func serialize(command: Command, urlRequest: URLRequest) throws -> URLRequest? {
        return try self.serialize(parameters: command.queryParameters(), urlRequest: urlRequest)
    }
    
    func check(command: Command) throws {
        if let error = command.shouldStopError {
            throw error
        }
    }
}

class RequestSerializer {
    class JSONEncodedRequest: RequestSerializerProtocol {
        func serialize(parameters: [String : AnyObject]?, urlRequest: URLRequest) throws -> URLRequest? {
            guard urlRequest.url != nil else {
                return nil
            }
            
            guard let theParameters = parameters else {
                return nil
            }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: theParameters, options: []) else {
                return nil
            }
            
            if let debugData = try? JSONSerialization.data(withJSONObject: theParameters, options: .prettyPrinted) {
                let theData = debugData
                let theString = String(bytes: theData, encoding: .utf8)
                print("\(String(describing: theString))")
            }
            
            var urlRequest = urlRequest
            urlRequest.httpBody = jsonData
            return urlRequest
        }
    }
    
    class URLEncodedRequest: RequestSerializerProtocol {
        func parametersToString(parameters: [String : AnyObject]) -> String {
            return parameters.map { return "\($0.key)=\($0.value)" }.joined(separator: "&")
        }
        
        func serialize(parameters: [String : AnyObject]?, urlRequest: URLRequest) throws -> URLRequest? {
            guard let url = urlRequest.url, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return nil
            }
            
            if let theParameters = parameters {
                urlComponents.query = self.parametersToString(parameters: theParameters)
            }
            
            var urlRequest = urlRequest
            urlRequest.url = urlComponents.url
            return urlRequest
        }
    }
    
    class OnlyURLRequest: RequestSerializerProtocol {
        func serialize(parameters: [String : AnyObject]?, urlRequest: URLRequest) throws -> URLRequest? {
            return urlRequest
        }
    }
}

public enum RequestSerialization {
    case JSON, URLEncoded, OnlyURL
    
    var serializer: RequestSerializerProtocol {
        switch self {
        case .JSON: return RequestSerializer.JSONEncodedRequest()
        case .URLEncoded: return RequestSerializer.URLEncodedRequest()
        case .OnlyURL: return RequestSerializer.OnlyURLRequest()
        }
    }
}
