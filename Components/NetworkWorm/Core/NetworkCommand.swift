//
//  NetworkCommand.swift
//  SwiftTrader
//
//  Created by Lobanov Dmitry on 23.02.17.
//  Copyright © 2017 OpenSourceIO. All rights reserved.
//

import Foundation
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public class Command {
    
    public init() {}
    
    var shouldStopError: Error?
    
    var shouldStop: Bool {
        return shouldStopMessage != nil
    }
    
    var shouldStopMessage: String? {
        return shouldStopError?.localizedDescription
    }

    var configuration: Configuration? // assign somewhere before use.
    
    //MARK: Subclass
    var method: HTTPMethod = .get
    var path = ""
    var scheme = "https"
    var authorized = true
    var requestSerialization = RequestSerialization.JSON
    // for better times.
    func httpHeaders() -> [String : String]? {
        return [:]
    }
    func queryParameters() -> [String : AnyObject]? {
        return [:]
    }
    
    // MARK: Public accessors. Use externally.
    public var hasAuthentication: Bool {
        return self.authorized
    }
    
    public var theRequestSerialization: RequestSerialization {
        return self.requestSerialization
    }
}

////
//// Authorization: Assistant "base64(partnerId:referenceCode:password)"
//// for example
//// Authorization: Assistant "NzpwYXl6LWFzc2lzdGFudC0wMTpjaGFuZ2UubWU="
//public class CommandSignInAsAssistant: Command {
//    var partnerId: String
//    var referenceCode: String
//    var password: String
//    public var token: String? {
//        let string = "\(partnerId):\(referenceCode):\(password)"
//        let base64String = Data(string.utf8).base64EncodedString()
//        let result = "Assistant \"\(base64String)\""
//        return result
//    }
//    public init(partnerId: String, referenceCode: String, password: String) {
//        self.partnerId = partnerId
//        self.referenceCode = referenceCode
//        self.password = password
//        super.init()
//        self.path = "whoami"
//        self.requestSerialization = .OnlyURL
//    }
//}
//
//// https://api.\(Run.prod).pay-z.ru/v1/stores/\(si)/goods/\(code)", method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON
//
//public class CommandGetItemByBarcode: Command {
//    var shopIdentifier: Int
//    var barcode: String
////    override func queryParameters() -> [String : AnyObject]? {
////        var result = super.queryParameters()
////        result?["barcode"] = self.barcode as AnyObject
////        return result
////    }
//    public init(shopIdentifier: Int, barcode: String) {
//        self.shopIdentifier = shopIdentifier
//        self.barcode = barcode
//        super.init()
//        self.path = "stores/\(shopIdentifier)/goods/\(barcode)"
//        self.requestSerialization = .OnlyURL
//    }
//}
//
//public class CommandOrdersCreate: Command {
//    public typealias Item = [String : AnyObject]
//    var shopIdentifier: Int
//    var posSlug: String // unknown ID from terminal.
//    var items: [Item]
//    var userInformation: Item?
//    public init(shopIdentifier: Int, posSlug: String, items: [Item]) {
//        self.shopIdentifier = shopIdentifier
//        self.posSlug = posSlug
//        self.items = items
//        super.init()
//        self.method = .post
//        self.path = "orders"
//        self.requestSerialization = .JSON
//    }
//    
//    override func queryParameters() -> [String : AnyObject]? {
//        var parameters = super.queryParameters()
//        // put them somehow?
//        parameters?["lineItems"] = self.items as AnyObject
//        parameters?["storeId"] = self.shopIdentifier as AnyObject
//        parameters?["posSlug"] = self.posSlug as AnyObject
//        return parameters
//    }
//}
//
//public class CommandOrdersGet: Command {
//    var identifier: Int
//    public init(identifier: Int) {
//        self.identifier = identifier
//        super.init()
//        self.path = "orders/\(identifier)"
//        self.requestSerialization = .OnlyURL
//    }
//    public override init() {
//        self.identifier = 0
//        super.init()
//        self.path = "orders"
//        self.requestSerialization = .OnlyURL
//    }
//}
//
//public class CommandTerminalCommandStartPaymentFlow: Command {
//    var terminalIdentifier: String
//    // todo: convert to int.
//    var orderIdentifier: Int
//    var proximityCheckCode: String
//    public init(terminalIdentifier: String, orderIdentifier: Int, proximityCheckCode: String) {
//        self.terminalIdentifier = terminalIdentifier
//        self.orderIdentifier = orderIdentifier
//        self.proximityCheckCode = proximityCheckCode
//        super.init()
//        self.method = .post
//        self.path = "terminals/\(terminalIdentifier)/commands"
//        self.requestSerialization = .JSON
//    }
//    override func queryParameters() -> [String : AnyObject]? {
//        var parameters = super.queryParameters()
//        // put them somehow?
//        parameters?["type"] = "StartPaymentFlow" as AnyObject
//        parameters?["orderId"] = self.orderIdentifier as AnyObject
//        parameters?["proximityCheckCode"] = self.proximityCheckCode as AnyObject
//        return parameters
//    }
//    
//    public class func create(terminalIdentifier: String, orderIdentifier: Int, proximityCheckCode: String, email: String?) -> CommandTerminalCommandStartPaymentFlow {
//        if let theEmail = email {
//            return CommandTerminalCommandStartPaymentFlow.WithEmail(terminalIdentifier: terminalIdentifier, orderIdentifier: orderIdentifier, proximityCheckCode: proximityCheckCode, email: theEmail)
//        }
//        return CommandTerminalCommandStartPaymentFlow(terminalIdentifier: terminalIdentifier, orderIdentifier: orderIdentifier, proximityCheckCode: proximityCheckCode)
//    }
//    
//    class WithEmail: CommandTerminalCommandStartPaymentFlow {
//        var email: String
//        init(terminalIdentifier: String, orderIdentifier: Int, proximityCheckCode: String, email: String) {
//            self.email = email
//            super.init(terminalIdentifier: terminalIdentifier, orderIdentifier: orderIdentifier, proximityCheckCode: proximityCheckCode)
//        }
//        override func queryParameters() -> [String : AnyObject]? {
//            var parameters = super.queryParameters()
//            parameters?["recipient"] = self.email as AnyObject
//            return parameters
//        }
//    }
//}
//
//public class CommandShiftsClose: Command {
//    // no parameters.
//    public override init() {
//        super.init()
//        self.method = .post
//        self.path = "close-my-shift";
//        self.requestSerialization = .OnlyURL
//    }
//}

