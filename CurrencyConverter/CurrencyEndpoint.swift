//
//  CurrencyEndpoint.swift
//  CurrencyConverter
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import Foundation
import RxSwift

struct CurrencyEndpoint {
    
    private let baseUrl = "https://revolut.duckdns.org/"
    
    func getCurrencies(from baseCurrency: String) -> Observable<Currency> {
        let url = URL(string: baseUrl + "latest?base=" + baseCurrency)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return Observable.create({ observer in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Currency.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let parsingError {
                    observer.onError(parsingError)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
    }
}
