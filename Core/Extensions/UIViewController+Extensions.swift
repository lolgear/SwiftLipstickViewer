//
//  UIViewController+Extensions.swift
//  getZ
//
//  Created by Dmitry Lobanov on 10.09.2018.
//  Copyright © 2018 Zeppelin Group. All rights reserved.
//

import Foundation
import UIKit
//import SnapKit

// MARK: Child
extension UIViewController {
    func expand(child: UIViewController) {
        let controller = child
        controller.willMove(toParent: self)
        self.addChild(controller)
        self.view.addSubview(controller.view)
        let view = controller.view
        let constraints = NSLayoutConstraint.bounds(item: view as Any, toItem: self.view)
        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: self)
    }
    
    func expandInRoot(child: UIViewController) {
        let controller = child
        controller.willMove(toParent: self)
        self.addChild(controller)
        self.view.addSubview(controller.view)
        let view = controller.view
        let constraints = NSLayoutConstraint.bounds(item: view as Any, toItem: self.view.safeAreaLayoutGuide)
        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: self)
    }
    
    func embed(child: UIViewController, constraints: (UIView) -> [NSLayoutConstraint]) {
        let controller = child
        controller.willMove(toParent: self)
        self.addChild(controller)
        self.view.addSubview(controller.view)
        let view = controller.view
        let constraints = constraints(view!)
        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: self)
    }
    
    func childBody(child: UIViewController) {
        let controller = child
        controller.willMove(toParent: self)
        self.addChild(controller)
        self.view.addSubview(controller.view)
        let view = controller.view
        let constraints = NSLayoutConstraint.body(item: view as Any, toItem: self.view)
        NSLayoutConstraint.activate(constraints)
        controller.didMove(toParent: self)
    }
}

