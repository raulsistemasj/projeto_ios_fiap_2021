//
//  Double+Extensions.swift
//  RaulJulio
//
//  Created by Raul M Ferreira on 18/12/21.
//

import Foundation

extension Double {
    func getRealValue() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.roundingMode = .down
        return formatter.string(from: self as NSNumber) ?? ""
    }
    
    func getDolarValue() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.roundingMode = .down
        return formatter.string(from: self as NSNumber) ?? ""
    }
}
