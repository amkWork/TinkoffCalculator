//
//  CalculationHistoryTableViewController.swift
//  TinkoffCalculator
//
//  Created by Airat K on 11/3/2024.
//

import UIKit


class CalculationHistoryTableViewController: UITableViewController {
    
    var calculationHistory: [(expression: [ExpressionItem], result: Double)] = []
    
    
    init(history: [(expression: [ExpressionItem], result: Double)]) {
        super.init(style: .insetGrouped)
        
        calculationHistory = history
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CalculationHistoryTableViewCell.self, forCellReuseIdentifier: CalculationHistoryTableViewCell.reuseIdentifier)
    }
    
}

extension CalculationHistoryTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calculationHistory.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CalculationHistoryTableViewCell.reuseIdentifier, for: indexPath) as! CalculationHistoryTableViewCell
        let calculationHistoryItem = calculationHistory[indexPath.row]
        
        cell.configure(expression: calculationHistoryItem.expression, result: calculationHistoryItem.result)

        return cell
    }

}
