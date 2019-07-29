//
//  NetworkService.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 24.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import NetworkWorm
import Foundation

// MARK: Service
class NetworkService: BaseService {
    var client: APIClient?
    var routing: Routing = DummyRouting() {
        didSet {
            _ = self.routing.configured(by: self)
        }
    }
}

// MARK: ServicesInfoProtocol
extension NetworkService {
    override var health: Bool {
        return client?.reachabilityManager?.reachable ?? false
    }
}

// MARK: ServicesSetupProtocol
extension NetworkService {
    override func setup() {}
    override func tearDown() {}
}
