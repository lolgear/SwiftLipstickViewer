//
//  NSLayoutConstraint+Extensions.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 27.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint {
    static func bounds(item: Any, toItem: Any) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.leading, .trailing, .top, .bottom]
        let constraints = attributes.map {
            return NSLayoutConstraint(item: item, attribute: $0, relatedBy: .equal, toItem: toItem, attribute: $0, multiplier: 1.0, constant: 0)
        }
        return constraints
    }
    
    static func body(item: Any, toItem: Any) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.leading, .width, .top, .height]
        let constraints = attributes.map {
            return NSLayoutConstraint(item: item, attribute: $0, relatedBy: .equal, toItem: toItem, attribute: $0, multiplier: 1.0, constant: 0)
        }
        return constraints
    }
    
    static func bounds(item: Any, toItem: Any, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        let attributes: [NSLayoutConstraint.Attribute] = [.leading, .trailing, .top, .bottom]
        let edges: [CGFloat] = [insets.left, -insets.right, insets.top, -insets.bottom]
        let zipped = zip(attributes, edges)
        let constraints = zipped.map { (pair) -> NSLayoutConstraint in
            let (attribute, inset) = pair
            return NSLayoutConstraint(item: item, attribute: attribute, relatedBy: .equal, toItem: toItem, attribute: attribute, multiplier: 1.0, constant: inset)
        }
        return constraints
    }
    
    static func constraint(for item: UIView, attribute: NSLayoutConstraint.Attribute, in view: UIView) -> NSLayoutConstraint? {
        return view.constraints.first { (constraint) -> Bool in
            constraint.firstItem === item && constraint.firstAttribute == attribute
        }
    }
}
