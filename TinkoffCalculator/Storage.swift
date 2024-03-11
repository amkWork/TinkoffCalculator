//
//  Storage.swift
//  TinkoffCalculator
//
//  Created by Airat K on 11/3/2024.
//

import Foundation


struct Calculation: Codable {
    
    let expression: [ExpressionItem]
    let result: Double
    
}


extension ExpressionItem: Codable {

    enum CodingKeys: String, CodingKey {
        
        case number
        case operation
        
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
            return
        }

        if let rawOperation = try container.decodeIfPresent(String.self, forKey: .operation), let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
        
        throw CalculationError.historyItemNotFound
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .number(number):
            try container.encode(number, forKey: .number)
        case let .operation(operation):
            try container.encode(operation.rawValue, forKey: .operation)
        }
    }
    
}


class CalculationHistoryStorage {
    
    static let calculationHistoryKey = "calculationHistoryKey"
    
    func setHistory(_ history: [Calculation]) {
        guard let encoded = try? JSONEncoder().encode(history) else { return }
        
        UserDefaults.standard.setValue(encoded, forKey: CalculationHistoryStorage.calculationHistoryKey)
    }
    
    func loadHistory() -> [Calculation] {
        guard
            let decoded = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey),
            let history = try? JSONDecoder().decode([Calculation].self, from: decoded)
            else { return [] }
        
        return history
    }
    
}
