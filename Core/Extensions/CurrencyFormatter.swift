//
//  CurrencyFormatter.swift
//  SwiftLipstickViewer
//
//  Created by Dmitry Lobanov on 29.07.2019.
//  Copyright © 2019 Dmitry Lobanov. All rights reserved.
//

import Foundation
class CurrencyFormatter {
    static let localesLookup: [ String : Locale ] = Locale.availableIdentifiers.map{Locale.init(identifier: $0)}.reduce([:]) { (result, locale) -> [ String : Locale ] in
        guard let currencyCode = locale.currencyCode else { return result }
        var theResult = result
        theResult[currencyCode] = locale
        return theResult
    }
    
    static func locale(for code: String) -> Locale {
        let identifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue : code])
        let locale = Locale(identifier: identifier)
        
        if locale.currencySymbol == code, let theLocale = localesLookup[code] {
            // escape by searching through currencies.
            return theLocale
        }
        
        return locale
    }
    
    static func price(for money: Double, code: String) -> String? {
        let amount = NSDecimalNumber(floatLiteral: money)
        let formatter = NumberFormatter()
        formatter.locale = self.locale(for: code)
        formatter.numberStyle = .currencyAccounting
        return formatter.string(from: amount)
    }
}
