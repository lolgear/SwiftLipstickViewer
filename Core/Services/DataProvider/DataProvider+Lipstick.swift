//
//  DataProvider+Lipstick.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import UIKit

extension Domain_DataProvider { enum Lipstick { } }

// MARK: Provider
extension Domain_DataProvider.Lipstick {
    class Provider {
        weak var network: NetworkService?
        weak var media: MediaDeliveryService?
        
        struct Cursor {
            var page: Int = 0
            var size: Int = 10
            mutating func move() {
                self.page += 1
            }
        }
        
        var cursor: Cursor = Cursor()
        var list: [Model] = []
        
        func append(_ data: [Model]) {
            self.list += data
        }
    }
}

// MARK: Configurations
extension Domain_DataProvider.Lipstick.Provider {
    func configured(network: NetworkService?, media: MediaDeliveryService?) -> Self {
        self.network = network
        self.media = media
        return self
    }
}

/*
 "ID" : "40",
 "image" : "images/x2b354c6a14d175c6f7166fb48c8c7d41.jpg",
 "currency_id" : "USD",
 "price" : "10",
 "name" : "Cream Lip Stain Liquid Lipstick 106 Sun Stone",
 "vendor" : "SEPHORA COLLECTION",
 "color" : "562133"
 */
// MARK: Provider Model
extension Domain_DataProvider.Lipstick.Provider {
    struct CurrencyAmount {
        var currency: String
        var price: Double
    }
    struct Model {
        var identifier: String
        var image: UIImage?
        var imageURL: URL?
        var price: CurrencyAmount // shit makers
        var name: String
        var vendor: String
        var color: UIColor
    }
}

// MARK: Image helpers
extension Domain_DataProvider.Lipstick.Provider {
    // input parameters
    // images: [(ID, URL)]
    // onCompletion: ( [ID : (URL, UIImage)] ) -> ()
    func downloadImages(images: [(String, String)], _ onCompletion: @escaping ([ String : (URL, UIImage) ]) -> ()) {
        
        let theImages = images.compactMap { (pair) -> (String, URL)? in
            guard let url = URL(string: pair.1) else { return nil }
            return (pair.0, url)
        }
        
        var results: [URL : UIImage] = [:]
        let group = DispatchGroup.init()
        
        theImages.forEach { (pair) in
            group.enter()
            _ = self.media?.mediaManager.imageAtUrl(url: pair.1, { (url, image) in
                guard let theImage = image else { return }
                if let theUrl = url {
                    results[theUrl] = theImage
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, work: .init(block: {
            // completion block here
            let values = theImages.reduce([:], { (result, pair) -> [ String : (URL, UIImage) ] in
                var result = result
                guard let image = results[pair.1] else { return result }
                result[pair.0] = (pair.1, image)
                return result
            })
            onCompletion(values)
        }))
    }
}

// MARK: Data
extension Domain_DataProvider.Lipstick.Provider {
    struct Options: OptionSet {
        let rawValue: Int
        static let shouldWaitForImages = Options(rawValue: 1 << 0)
    }
    
    func getProducts(options: Options = [], _ onResult: @escaping (Result<[Model]>) -> ()) {
        //            let cursor = self.cursor.movedCursor()
        //            self.getProducts(page: cursor.nextPage, onResult)
        let cursor = self.cursor
        self.getProducts(page: cursor.page, size: cursor.size, options: options, onResult)
    }
    
    func getProducts(page: Int, size: Int, options: Options = [], _ onResult: @escaping (Result<[Model]>) -> ()) {
        // self.data(onResult)
        self.network?.getProducts(page: page, size: size, { [weak self] (response) in
            switch response {
            case .error(let error): onResult(.error(error))
            case .result(let value):
                // work here.
                let imagesResources = value.map { (product) in
                    return (product.ID, product.image)
                }
                // maybe add async -> sync
                var theResults: [Model] = []
                let group = DispatchGroup.init()
                group.enter()
                
                if options.contains(.shouldWaitForImages) {
                    self?.downloadImages(images: imagesResources, { (result) in
                        // create model here.
                        let results = value.map { (product) -> Model? in
                            return self?.model(product: product, image: result[product.ID]?.1, imageURL: result[product.ID]?.0)
                        }
                        theResults = results.compactMap{$0}
                        group.leave()
                    })
                }
                else {
                    let results = value.map { (product) -> Model? in
                        return self?.model(product: product, image: nil, imageURL: URL(string: product.image))
                    }
                    theResults = results.compactMap{$0}
                    group.leave()
                }
                group.notify(queue: .main, work: .init(block: {
                    if !theResults.isEmpty {
                        self?.cursor.move()
                    }
                    self?.append(theResults)
                    onResult(.result(theResults))
                }))
            }
        })
    }
}

import NetworkWorm
extension Domain_DataProvider.Lipstick.Provider {
    struct CurrencyExtractor {
        static func sanitized(currency: String) -> String {
            switch currency {
            case "RUR": return "RUB"
            default: return currency
            }
        }
        
        static func sanitized(price: String) -> Double {
            return Double(price) ?? 0
        }
        static func extracted(currency: String, price: String) -> CurrencyAmount {
            return CurrencyAmount(currency: sanitized(currency: currency), price: sanitized(price: price))
        }
    }
    
    struct ColorExtractor {
        static func extracted(color: String) -> UIColor {
            // shit makers
            // fuck you all.
            
            var rgbValue: UInt32 = 0
            Scanner(string: color).scanHexInt32(&rgbValue)
            
            let (red, green, blue) = ((rgbValue >> 16) & 0xFF, (rgbValue >> 8) & 0xFF, rgbValue & 0xFF)
            
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
        }
    }
    
    func model(product: Endpoints.Products.Response.Product, image: UIImage?, imageURL: URL?) -> Model {
        let identifier: String = product.ID
        let price: CurrencyAmount = CurrencyExtractor.extracted(currency: product.currency_id, price: product.price) // shit makers
        let name: String = product.name
        let vendor: String = product.vendor
        let color: UIColor = ColorExtractor.extracted(color: product.color)
        return Model(identifier: identifier, image: image, imageURL: imageURL, price: price, name: name, vendor: vendor, color: color)
    }
}
