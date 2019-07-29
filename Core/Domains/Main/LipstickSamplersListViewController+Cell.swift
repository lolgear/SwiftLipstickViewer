//
//  LipstickSamplersListViewController+Cell.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

// MARK: Cell
extension LipstickSamplersListViewController {
    class Cell: UICollectionViewCell {
        class Model {
            var color: UIColor?
            var selected: Box<Bool> = Box(false)
            init() {}
        }
        
        var model: Model? {
            didSet {
                self.filledView?.update(strokedColor: self.model?.color)
                self.strokedView?.update(strokedColor: self.model?.color)
                self.model?.selected.bind(listening: { (value) in
                    self.animateSelection(value: value)
                })
            }
        }
        
        func animateSelection(value: Bool) {
            UIView.transition(with: self, duration: 0.3, options: [], animations: {
                self.strokedView?.alpha = value ? 1.0 : 0.0
                self.transform = value ? CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1) : CGAffineTransform.identity
            }, completion: nil)
        }
        
        var commonOffset: CGFloat = 4 // offset between views.
        func commonInsets() -> UIEdgeInsets {
            let offset = self.commonOffset
            return UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
        }
        
        var filledView: FilledView?
        var strokedView: StrokedView?
        
        func setup() {
            self.translatesAutoresizingMaskIntoConstraints = false
            // equal bounds?
            let filledView = FilledView()
            let strokedView = StrokedView()
            self.addSubview(filledView)
            self.addSubview(strokedView)
            self.filledView = filledView
            self.strokedView = strokedView
            
            filledView.translatesAutoresizingMaskIntoConstraints = false
            strokedView.translatesAutoresizingMaskIntoConstraints = false
            
            self.backgroundColor = .white
            self.addConstraints()
        }
        
        func addConstraints() {

            if let view = self.filledView, let superview = view.superview {
                let constraints = NSLayoutConstraint.bounds(item: view, toItem: superview, insets: self.commonInsets())
                NSLayoutConstraint.activate(constraints)
            }

            if let view = self.strokedView, let superview = view.superview {
                let constraints = NSLayoutConstraint.bounds(item: view, toItem: superview)
                NSLayoutConstraint.activate(constraints)
            }
        }
        
        // maybe we need only layout subviews?...
//        override func layoutSubviews() {
//            super.layoutSubviews()
//            let frame = self.bounds
//            let filledViewFrame = CGRect(x: self.commonOffset, y: self.commonOffset, width: frame.size.width - 2 * self.commonOffset, height: frame.size.height - 2 * self.commonOffset)
//            self.filledView?.frame = filledViewFrame
//            self.strokedView?.frame = self.bounds
//        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setup()
        }
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
    }
}

// MARK: Cell ShapedView
extension LipstickSamplersListViewController.Cell {
    class ShapedView: UIView {
        var borderLayer: CAShapeLayer?
        func updateLayer() {
            if self.borderLayer == nil {
                let layer = CAShapeLayer()
                self.layer.addSublayer(layer)
                self.borderLayer = layer
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 2)
            //            path.apply(self.transform)
            self.borderLayer?.path = path.cgPath
            self.borderLayer?.frame = self.bounds
        }
    }
    
    class StrokedView: ShapedView {
        var strokedPattern = [2, 2] as [NSNumber]
        func update(strokedColor: UIColor?) {
            self.updateLayer()
            if let layer = self.borderLayer {
                layer.strokeColor = strokedColor?.cgColor
                layer.lineDashPattern = strokedPattern
                layer.fillColor = UIColor.clear.cgColor
            }
        }
        func configuredByPattern(pattern: [NSNumber]) -> Self {
            self.strokedPattern = pattern
            return self
        }
    }
    
    // MARK: FilledView
    class FilledView: ShapedView {
        func update(strokedColor: UIColor?) {
            self.updateLayer()
            if let layer = self.borderLayer {
                layer.fillColor = strokedColor?.cgColor
            }
        }
    }
}
