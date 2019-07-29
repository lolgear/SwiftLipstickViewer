//
//  Result.swift
//  getZ
//
//  Created by Dmitry Lobanov on 10.09.2018.
//  Copyright © 2018 Zeppelin Group. All rights reserved.
//

import Foundation
enum Result<R> {
    case result(R)
    case error(Error)
    
    public func map<U>(_ transform: (R) throws -> U) rethrows -> Result<U> {
        switch self {
        case .result(let value):
            return .result(try transform(value))
        case .error(let error):
            return .error(error)
        }
    }
    
    public func flatMap<U>(_ transform: (R) throws -> Result<U>) rethrows -> Result<U> {
        switch self {
        case .result(let value):
            return try transform(value)
        case .error(let error):
            return .error(error)
        }
    }
    
    public func flatMapError(_ transform: (Error) throws -> Result<R>) rethrows -> Result<R> {
        switch self {
        case .error(let error):
            return try transform(error)
        default: return self
        }
    }
}
