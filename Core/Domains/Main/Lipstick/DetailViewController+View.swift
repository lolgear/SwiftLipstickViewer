//
//  LipstickDetailViewController+View.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 29.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

// MARK: View
extension Domain_Main.Lipstick.DetailViewController {
    class View: UIView {
        var contentView: UIView?
        var image: UIImageView!
        var title: UILabel!
        var details: UILabel!
        var price: UILabel?
        
        // maybe add commonOffset?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.setup()
        }
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setup()
        }
    }
}

// MARK: View - Setup
extension Domain_Main.Lipstick.DetailViewController.View {
    func setup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        
        
        let image: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
        
        let title: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        let details: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        let price: UILabel = {
            let label = UILabel()
            label.numberOfLines = 3
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        [title, details, price].forEach { (label) in
            label.textColor = .gray
        }
        
        self.image = image
        self.title = title
        self.details = details
        self.price = price
        self.contentView = contentView
        
        let list: [UIView] = [image, title, details, price, contentView]
        list.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.addSubview(contentView)
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(details)
        contentView.addSubview(price)
        self.addConstraints()
    }
}

// MARK: View - Constraints
extension Domain_Main.Lipstick.DetailViewController.View {
    
    func addConstraints() {
        // put into StackView or just insets?
        let commonOffset: CGFloat = 20
        if let view = self.contentView, let superview = view.superview {
            
            let insets = UIEdgeInsets(top: commonOffset, left: commonOffset, bottom: commonOffset, right: commonOffset)
            let constraints = NSLayoutConstraint.bounds(item: view, toItem: superview, insets: insets)
            NSLayoutConstraint.activate(constraints)
        }
        
        if let view = self.image, let superview = view.superview {
            let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0)
            let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0)
            
            NSLayoutConstraint.activate([bottom, top, leading, trailing])
        }
        
        if let view = self.title, let superview = view.superview {
            let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.image, attribute: .bottom, multiplier: 1.0, constant: commonOffset)
            let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activate([top, leading, trailing])
        }
        
        if let view = self.details, let superview = view.superview {
            let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.title, attribute: .bottom, multiplier: 1.0, constant: commonOffset)
            let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activate([top, leading, trailing])
        }
        
        if let view = self.price, let superview = view.superview {
            let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self.details, attribute: .bottom, multiplier: 1.0, constant: commonOffset)
            let leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1.0, constant: 0)
            let trailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activate([top, leading, trailing])
        }
    }
}

// MARK: View - Setters
extension Domain_Main.Lipstick.DetailViewController.View {
    func title(title: String?) {
        self.title.text = title
        self.invalidateIntrinsicContentSize()
    }
    func details(details: String?) {
        self.details.text = details
    }
    func price(price: String?) {
        self.price?.text = price
    }
    func image(image: UIImage?) {
        self.image.image = image
    }
}

