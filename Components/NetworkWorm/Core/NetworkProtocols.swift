//
//  NetworkProtocols.swift
//  NetworkWorm
//
//  Created by Dmitry Lobanov on 04.09.2018.
//  Copyright © 2018 Dmitry Lobanov. All rights reserved.
//

import Foundation

public enum Headers: String {
    case Authorization, Timestamp, ContentType = "Content-Type"
}

public protocol HeadersProvider: class {
    func updatedByHeaders(request: URLRequest?, by command: Command) -> URLRequest?
}
