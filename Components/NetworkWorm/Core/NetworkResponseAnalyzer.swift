//
//  NetworkResponseAnalyzer.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 24.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import Foundation

class ResponseAnalyzer<R> where R: SuccessResponse {
    init() {}
}

//MARK: analyzing
extension ResponseAnalyzer {
    typealias Input = ResponseSerializerProtocol.Output
    func analyzedResponseResult(response: Input, context: [String : AnyObject]?) -> ResponseResult<R> {
        guard let result = R(new: response) else {
            return .error(ErrorResponse(dictionary: response) ?? ErrorResponse(error: ErrorFactory.createError(errorType: .unknown)!))
        }
        return .result(result)
    }
    func analyze(response: Data?, context:[String : AnyObject]?, error: Error?, responseSerializer: ResponseSerializerProtocol) -> ResponseResult<R> {
        guard error == nil else {
            return .error(ErrorResponse(error: error!))
        }

        guard let theResponse = response else {
            return .error(ErrorResponse(error: ErrorFactory.createError(errorType: .responseIsEmpty)!))
        }

        guard let object = try? responseSerializer.deserialize(data: theResponse), let value = object else {
            return .error(ErrorResponse(error: ErrorFactory.createError(errorType: .couldNotParse(theResponse as AnyObject?))!))
        }
        return self.analyzedResponseResult(response: value, context: context)
    }
}
