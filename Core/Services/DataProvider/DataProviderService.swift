//
//  DataProviderService.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 27.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import Foundation
import UIKit

enum Domain_DataProvider {}

// MARK: Service
class DataProviderService: BaseService {
    var dataProvider: Domain_DataProvider.Lipstick.Provider? = Domain_DataProvider.Lipstick.Provider()
    override var health: Bool {
        return true
    }
}

// MARK: Configurations
extension DataProviderService {
    func configured(network: NetworkService, media: MediaDeliveryService) -> Self {
        // we must set here
        return self
    }
}
