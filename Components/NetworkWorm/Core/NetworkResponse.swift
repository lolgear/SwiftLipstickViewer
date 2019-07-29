//
//  NetworkResponse.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 23.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import Foundation

// Maybe declare as protocol?
public protocol ResponseProtocol {
    var data: Data? {get set}
    var url: URL? {get set}
}

public class DataResponse {
    
}

public protocol ResponseCreation {
    init?(new: [String : AnyObject])
}

public class Response {
    public typealias PayloadType = [String : AnyObject]
    var dictionary: PayloadType = [:]
    public init?(dictionary: PayloadType) {
        self.dictionary = dictionary
    }
    public required init?(new: PayloadType) {
        self.dictionary = new
    }
}

extension Response: ResponseCreation {
//    public class func create(new: [String : AnyObject]) -> Self? {
//        return self.init(new: new)
//    }
}

extension Response: CustomDebugStringConvertible {
    public var debugDescription: String {
        return self.dictionary.debugDescription
    }
}

public enum ResponseResult<R: SuccessResponse>  {
    case result(R)
    case error(ErrorResponse)
}

public class SuccessResponse: Response {
    public override init?(dictionary: PayloadType) {
        super.init(dictionary: dictionary)
//        guard let response = dictionary["Response"] as? String, response == "True" else {
//            return nil
//        }
        // if no error.
    }
    
    public required init?(new: PayloadType) {
        super.init(new: new)
    }
    
    public var dictionaryResult: PayloadType {
        return self.dictionary
    }
}

public class ErrorResponse: Response {
    var code: Int = 0
    var info = ""
    var error: Error?
    public var descriptiveError : Error? {
        return error ?? NSError(domain: ErrorFactory.Errors.domain, code: code, userInfo: [NSLocalizedDescriptionKey : info])
    }
    
    public init(error: Error) {
        super.init(dictionary: [:])!
        self.error = error
    }
    
    public override init?(dictionary: PayloadType) {
        super.init(dictionary: dictionary)
        
        guard let response = dictionary["Response"] as? String, response == "False" else {
            return nil
        }
        
        guard let error = dictionary["Error"] as? String else {
            return nil
        }
        
        // now error is string.
        self.info = error
        self.code = -99
    }
    
    public required init?(new: PayloadType) {
        //fatalError("init(new:) has not been implemented")
        super.init(new: new)
    }
}
