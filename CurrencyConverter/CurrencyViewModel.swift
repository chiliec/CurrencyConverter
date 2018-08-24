//
//  CurrencyViewModel.swift
//  CurrencyConverter
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias CurrencyRate = (acronym: String, rate: Double)

final class CurrencyViewModel {
    
    public let isDataAvailable = BehaviorRelay<Bool>(value: false)
    
    public var ratesCount: Int {
        return currency.rates.count
    }
    
    private var currency = Currency.empty()
    
    private var selectedRate: CurrencyRate = ("USD", 100)
    
    private let currencyEndpoint = CurrencyEndpoint()
    
    private let disposeBag = DisposeBag()
    
    init() {
        bindings()
    }
    
    func updateSelectedRate(newRate: Double) {
        selectedRate.rate = newRate
    }
    
    func selectCurrencyAtIndexPath(indexPath: IndexPath) {
        selectedRate = rateForIndexPath(indexPath: indexPath)
    }
    
    func rateForIndexPath(indexPath: IndexPath) -> CurrencyRate {
        if indexPath.section == 0 {
            return selectedRate
        } else if indexPath.section == 1, indexPath.row < currency.rates.count {
            let acronym = Array(currency.rates.keys)[indexPath.row]
            let rate = Array(currency.rates.values)[indexPath.row] * selectedRate.rate
            return (acronym, rate)
        }
        return ("UWN", 0)
    }
    
    private func bindings() {
        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            .map { timer -> () in
                return self.currencyEndpoint
                    .getCurrencies(from: self.selectedRate.acronym)
                    .subscribe(onNext: { (currency) in
                        self.currency = currency
                        self.isDataAvailable.accept(true)
                    }, onError: { (error) in
                        self.isDataAvailable.accept(false)
                    })
                    .disposed(by: self.disposeBag)
            }
            .subscribe()
            .disposed(by: disposeBag)
    }
}