//extension UIViewController {
//    func fintTopMostPresentedViewController<T>(class: T.Type) where T: UIViewController {
//
//    }
//}
//
//class ViewControllersSupplement {
//    class ActivityIndicator: UIViewController {
//        class IndicatorView: UIView {
//            var commontOffset: CGFloat = 10
//            var insets: UIEdgeInsets {
//                return UIEdgeInsets(top: self.commontOffset, left: self.commontOffset, bottom: self.commontOffset, right: self.commontOffset)
//            }
//            // put into vibrant and blur and make it really bigger :3
//            var contentView: UIView?
//            var indicator: UIActivityIndicatorView?
//            var blurView: UIView?
//            var vibrantView: UIView?
//
//            override init(frame: CGRect) {
//                super.init(frame: frame)
//                self.setup()
//            }
//
//            required init?(coder aDecoder: NSCoder) {
//                super.init(coder: aDecoder)
//                self.setup()
//            }
//
//            func addLayout() {
//                if let view = self.contentView {
//                    view.snp.makeConstraints { (make) in
//                        make.edges.equalToSuperview()
//                    }
//                }
//                if let view = self.blurView {
//                    view.snp.makeConstraints { (make) in
//                        make.edges.equalToSuperview()
//                    }
//                }
//                if let view = self.vibrantView {
//                    view.snp.makeConstraints { (make) in
//                        make.edges.equalToSuperview()
//                    }
//                }
//                if let view = self.indicator {
//                    view.snp.makeConstraints { (make) in
//                        make.edges.equalToSuperview().inset(self.insets)
//                    }
//                }
//                return
//            }
//
//            override func layoutSubviews() {
//                super.layoutSubviews()
//                if let view = self.contentView {
//                    view.clipsToBounds = true
//                    view.layer.cornerRadius = view.frame.size.height / 2
//                }
//            }
//
//            func setup() {
//                self.translatesAutoresizingMaskIntoConstraints = false
//                let contentView = UIView()
//
//                let effect = UIBlurEffect(style: .regular)
//                let blurView = UIVisualEffectView(effect: effect)
//                let vibrantView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: effect))
//
//                let indicator = UIActivityIndicatorView(style: .whiteLarge)
//
//                vibrantView.contentView.addSubview(indicator)
//                blurView.contentView.addSubview(vibrantView)
//                contentView.addSubview(blurView)
//                self.addSubview(contentView)
//
//                self.contentView = contentView
//                self.blurView = blurView
//                self.vibrantView = vibrantView
//                self.indicator = indicator
//
//                self.addLayout()
//            }
//        }
//        var indicator = IndicatorView()
//        var coloredView = UIView()
//        override func viewDidLoad() {
//            self.view.addSubview(self.indicator)
//            self.view.addSubview(self.coloredView)
//            if self.indicator.superview != nil {
//                self.indicator.snp.makeConstraints { (make) in
//                    make.center.equalToSuperview()
//                }
//            }
//            if self.coloredView.superview != nil {
//                self.coloredView.snp.makeConstraints { (make) in
//                    make.edges.equalToSuperview()
//                }
//            }
//        }
//        override func viewWillAppear(_ animated: Bool) {
//            self.coloredView.backgroundColor = UIColor.white
//            self.coloredView.alpha = 0.5
//        }
//        func start() {
//            self.indicator.indicator?.startAnimating()
//        }
//        func stop() {
//            self.indicator.indicator?.stopAnimating()
//        }
//    }
//}
//
//extension ViewControllersSupplement.ActivityIndicator: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AppearanceService.Transitions.Alpha.create(isForward: true)
//    }
//
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return AppearanceService.Transitions.Alpha.create(isForward: false)
//    }
//}
//
//// MARK: Activity indicator
//extension ViewControllersSupplement {
//    func startActivityIndicator(at: UIViewController) {
//        let controller = ViewControllersSupplement.ActivityIndicator()
//        at.addTheChild(controller: controller)
//        controller.start()
//    }
//
//    func startActivityIndicator(at: UIViewController, presented: Bool) -> UIViewController? {
//        if presented {
//            let controller = ViewControllersSupplement.ActivityIndicator()
//            controller.modalPresentationStyle = .custom
//            controller.transitioningDelegate = controller
//            at.present(controller, animated: true) {
//                controller.start()
//            }
//            return controller
//        }
//        else {
//            self.startActivityIndicator(at: at)
//            return nil
//        }
//    }
//
//    func stopActivityIndicator(at: UIViewController, presented: Bool, completion: @escaping () -> ()) {
//        if presented {
//            // we should find it first.
//            // bug.
//            at.dismiss(animated: true) {
//                completion()
//            }
//        }
//        else {
//            self.stopActivityIndicator(at: at)
//        }
//    }
//
//    func stopActivityIndicator(at: UIViewController) {
//        let controllers = at.children.filter { (controller) -> Bool in
//            controller.isKind(of: ViewControllersSupplement.ActivityIndicator.self)
//        }
//
//        if let controller = controllers.first as? ViewControllersSupplement.ActivityIndicator {
//            controller.stop()
//            controller.view.alpha = 1.0
//            UIView.animate(withDuration: 0.3, animations: {
//                controller.view.alpha = 0.0
//            }) { (result) in
//                at.removeTheChild(controller: controller)
//            }
//        }
//    }
//}
//
//extension UIViewController {
//    func removeTheChild(controller: UIViewController?) {
//        controller?.willMove(toParent: nil)
//        // transition?
//        controller?.view.removeFromSuperview()
//        controller?.removeFromParent()
//    }
//
//    func addTheChild(controller: UIViewController?) {
//        let parent = self
//        if let theController = controller {
//            parent.addChild(theController)
//            theController.view.alpha = 0.0
//            UIView.transition(with: parent.view, duration: 0.3, options: .curveEaseInOut, animations: {
//                parent.view.addSubview(theController.view)
//                theController.view.alpha = 1.0
//                theController.view.snp.makeConstraints({ (make) in
//                    make.edges.equalToSuperview()
//                })
//            }, completion: { (result) in
//                if result {
//                    theController.didMove(toParent: parent)
//                }
//            })
//        }
//    }
//}
//
//// MARK: Error Handling.
////import SwiftMessages
//extension UIViewController {
//    enum InformationState {
//        case success
//        case information
//        case warning
//        case error
//    }
//    private class CustomMessageView: MessageView {
//        var listener: ((String) -> ())?
//        func setup() {
//            let recognizer = UITapGestureRecognizer()
//            recognizer.addTarget(self, action: #selector(didPressOnMessage))
//            self.addGestureRecognizer(recognizer)
//        }
//        required init?(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//            self.setup()
//        }
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            self.setup()
//        }
//        @objc func didPressOnMessage() {
//            let message = "```\n\(String(describing: self.titleLabel?.text))\n\(String(describing: self.bodyLabel?.text))\n```"
//            self.listener?(message)
//        }
//        func configured(listener: @escaping (String) -> ()) -> Self {
//            self.listener = listener
//            return self
//        }
//    }
//    func showError(error: Error?, onDismiss: (() -> ())? = nil) {
//        if let theError = error {
//            self.showAlert(title: "Error", message: theError.localizedDescription, style: .error, onDismiss: onDismiss)
//        }
//    }
//    func showSuccess(message: String, onDismiss: (() -> ())? = nil) {
//        self.showAlert(title: "Success", message: message, style: .success, onDismiss: onDismiss)
//    }
//    func showAlert(title: String, message: String, style: InformationState, onDismiss: (() -> ())? = nil) {
//        DispatchQueue.main.async {
//            func styleFrom(style: InformationState) -> Theme {
//                switch style {
//                case .success: return Theme.success
//                case .information: return Theme.info
//                case .warning: return Theme.warning
//                case .error: return Theme.error
//                }
//            }
//
//            let view = MessageView.viewFromNib(layout: .cardView)
//            if Developer.Service.service()?.currentSettings().workflow?.alerts?.isCopypasteEnabled == true {
//                view.tapHandler = { view in
//                    guard let view = view as? MessageView else { return }
//                    let message = "```\n\(String(describing: view.titleLabel?.text))\n\(String(describing: view.bodyLabel?.text))\n```"
//                    UIPasteboard.general.string = message
//                }
////                view = ((CustomMessageView.viewFromNib(layout: .cardView) as? CustomMessageView)?.configured(listener: { (message) in
////                    UIPasteboard.general.string = message
////                })) ?? MessageView.viewFromNib(layout: .cardView)
//            }
//
//            view.configureTheme(styleFrom(style: style))
//            view.configureDropShadow()
//            view.configureContent(title: title, body: message, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: nil, buttonTapHandler: nil)
//
//            view.button?.isHidden = true
//            view.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
//
//            //        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
//            var configuration = SwiftMessages.Config()
//            configuration.eventListeners.append({ (event) in
//                switch event {
//                case .didHide: onDismiss?()
//                default: return
//                }
//            })
//            SwiftMessages.show(config: configuration, view: view)
//        }
//    }
//}
//
//// MARK: Alerts
//extension ViewControllersSupplement {
//    class Alert {
//        class Button {
//            enum Style {
//                case destructive
//                case `default`
//                case cancel
//                func style() -> UIAlertAction.Style {
//                    switch self {
//                    case .destructive: return .destructive
//                    case .default: return .default
//                    case .cancel: return .cancel
//                    }
//                }
//            }
//            var title: String?
//            var message: String?
//            var tintColor: UIColor?
//            var backgroundColor: UIColor?
//            var action: () -> () = {}
//            var style: Style = .default
//            func configured(title: String?) -> Self {
//                self.title = title
//                return self
//            }
//            func configured(message: String?) -> Self {
//                self.message = message
//                return self
//            }
//            func configured(tintColor: UIColor?) -> Self {
//                self.tintColor = tintColor
//                return self
//            }
//            func configured(backgroundColor: UIColor?) -> Self {
//                self.backgroundColor = backgroundColor
//                return self
//            }
//            func configured(action: @escaping () -> ()) -> Self {
//                self.action = action
//                return self
//            }
//            func configured(style: Style) -> Self {
//                self.style = style
//                return self
//            }
//            init() {
//                self.style = .default
//            }
//        }
//
//        var buttons: [Button] = []
//
//        var title: String?
//        var message: String?
//
//        // MARK: Configuration
//        func configured(title: String?) -> Self {
//            self.title = title
//            return self
//        }
//
//        func configured(message: String?) -> Self {
//            self.message = message
//            return self
//        }
//
//        func addButton(button: Button?) -> Self {
//            if let theButton = button {
//                self.buttons += [theButton]
//            }
//            return self
//        }
//
//        func viewController() -> UIViewController {
//            let alert = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
//            self.buttons.compactMap { (button) in
//                UIAlertAction(title: button.title, style:button.style.style(), handler: { (action) in
//                    button.action()
//                })
//                }.forEach { alert.addAction($0) }
//
//            return alert
//        }
//
//        func addCancelButton() -> Self {
//            return self.addButton(button: ViewControllersSupplement.Alert.Button().configured(title: "Отменить").configured(style: .cancel))
//        }
//    }
//
//    func addAlert(alert: Alert, at: UIViewController) {
//        let controller = alert.viewController()
//        at.present(controller, animated: true, completion: nil)
//        //at.addTheChild(controller: controller)
//    }
//}
