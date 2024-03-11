//
//  CalculationHistoryTableViewCell.swift
//  TinkoffCalculator
//
//  Created by Airat K on 11/3/2024.
//

import UIKit


class CalculationHistoryTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "CalculationHistoryTableViewCell"
    
    let resultLabel = UILabel()
    let expressionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(expression: [ExpressionItem], result: Double) {
        resultLabel.text = String(result)
        expressionLabel.text = expression.map { expressionItem in
            switch expressionItem {
            case let .number(number):
                return String(number)
            case let .operation(operation):
                return operation.rawValue
            }
        } .joined(separator: " ")
    }
    
}

extension CalculationHistoryTableViewCell {
    
    func setUpCell() {
        contentView.addSubview(resultLabel)
        contentView.addSubview(expressionLabel)
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        expressionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            resultLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -4)
        ])
        NSLayoutConstraint.activate([
            expressionLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 4),
            expressionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            expressionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            expressionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        resultLabel.textColor = .label
        
        expressionLabel.numberOfLines = 0
        expressionLabel.font = .systemFont(ofSize: 12)
        expressionLabel.textColor = .secondaryLabel
    }
    
}
