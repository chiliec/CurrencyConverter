//
//  CurrencyEndpointTests.swift
//  CurrencyConverterTests
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import XCTest
import RxSwift
@testable import CurrencyConverter

class CurrencyEndpointTests: XCTestCase {
    
    private var currency: Currency = Currency.empty()
    private let disposeBag = DisposeBag()
    
    func testEndpoint() {
        let expect = expectation(description: "Data is available")
        
        XCTAssertEqual(currency.date, "2018-08-24", "Date not equal to default")
        XCTAssertEqual(currency.base, "EUR", "Base currency not equal to default")
        XCTAssertEqual(currency.rates, [:], "Rates not equal to default")
        
        let endpoint = CurrencyEndpoint()
        endpoint.getCurrencies(from: "USD")
            .subscribe(onNext: { (currency) in
                self.currency = currency
                expect.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3.0) { error in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            XCTAssertEqual(self.currency.date, currentDate, "Our date not equal to server date")
            XCTAssertEqual(self.currency.base, "USD", "Server response base currency not equal to our date")
            XCTAssertGreaterThan(self.currency.rates.count, 0, "Server must response rates")
        }
    }
}
