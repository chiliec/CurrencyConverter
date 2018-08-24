//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CurrencyViewController: UIViewController {
    
    private let updateSelectedRate = PublishSubject<String?>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private let viewModel = CurrencyViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var textFieldDisposeBag: DisposeBag? = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        setConstraints()
        
        viewModel.isDataAvailable.asDriver()
            .drive(onNext: { (isAvailable) in
                if isAvailable {
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
                }
            })
            .disposed(by: disposeBag)
        
        updateSelectedRate
            .distinctUntilChanged()
            .subscribe(onNext: { (string) in
                if let string = string {
                    let newRate = Double(string) ?? 0
                    self.viewModel.updateSelectedRate(newRate: newRate)
                    self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}

private let reuseIdentifier = "reuseIdentifier"

extension CurrencyViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return viewModel.ratesCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? CurrencyCell
        if cell == nil {
            cell = CurrencyCell(reuseIdentifier: reuseIdentifier)
        }
        let rate = viewModel.rateForIndexPath(indexPath: indexPath)
        cell?.updateAcronym(acronym: rate.acronym)
        cell?.updateRate(rate: rate.rate)
        cell?.rightTextView.isUserInteractionEnabled = (indexPath.section == 0)
        if indexPath.section == 0 {
            cell?.rightTextView.delegate = self
        }
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? CurrencyCell else {
            return
        }
        if indexPath.section == 0 {
            cell.rightTextView.becomeFirstResponder()
        } else {
            viewModel.selectCurrencyAtIndexPath(indexPath: indexPath)
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            if let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CurrencyCell {
                firstCell.rightTextView.becomeFirstResponder()
            }
        }
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.rx.text
            .asDriver()
            .drive(updateSelectedRate)
            .disposed(by: textFieldDisposeBag ?? DisposeBag())
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDisposeBag = DisposeBag()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty {
            let isDotAlreadyContains = textField.text?.contains(".") ?? false
            if string == "." && !isDotAlreadyContains {
                return true
            }
            guard let _ = Double(string) else {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
