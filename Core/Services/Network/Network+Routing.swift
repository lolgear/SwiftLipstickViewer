//
//  Network+Routing.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 28.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
import NetworkWorm

protocol NetworkService__Routes {
    func getProducts(page: Int, size: Int, _ onResponse: @escaping(Result<[Endpoints.Products.Response.Product]>) -> ())
    func downloadResource(url: URL?, _ onResponse: @escaping URLSessionWrapper.TaskCompletion) -> NetworkWorm.CancellationToken?
}

// MARK: Routing // For easy-to-use mocks.
extension NetworkService {
    class Routing: NetworkService__Routes {
        weak var service: NetworkService?
        var client: APIClient? { return service?.client }
        
        func getProducts(page: Int, size: Int, _ onResponse: @escaping (Result<[Endpoints.Products.Response.Product]>) -> ()) {
            
        }
        
        func downloadResource(url: URL?, _ onResponse: @escaping URLSessionWrapper.TaskCompletion) -> CancellationToken? {
            return self.client?.downloadAtUrl(url: url, onResponse: onResponse)
        }
    }
}

// MARK: Configurations
extension NetworkService.Routing {
    func configured(by service: NetworkService?) -> Self {
        self.service = service
        return self
    }
}

// MARK: API Requests.
// Could be adopted to protocols if needed.
// downloadResource is from protocol from media manager.
// and performSearch is from protocol from data provider.

extension NetworkService: NetworkService__Routes {
    func getProducts(page: Int, size: Int, _ onResponse: @escaping (Result<[Endpoints.Products.Response.Product]>) -> ()) {
        return self.routing.getProducts(page: page, size: size, onResponse)
    }
    
    func downloadResource(url: URL?, _ onResponse: @escaping URLSessionWrapper.TaskCompletion) -> NetworkWorm.CancellationToken? {
        return self.routing.downloadResource(url: url, onResponse)
    }
}

// MARK: Dummy
extension NetworkService {
    class DummyRouting: Routing {
        
        var bundle: Bundle?
        
        override init() {
            if let path = Bundle.main.path(forResource: "Test", ofType: "bundle") {
                self.bundle = Bundle(path: path)
            }
        }
        
        func products() -> [ String : AnyObject ]? {
            guard
                let url = self.bundle?.url(forResource: "products", withExtension: "json"),
                let data = try? Data(contentsOf: url),
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let result = json as? [ String : AnyObject ]
                else { return nil }
            return result
        }
        
        func image(name: String) -> UIImage? {
            guard
                let url = self.bundle?.url(forResource: name, withExtension: "jpg"),
                let image = UIImage(contentsOfFile: url.absoluteString)
                else { return nil }
            return image
        }
        
        func image(url: URL) -> UIImage? {
            guard let image = UIImage(contentsOfFile: url.absoluteString) else { return nil }
            return image
        }
        
        struct Sanitizer<T> {
            var value: T
            init(_ value: T) {
                self.value = value
            }
        }
                
        override func getProducts(page: Int, size: Int, _ onResponse: @escaping (Result<[Endpoints.Products.Response.Product]>) -> ()) {
            guard let products = self.products(),
                let response = Endpoints.Products.Response(dictionary: products) else {
                    onResponse(.error(ErrorFactory.createError(errorType: .responseIsEmpty)!))
                    return
            }
            
            let results = response.results.map{ Sanitizer($0) }.map {$0.apply(bundle: self.bundle)}
            
            // now paging
            
            let remainsCount = results.count - page * size
            
            if (remainsCount <= 0) {
                onResponse(.result([]))
                return
            }
            
            let correctSize = max(min(remainsCount, size), 0)
            let range = page * size ..< page * size + correctSize
            
            let theResults = Array(results[range])
            
            onResponse(.result(theResults))
        }
        
        override func downloadResource(url: URL?, _ onResponse: @escaping URLSessionWrapper.TaskCompletion) -> CancellationToken? {
            
            // return image.
            if let theUrl = url,
               let image = self.image(url: theUrl),
               let jpegData = image.jpegData(compressionQuality: 1.0) {
                onResponse(.success(theUrl, jpegData))
            }
            else {
                onResponse(.error(url, ErrorFactory.createError(errorType: .responseIsEmpty)!))
            }
            return nil
        }
    }
}

extension NetworkService.DummyRouting.Sanitizer where T == Endpoints.Products.Response.Product {
    func apply(bundle: Bundle?) -> Endpoints.Products.Response.Product {
        var value = self.value
        if let bundle = bundle {
            value.image = bundle.bundlePath + "/" + value.image
        }
        return value
    }
}
