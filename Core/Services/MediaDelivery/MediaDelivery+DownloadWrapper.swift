//
//  MediaDelivery+DownloadWrapper.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import ImagineDragon

extension MediaDeliveryService {
    class DownloadWrapper {
        weak var service: NetworkService?
    }
}

//MARK: Configurations
extension MediaDeliveryService.DownloadWrapper {
    func configured(service: NetworkService?) -> Self {
        self.service = service
        return self
    }
}

//MARK: DownloadImageOperationService
extension MediaDeliveryService.DownloadWrapper: DownloadImageOperationService {
    func downloadAtUrl(url: URL?, onResponse: @escaping ImagineDragon.DownloadImageOperation.TaskCompletion) -> ImagineDragon.CancellationToken? {
        return self.service?.downloadResource(url: url, { (triplet) in
            switch triplet {
            case .success(let a, let b):
                onResponse(.success(a, b))
            case .error(let a, let b):
                onResponse(.error(a, b))
            }
        }) as? ImagineDragon.CancellationToken
    }
}