//// Endpoint : { /list }
//// Params : {
////    "access_key" : "YOUR_ACCESS_KEY"
//// }
//public class APICommand: Command {
//    override func queryParameters() -> [String : AnyObject]? {
//        var result = super.queryParameters()
//        guard configuration != nil else {
//            shouldStopError = ErrorFactory.createError(errorType: .theInternal("Configuration did not set!" as AnyObject?))
//            return result
//        }
//        result?["apikey"] = configuration?.apiAccessKey as AnyObject?
//        return result
//    }
//}
//
//// Endpoint : { / }
//// Parameters: s ( search text )
//// Example: http://www.omdbapi.com/?apikey=f60bbf23&s=result
//public class MetadataSearchCommand: APICommand {
//    var searchText: String
//    var page: Int
//    public init(searchText: String, page: Int) {
//        self.searchText = searchText
//        self.page = page
//        super.init()
//    }
//    override func queryParameters() -> [String : AnyObject]? {
//        if let parameters = super.queryParameters() {
//            var theParameters = parameters
//            theParameters["s"] = self.searchText as AnyObject
//            theParameters["page"] = self.page as AnyObject
//            return theParameters
//        }
//        return nil
//    }
//}
//
//// Endpoint : { / }
//// Parameters: i ( id )
//// Example: http://www.omdbapi.com/?apikey=f60bbf23&i=tt3896198
//public class DetailsComand: APICommand {
//    var identifier: String
//    public init(identifier: String) {
//        self.identifier = identifier
//    }
//    override func queryParameters() -> [String : AnyObject]? {
//        if let parameters = super.queryParameters() {
//            var theParameters = parameters
//            theParameters["i"] = self.identifier as AnyObject
//            return theParameters
//        }
//        return nil
//    }
//}
