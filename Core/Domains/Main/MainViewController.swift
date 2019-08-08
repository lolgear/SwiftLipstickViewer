//
//  MainViewController.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 26.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

// MARK: Main purpose is to combine ListLipstickViewController and Bottom switcher
// Maybe we may think of two view controllers - one for bottom and one for top.
// Add AppCoordinator to understand which data do we have.

// And also check MovieSearch for a data protocol and paging.
extension Domain_Main {
    class MainViewController: BaseViewController {
        var model: Model?
    }
}

// MARK: View Lifecycle
extension Domain_Main.MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectModel()
        
//        self.view.backgroundColor = .red
    }
}

// MARK: Connections
extension Domain_Main.MainViewController {
    func connectModel() {
        guard self.model?.valid() == true else { return }
        if let bottom = self.model?.bottomController, let top = self.model?.topController {
            self.embed(child: bottom) { (view) -> [NSLayoutConstraint] in
                let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: view.superview, attribute: .leading, multiplier: 1.0, constant: 0.0)
                let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: view.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: view.superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
                let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: view.superview, attribute: .height, multiplier: 1.0 / 6, constant: 0.0)
                return [leading, trailing, bottom, height]
            }
            self.embed(child: top) { (view) -> [NSLayoutConstraint] in
                let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: view.superview, attribute: .leading, multiplier: 1.0, constant: 0.0)
                let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: view.superview, attribute: .trailing, multiplier: 1.0, constant: 0.0)
                let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: bottom.view, attribute: .top, multiplier: 1.0, constant: 0.0)
                let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: view.superview, attribute: .top, multiplier: 1.0, constant: 0.0)
                return [leading, trailing, bottom, top]
            }            
        }
    }
}

// MARK: Model
extension Domain_Main.MainViewController {
    class Model {
        // move to root view controller
//        var provider: Domain_DataProvider.Lipstick.Provider?
        var bottomController: UIViewController?
        var topController: UIViewController?
        func valid() -> Bool {
            return bottomController != nil && topController != nil
        }
    }
}

// MARK: HasModelProtocol
extension Domain_Main.MainViewController: HasModelProtocol {
    func updateForNewModel() {
        self.connectModel()
    }
}
