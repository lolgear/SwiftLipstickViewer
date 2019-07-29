//
//  LipsticksListViewController.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 27.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

// NOTE: Maybe it is a bottom slider?
// Or use word LipstickSamplersListViewController?
// Do we need word Lipstick?
// Hm...
// This should be PreviewsListViewController.
class LipsticksListViewController: BaseViewController {
    enum Direction {
        case none, left, right
        init(_ pair: (Int, Int)) {
            let (lhs, rhs) = pair
            if lhs > rhs {
                self = .left
            }
            else if lhs < rhs {
                self = .right
            }
            else {
                self = .none
            }
        }
        func opposite() -> Direction {
            switch self {
            case .left: return .right
            case .right: return .left
            case .none: return .none
            }
        }
        func direction() -> Int {
            switch self {
            case .left: return -1
            case .right: return 1
            case .none: return 0
            }
        }
    }
    var model: Model?
}

// MARK: View Lifecycle
extension LipsticksListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // do something.
        // first of all, we should have a model here.
//        self.view.backgroundColor = .blue
    }
}

// MARK: Actions
extension LipsticksListViewController {
    func animate(direction: Direction, controller: UIViewController) {
        // choose direction and animate controller
        
        // none means without animation.
        
        // TODO: Add animations.
        if let old = self.children.first {
            let middleFrame = self.view.frame
//            middleFrame.origin.x = middleFrame.size.width
            
            let appearingOffset = CGFloat(direction.direction()) * middleFrame.size.width
            let dismissingOffset = CGFloat(direction.opposite().direction()) * middleFrame.size.width

            
//            let appearingInitialFrame = CGRect(origin: .init(x: appearingOffset, y: middleFrame.origin.y), size: middleFrame.size)
//            let dismissingFinalFrame = CGRect(origin: .init(x: dismissingOffset, y: middleFrame.origin.y), size: middleFrame.size)
//
//            let appearingFinalFrame = old.view.frame
//
            old.willMove(toParent: nil)
            self.addChild(controller)
            
            self.view.addSubview(controller.view)


//            let appearingTransform = CGAffineTransform.identity.translatedBy(x: appearingOffset, y: 0)
//            let dismissingTransform = CGAffineTransform.identity.translatedBy(x: dismissingOffset, y: 0)
            
            let appearingConstraints = NSLayoutConstraint.body(item: controller.view, toItem: self.view)
            NSLayoutConstraint.activate(appearingConstraints)

            let appearingConstraint = NSLayoutConstraint.constraint(for: controller.view, attribute: .leading, in: self.view)
//            let appearingTrailing = NSLayoutConstraint.constraint(for: controller.view, attribute: .trailing, in: self.view)
            let dismissingConstraint = NSLayoutConstraint.constraint(for: old.view, attribute: .leading, in: self.view)

            appearingConstraint?.constant = appearingOffset
//            appearingTrailing?.constant = appearingOffset
//            controller.view.transform = appearingTransform
            self.view.layoutIfNeeded()
            self.view.setNeedsLayout()
            
            
            appearingConstraint?.constant = 0
//            appearingTrailing?.constant = 0
            dismissingConstraint?.constant = dismissingOffset
            self.transition(from: old, to: controller, duration: 0.3, options: [], animations: {
//                controller.view.frame = appearingFinalFrame
//                old.view.frame = dismissingFinalFrame
//                appearingConstraint?.constant = 0
//                appearingTrailing?.constant = 0
//                dismissingConstraint?.constant = dismissingOffset
//                old.view.transform = dismissingTransform
//                controller.view.transform = CGAffineTransform.identity
                self.view.layoutIfNeeded()
            }) { (finished) in
                old.view.removeFromSuperview()
                old.removeFromParent()
                controller.didMove(toParent: self)
            }
        }
        else {
            self.childBody(child: controller)
        }
    }
}

// MARK: Model
extension LipsticksListViewController: HasModelProtocol {
    // this model also a model of list.
    // so, it should have all related stuff.
    class Model {
        // do we need index here?
        var didSelect: ((Direction, Int) -> ())?
        var controller: ((Int) -> UIViewController?)?
        init() {}
    }
    func updateForNewModel() {
        self.model?.didSelect = { [weak self] (direction, index) in
            let controller = self?.model?.controller?(index)
            guard let theController = controller else { return }
            self?.animate(direction: direction, controller: theController)
        }
    }
}

// MARK: Container
extension LipsticksListViewController {

}
