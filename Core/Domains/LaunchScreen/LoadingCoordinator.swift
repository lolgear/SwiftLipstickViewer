//
//  LoadingCoordinator.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

class LoadingCoordinator: BaseCoordinator {
    var viewController: RootViewController?
    var dataProvider: DataProviderService?
    var model: LaunchScreen.LoadingViewController.Model?
    override func start() {
        self.showLoading { [weak self] in
            self?.dataProvider?.dataProvider?.getProducts(options: [.shouldWaitForImages], { [weak self] (result) in
                DispatchQueue.main.async {
                    self?.model?.finish()
                }
            })
        }
    }
    
    func showLoading(_ onCompletion: @escaping () -> ()) {
        let controller = LaunchScreen.LoadingViewController()
        let model = LaunchScreen.LoadingViewController.Model().configured {
            [weak controller, weak self] in
            // dismiss controller
            self?.isCompleted?()
            controller?.dismiss(animated: true, completion: nil)
            }
        
        self.model = model
        
        // custom animations will fix it.
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = controller
        self.viewController?.present(controller.configured(model: model), animated: true, completion: onCompletion)
    }
    
    init(viewController: RootViewController?) {
        self.viewController = viewController
    }
}

// MARK: Configurations
extension LoadingCoordinator {
    func configured(dataProvider: DataProviderService?) -> Self {
        self.dataProvider = dataProvider
        return self
    }
}
