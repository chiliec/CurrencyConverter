//
//  CurrencyViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
@testable import CurrencyConverter

class CurrencyViewModelTests: XCTestCase {
    
    private let disposeBag = DisposeBag()
    
    private var viewModel = CurrencyViewModel()
    
    override func setUp() {
        super.setUp()
        viewModel = CurrencyViewModel()
    }
    
    func testViewModel() {
        XCTAssertEqual(viewModel.ratesCount, 0, "Rates count must equal to zero at start")
        let firstCellRate = viewModel.rateForIndexPath(indexPath: IndexPath(row: 0, section: 0))
        XCTAssertEqual(firstCellRate.acronym, "USD", "Default acronym must be equal to USD")
        XCTAssertEqual(firstCellRate.rate, 100, "Default value must be equal to 100")
        
        let expect = expectation(description: "Data is available")
        
        viewModel.isDataAvailable
            .subscribe(onNext: { (isAvailable) in
                if isAvailable {
                    expect.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3.0) { error in
            XCTAssertTrue(error == nil)
            XCTAssertGreaterThan(self.viewModel.ratesCount, 0, "Rates count must be greater than zero")
            let newRate = 42.0
            self.viewModel.updateSelectedRate(newRate: 42)
            let selectedRate = self.viewModel.rateForIndexPath(indexPath: IndexPath(row: 0, section: 0))
            XCTAssertEqual(selectedRate.rate, newRate, "Selected rate must updating normally")
        }
    }
}
