//
//  NetworkEndpoints.swift
//  NetworkWorm
//
//  Created by Dmitry Lobanov on 07.09.2018.
//  Copyright © 2018 Dmitry Lobanov. All rights reserved.
//

import Foundation
public enum Endpoints {}
extension Endpoints {
    public enum Products {
        public class Command : NetworkWorm.Command {}
        public class Response : NetworkWorm.SuccessResponse {
            public struct Product {
                public var ID: String
                public var image: String
                public var currency_id: String
                public var price: String // shit makers, haha.
                public var name: String
                public var vendor: String
                public var color: String
                
                init?(dictionary: [String : Any]) {
                    guard
                        let ID = dictionary["ID"] as? String,
                        let image = dictionary["image"] as? String,
                        let currency_id = dictionary["currency_id"] as? String,
                        let price = dictionary["price"] as? String,
                        let name = dictionary["name"] as? String,
                        let vendor = dictionary["vendor"] as? String,
                        let color = dictionary["color"] as? String
                    else { return nil }
                    
                    self.ID = ID
                    self.image = image
                    self.currency_id = currency_id
                    self.price = price
                    self.name = name
                    self.vendor = vendor
                    self.color = color
                }
            }
            
            public var results = [Product]()
            
            public override init?(dictionary: PayloadType) {
                super.init(dictionary: dictionary)
                
                guard let items = dictionary["products"] as? [[String : Any]] else {
                    return nil
                }
                
                self.results = items.compactMap {Product(dictionary: $0)}
            }
            
            public required init?(new: PayloadType) {
                super.init(new: new)
            }
        }
        public typealias Get = Router<Command, Response>
    }
}
