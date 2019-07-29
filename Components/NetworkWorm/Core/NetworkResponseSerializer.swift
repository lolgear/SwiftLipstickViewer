//
//  NetworkResponseSerializer.swift
//  NetworkWorm
//
//  Created by Dmitry Lobanov on 03.09.2018.
//  Copyright © 2018 Dmitry Lobanov. All rights reserved.
//

import Foundation

// for now we only need dictionary type.
public protocol ResponseSerializerProtocol {
//    associatedtype Output
    typealias Output = [String : AnyObject]
    func deserialize(data: Data?) throws -> [String : AnyObject]?
}

class NWResponseSerializer {
    class JSONEncoded: ResponseSerializerProtocol {
        typealias Output = [String : AnyObject]
        func deserialize(data: Data?) throws -> Output? {
            guard let theData = data else {
                return nil
            }
            return (try? JSONSerialization.jsonObject(with: theData, options: [])) as? Output
        }
    }
}

public enum ResponseSerialization {
    case JSON

    var serializer: ResponseSerializerProtocol {
        switch self {
        case .JSON: return NWResponseSerializer.JSONEncoded()
        }
    }
}
