//
//  CurrencyCell.swift
//  CurrencyConverter
//
//  Created by Бабин Владимир on 24/08/2018.
//  Copyright © 2018 Vladimir Babin. All rights reserved.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    
    public lazy var rightTextView: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .right
        return textField
    }()
    
    init(reuseIdentifier: String) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.text = "Super currency"
        contentView.addSubview(rightTextView)
        rightTextView.snp.makeConstraints { (make) in
            make.height.right.top.equalTo(contentView)
            if let textLabel = textLabel {
                make.left.equalTo(textLabel.snp.right).priority(.low)
            } else {
                make.left.equalTo(contentView).priority(.low)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAcronym(acronym: String) {
        textLabel?.text = acronym
    }
    
    func updateRate(rate: Double) {
        rightTextView.text = String(format: "%.2f", arguments: [rate])
    }
}
