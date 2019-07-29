//
//  RootViewController.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

class RootViewController: UIViewController {
    var model: Model?
}

// MARK: Connections
extension RootViewController {
    func connectModel() {
        guard let controller = self.model?.child else {
            return
        }
        
        self.expandInRoot(child: controller)
    }
}
// MARK: View Lifecycle
extension RootViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectModel()
        self.view.backgroundColor = .white
    }
}

// MARK: Model
extension RootViewController {
    class Model {
        // we have dataProvider service here?
        var child: UIViewController?
    }
}

// MARK: Configurations
extension RootViewController.Model {
    func configured(_ child: UIViewController) -> Self {
        self.child = child
        return self
    }
}

// MARK: HasModelProtocol
extension RootViewController: HasModelProtocol {
    func updateForNewModel() {
        
    }
}
