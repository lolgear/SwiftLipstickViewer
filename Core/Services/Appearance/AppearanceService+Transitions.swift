//
//  AppearanceService+Transitions.swift
//  SellzForBenetton
//
//  Created by Dmitry Lobanov on 18.09.2018.
//  Copyright © 2018 Zeppelin Group. All rights reserved.
//

import Foundation
import UIKit

extension AppearanceService {
    class Transitions {
        enum Direction {
            case forward
            case backward
        }
        class Base: NSObject {
            var duration = 0.3
        }
        
        class Directional: Base {
            var direction = Direction.forward
            var presenting: Bool { return Direction.forward == self.direction }
            required override init() {}
            required init(direction: Direction) {
                self.direction = direction
            }
//            func create(direction: Direction) -> Directional {
//                let item = type(of: self).init()
//                item.direction = direction
//                return item
//            }
            class func create(isForward: Bool) -> Self {
                return self.init(direction: isForward ? .forward : .backward)
            }
        }
        
        class Navigation: Directional {}
        class TabBar: Directional {}
        class Modal: Directional {}
        class Modal2: Directional {}
        class Colored: Base {
            var tintColor: UIColor?
            func configured(tintColor: UIColor?) -> Self {
                self.tintColor = tintColor
                return self
            }
        }
        class Alpha: Directional {
            var initialValue: Double?
            var finalValue: Double?
            var initialAlpha: Double {
                get {
                    if let value = self.initialValue { return value }
                    return self.direction == .backward ? 1.0 : 0.0
                }
            }
            var finalAlpha: Double {
                get {
                    if let value = self.finalValue { return value }
                    return self.direction == .backward ? 0.0 : 1.0
                }
            }
            func configured(initialValue: Double?) -> Self {
                self.initialValue = initialValue
                return self
            }
            func configured(finalValue: Double?) -> Self {
                self.finalValue = finalValue
                return self
            }
        }
    }
}

extension AppearanceService.Transitions.Navigation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func prepareAnimations(transitionContext: UIViewControllerContextTransitioning, fromView: UIView, toView: UIView) {
        let right = CGAffineTransform(translationX: transitionContext.containerView.bounds.size.width, y: 0)
        toView.transform = right
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let initialFrame = transitionContext.initialFrame(for: fromViewController)
        
        fromView.frame = initialFrame
        toView.frame = initialFrame
        
        // set up from 2D transforms that we'll use in the animation
        let offScreenOffsetX = (self.presenting ? 1 : -1) * container.frame.width
        let offScreenTransform = CGAffineTransform(translationX: offScreenOffsetX, y: 0)
        _ = CGAffineTransform(translationX: container.frame.width, y: 0)
        _ = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        // start the toView to the right of the screen
        fromView.transform = CGAffineTransform.identity
        toView.transform = offScreenTransform
        
        // add the both views to our view controller
        container.addSubview(fromView)
        container.addSubview(toView)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //            fromView.transform = offScreenLeft
            toView.transform = CGAffineTransform.identity
        }) { (result) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && result)
        }
    }

}

extension AppearanceService.Transitions.TabBar: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        
        toView.alpha = 0.0
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }) { (result) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && result)
        }
    }
}

extension AppearanceService.Transitions.Modal: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromVC.view.frame = finalFrame
                fromVC.view.alpha = 0.0
        }, completion: { result in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && result)
        })
    }
}

extension AppearanceService.Transitions.Colored: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from), let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        
        toView.alpha = 0.0
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1.0
        }) { (result) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && result)
        }
    }
}

extension AppearanceService.Transitions.Modal2: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        let initialFrame = transitionContext.initialFrame(for: fromViewController)
        
        fromView.frame = initialFrame
        toView.frame = initialFrame
        
        let offScreenOffsetY = container.frame.height
        let offScreenTransform = CGAffineTransform(translationX: 0, y: offScreenOffsetY)
        
        let animatedView = self.presenting ? toView : fromView
        
        let intialTransform = self.presenting ? offScreenTransform : CGAffineTransform.identity
        let finalTransform = self.presenting ? CGAffineTransform.identity : offScreenTransform
        
        // add the both views to our view controller
        if self.presenting {
            container.addSubview(fromView)
            container.addSubview(toView)
        }
        else {
            container.addSubview(toView)
            container.addSubview(fromView)
        }
        
        let initialAlpha: CGFloat = self.presenting ? 0.0 : 1.0
        let finalAlpha: CGFloat = self.presenting ? 1.0 : 0.0
        
        let finalTranslation = animatedView.transform.concatenating(finalTransform)
        animatedView.transform = animatedView.transform.concatenating(intialTransform)
        
        animatedView.alpha = initialAlpha
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            //            fromView.transform = offScreenLeft
            animatedView.alpha = finalAlpha
            animatedView.transform = finalTranslation
        }) { (result) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && result)
        }
    }
}

extension AppearanceService.Transitions.Alpha: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.viewController(forKey: .from)?.viewIfLoaded, let toView = transitionContext.viewController(forKey: .to)?.viewIfLoaded else {
            transitionContext.completeTransition(true)
            return
        }
        
        let dismissing = self.direction == .backward
        
        let animatedView = dismissing ? fromView : toView

        containerView.addSubview(animatedView)
        
        let initialAlpha = CGFloat(self.initialAlpha)
        let finalAlpha = CGFloat(self.finalAlpha)
        
        animatedView.alpha = initialAlpha
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            animatedView.alpha = finalAlpha
        }) { (result) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled && result)
        }
    }
}
