//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let base: String
    let date: String
    let rates: [String: Double]
    
    static func empty() -> Currency {
        return Currency(base: "EUR", date: "2018-08-24", rates: [:])
    }
}
