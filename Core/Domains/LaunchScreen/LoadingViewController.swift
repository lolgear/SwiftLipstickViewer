//
//  LoadingViewController.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 26.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

enum LaunchScreen {}

// MARK: LaunchScreenViewController
extension LaunchScreen {
    fileprivate class LaunchScreenViewController: UIViewController {
        var lipstickView: UIView?
        func findLipstickView(in controller: UIViewController?) -> UIImageView? {
            return controller?.viewIfLoaded?.subviews.filter {$0 is UIImageView}.first as? UIImageView
        }
        func createLaunchScreen() -> UIViewController? {
            let viewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
            return viewController
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            if let controller = self.createLaunchScreen() {
                self.expand(child: controller)
                self.lipstickView = self.findLipstickView(in: controller)
            }
        }
    }
}

// MARK: LoadingViewController
// Also has model
// Which should control when to finish animation.
extension LaunchScreen {
    class LoadingViewController: UIViewController {
        fileprivate var launchScreen: LaunchScreenViewController?
        var model: Model?
    }
}

// MARK: View Lifecycle
extension LaunchScreen.LoadingViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = LaunchScreen.LaunchScreenViewController()
        self.expand(child: controller)
        self.launchScreen = controller
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.applyAnimations()
    }
}

// MARK: Animations
extension LaunchScreen.LoadingViewController {
    class AnimationBuilder {
        enum ClockDirection {
            case clockwise
            case counterclockwise
            func direction() -> Int {
                switch self {
                case .clockwise: return 1
                case .counterclockwise: return -1
                }
            }
            func next() -> ClockDirection {
                switch self {
                case .clockwise: return .counterclockwise
                case .counterclockwise: return .clockwise
                }
            }
        }
        
        // We should separate animations.
        // Group[Basic[Rotation], Spring[Small Occilation]] - One clockwise animation.
        static func animation(for direction: ClockDirection) -> CASpringAnimation {
            let animation = CASpringAnimation(keyPath: "transform.rotation.z")
            animation.fromValue = 0
            animation.toValue = Double(direction.direction()) * Double.pi * 2
            
//            animation.initialVelocity = 15
//            animation.stiffness = 40
//            animation.damping = 5
//            animation.mass = 5.0
            animation.duration = 10
//            animation.isCumulative = true
            animation.repeatCount = 1
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            return animation
        }
        
        static func animation() -> CAAnimation {
            let animation = CAAnimationGroup()
            let animations = [self.animation(for: .clockwise), self.animation(for: .counterclockwise)]
            
            let correctAnimations = Array(animations.prefix(upTo: 1)) + zip(animations.dropFirst(), animations).flatMap { (pair) in
                let (last, first) = pair
                last.beginTime = first.beginTime + first.settlingDuration
                return last
            }
            
            let wholeTime = correctAnimations.flatMap{$0.settlingDuration}.reduce(0, +)
            animation.animations = correctAnimations
            animation.duration = wholeTime
            return animation
        }
        
        static func applyAnimation(on layer: CALayer?, shouldComplete: @escaping () -> Bool, onCompletion: @escaping () -> ()) {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                guard shouldComplete() else {
                    self.applyAnimation(on: layer, shouldComplete: shouldComplete, onCompletion: onCompletion)
                    return
                }
                onCompletion()
            })
            let animation = self.animation()
            layer?.add(animation, forKey: "abc")
            CATransaction.commit()
        }
    }
    
    func applyAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            AnimationBuilder.applyAnimation(on: self.launchScreen?.lipstickView?.layer, shouldComplete: { () -> Bool in
                self.model?.next()
                return self.model?.completed() == true
            }, onCompletion: {
                // call that we should dismiss.
//                self.dismiss(animated: true, completion: nil)
                self.model?.onCompletion?()
            })
        }
    }
}

// MARK: Model
extension LaunchScreen.LoadingViewController {
    class Model {
        // we need to detect that our data is loaded.
        // maybe we should add box?
        // or just check that animation is ready?
        // not sure what should we do here...
        fileprivate var didLoadData = false
        var onCompletion: (() -> ())?
        var onNext: ((Model) -> ())?
        func next() {
            self.onNext?(self)
        }
        func completed() -> Bool {
            return self.didLoadData == true
        }
        init() {}
    }
}

// MARK: Configuration
extension LaunchScreen.LoadingViewController.Model {
    func configured(onCompletion: @escaping () -> ()) -> Self {
        self.onCompletion = onCompletion
        return self
    }
    func configured(onNext: @escaping (LaunchScreen.LoadingViewController.Model) -> ()) -> Self {
        self.onNext = onNext
        return self
    }
}

// MARK: Finish
extension LaunchScreen.LoadingViewController.Model {
    func finish(finish: Bool = true) {
        self.didLoadData = finish
    }
}

extension LaunchScreen.LoadingViewController: HasModelProtocol {
    func updateForNewModel() {
        // do nothing
    }
}

// MARK: Presentation.
// Of course, you should add presentation controller
extension LaunchScreen.LoadingViewController: UIViewControllerTransitioningDelegate  {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AppearanceService.Transitions.Alpha.create(isForward: false)
    }
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AppearanceService.Transitions.Alpha.create(isForward: true).configured(initialValue: 1.0)
    }
}

