//
//  ViewControllersService.swift
//  SwiftExchanger
//
//  Created by Lobanov Dmitry on 15.10.2017.
//  Copyright © 2017 Lobanov Dmitry. All rights reserved.
//

import Foundation
import UIKit
class ViewControllersService: BaseService {
    var rootViewController: UIViewController?
}

//MARK: Controller preparation
extension ViewControllersService {
    func blessedController(controller: UIViewController? = nil) -> UIViewController? {
        guard let viewController = controller ?? self.rootViewController else {
            return nil
        }
//        let c = ErrorHanldingViewController(viewController: viewController)
        
        // also set delegate
        self.rootViewController = viewController
        return viewController
    }
}

//MARK: ServicesInfoProtocol
extension ViewControllersService {
    override var health: Bool {
        return rootViewController != nil
    }
}

//MARK: ServicesSetupProtocol
extension ViewControllersService {
    override func setup() {
        // setup all necessary items and after that we are ready for rootViewController
        UINavigationBar.appearance().isTranslucent = false
//        UIView.appearance().translatesAutoresizingMaskIntoConstraints = false
//        UITableView.appearance().translatesAutoresizingMaskIntoConstraints = false
    }
}

////MARK: NetworkReachabilityObservingProtocol
//extension ViewControllersService: NetworkReachabilityObservingProtocol {
//    func didChangeState(state: Bool) {
//        // should show error.
//        // configure message - Connecting or Connected.
////        self.showMessage(message: "Connecting")
//        
////        let message = state ? "Connected" : "Connecting"
////        let model = NotificationViewController.Model()
////        model.message = message
////        model.discardable = state
////        self.showPresentModel(model: model)
//    }
//}
