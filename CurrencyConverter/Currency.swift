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
    
    static func currencyDescription(by acronym: String) -> String {
        switch acronym {
        case "EUR":
            return "Euro"
        case "AUD":
            return "Australian Dollar"
        case "BGN":
            return "Bulgarian Lev"
        case "BRL":
            return "Brazilian Real"
        case "CAD":
            return "Canadian Dollar"
        case "CHF":
            return "Swiss Franc"
        case "CNY":
            return "Yuan Renminbi"
        case "CZK":
            return "Czech Koruna"
        case "DKK":
            return "Danish Krone"
        case "GBP":
            return "Pound Sterling"
        case "HKD":
            return "Hong Kong Dollar"
        case "HRK":
            return "Croatian Kuna"
        case "HUF":
            return "Hungarian Forint"
        case "IDR":
            return "Indonesian Rupiah"
        case "ILS":
            return "Israeli New Shekel"
        case "INR":
            return "Indian Rupee"
        case "ISK":
            return "Iceland Krona"
        case "JPY":
            return "Japanese Yen"
        case "KRW":
            return "Korean Won"
        case "MXN":
            return "Mexican Nuevo Peso"
        case "MYR":
            return "Malaysian Ringgit"
        case "NOK":
            return "Norwegian Krone"
        case "NZD":
            return "New Zealand Dollar"
        case "PHP":
            return "Philippine Peso"
        case "PLN":
            return "Polish Zloty"
        case "RON":
            return "Romanian New Leu"
        case "RUB":
            return "Russian Ruble"
        case "SEK":
            return "Swedish Krona"
        case "SGD":
            return "Singapore Dollar"
        case "THB":
            return "Thai Baht"
        case "TRY":
            return "Turkish Lira"
        case "USD":
            return "US Dollar"
        case "ZAR":
            return "South African Rand"
        default:
            return "Unknown"
        }
    }
}
