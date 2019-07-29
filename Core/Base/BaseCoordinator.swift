//
//  BaseCoordinator.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
protocol Coordinator : class {
    var childCoordinators : [Coordinator] { get set }
    func start()
}

// MARK: Storage
extension Coordinator {
    
    func store(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// MARK: Base
class BaseCoordinator : Coordinator {
    var childCoordinators : [Coordinator] = []
    var isCompleted: (() -> ())?
    
    func start() {
        fatalError("Children should implement `start`.")
    }
}
