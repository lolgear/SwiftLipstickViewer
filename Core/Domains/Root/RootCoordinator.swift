//
//  RootCoordinator.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

class RootCoordinator: BaseCoordinator {
    var window: UIWindow?
    
    var dataProvider: DataProviderService?
    var media: MediaDeliveryService?
    
    override func start() {
        let model = RootViewController.Model()
        
        let controller = RootViewController().configured(model: model)
        
        let loadingCoordinator = LoadingCoordinator(viewController: controller).configured(dataProvider: dataProvider)
        self.store(coordinator: loadingCoordinator)
        
        loadingCoordinator.isCompleted = { [weak self] in
            self?.afterLoad()
        }
    
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
        loadingCoordinator.start()
    }
    
    func afterLoad() {
        let controller = Domain_Main.MainViewController()
        let coordinator = MainCoordinator(viewController: controller).configured(dataProvider: dataProvider).configured(media: media)
        let root = (self.window?.rootViewController as? RootViewController)
        _ = root?.model?.configured(controller)
        root?.connectModel()
        self.free(coordinator: self.childCoordinators[0])
        self.store(coordinator: coordinator)
        coordinator.start()
    }
    
    override init() {}
    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: Configurations
extension RootCoordinator {
    func configured(dataProvider: DataProviderService?) -> Self {
        self.dataProvider = dataProvider
        return self
    }
    func configured(media: MediaDeliveryService?) -> Self {
        self.media = media
        return self
    }
}
