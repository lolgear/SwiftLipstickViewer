//
//  DetailViewController.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 27.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit
import ImagineDragon

extension Domain_Main.Lipstick {
    class DetailViewController: BaseViewController {
        var model: Model?
        var detailsView: View?
        var operation: Statusable?
    }
}

// MARK: View Lifecycle
extension Domain_Main.Lipstick.DetailViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = View()
        self.detailsView = view
        self.view.addSubview(view)
        let constraints = NSLayoutConstraint.bounds(item: view, toItem: self.view)
        NSLayoutConstraint.activate(constraints)
        
//        self.view.backgroundColor = .green
        
        self.connectModel()
    }
    
}

// MARK: Model
extension Domain_Main.Lipstick.DetailViewController: HasModelProtocol {
    class DetailsProvider {
        static func price(currency: Domain_DataProvider.Lipstick.Provider.CurrencyAmount) -> String {
            return CurrencyFormatter.price(for: currency.price, code: currency.currency) ?? "\(currency.price) \(currency.currency)"
        }
        static func details(_ model: Domain_DataProvider.Lipstick.Provider.Model?) -> Domain_Main.Lipstick.DetailViewController.Model? {
            guard let theModel = model else { return nil }
            let result = Domain_Main.Lipstick.DetailViewController.Model()
            
            result.imageURL = theModel.imageURL
            result.title = theModel.vendor
            result.details = theModel.name
            result.price = price(currency: theModel.price)
            return result
        }
    }
    class Model {
        var media: MediaDeliveryService?
        var image: UIImage?
        var imageURL: URL?
        var title: String = ""
        var details: String = ""
        var price: String = ""
        init() {}
    }
    
    func connectModel() {
        guard let view = self.detailsView, let model = self.model else  {
            return
        }
        
        view.title(title: model.title)
        view.details(details: model.details)
        view.price(price: model.price)
        
        // TODO: we should cancel operation on dealloc.
        self.operation = self.model?.media?.mediaManager.imageAtUrl(url: self.model?.imageURL, { [weak self] (url, image) in
            DispatchQueue.main.async {
                self?.detailsView?.image(image: image)
            }
        })
    }
    
    func updateForNewModel() {
        self.connectModel()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil {
            self.operation?.cancel()
        }
    }
}

