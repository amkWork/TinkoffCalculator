//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Airat K on 10/3/2024.
//

import UIKit


enum CalculationError: Error {
    
    case dividedByZero
    case historyItemNotFound
    
}


enum Operation: String {
    
    case add = "+"
    case subtract = "−"
    case multiply = "×"
    case divide = "÷"
    
    func calculate(_ lhs: Double, _ rhs: Double) throws -> Double {
        switch self {
        case .add:
            return lhs + rhs
        case .subtract:
            return lhs - rhs
        case .multiply:
            return lhs * rhs
        case .divide:
            if rhs == 0 {
                throw CalculationError.dividedByZero
            }
            
            return lhs / rhs
        }
    }
    
}

enum ExpressionItem {

    case number(Double)
    case operation(Operation)

}


typealias ButtonData = (
    title: String,
    titleColor: UIColor,
    backgroundColor: UIColor,
    widthMultiplier: CGFloat,
    heightMultiplier: CGFloat,
    onClick: Selector
)


class CalculatorViewController: UIViewController {
    
    let resultLabel = UILabel()
    let keyboardView = UIStackView()
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    var expression: [ExpressionItem] = []
    var calculationHistory: [Calculation] = []
    
    let calculationHistoryStorage = CalculationHistoryStorage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        view.addSubview(resultLabel)
        view.addSubview(keyboardView)
        
        setUpResultLabel()
        setUpKeyboardView()
        
        resetResultLabel()
        
        calculationHistory = calculationHistoryStorage.loadHistory()
    }
    
    func resetResultLabel() {
        resultLabel.text = "0"
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = expression[0] else { return 0 }
        
        var currentResult = firstNumber
        
        for itemIndex in stride(from: 1, to: expression.count - 1, by: 2) {
            guard
                case .operation(let operation) = expression[itemIndex],
                case .number(let number) = expression[itemIndex + 1]
                else { break }
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    @objc
    func showCalculationHistory(_ sender: UIButton) {
        show(CalculationHistoryTableViewController(history: calculationHistory), sender: self)
    }
    
    @objc
    func clearResultLabel(_ sender: UIButton) {
        expression.removeAll()

        resetResultLabel()
    }
    
    @objc
    func handleOperationButtonClick(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle, let buttonOperation = Operation(rawValue: buttonText) else { return }
        guard let resultText = resultLabel.text, let resultNumber = numberFormatter.number(from: resultText)?.doubleValue else { return }
        
        expression.append(.number(resultNumber))
        expression.append(.operation(buttonOperation))
        
        resetResultLabel()
    }
    
    @objc
    func handleDigitOrPeriodButtonClick(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle, resultLabel.text != "Ошибка" else { return }
        
        if buttonText == "." && resultLabel.text?.contains(buttonText) == true { return }
        
        if resultLabel.text == "0" {
            resultLabel.text = buttonText
        } else {
            resultLabel.text?.append(buttonText)
        }
    }
    
    @objc
    func handleCalculateButtonClick(_ sender: UIButton) {
        guard let resultText = resultLabel.text, let resultNumber = numberFormatter.number(from: resultText)?.doubleValue else { return }
        
        expression.append(.number(resultNumber))
        
        do {
            let calculationResultNumber = try calculate()
            
            resultLabel.text = numberFormatter.string(from: NSNumber(value: calculationResultNumber))
        } catch {
            resultLabel.text = "Ошибка"
        }
        
        let calculation = Calculation(expression: expression, result: resultNumber)
        
        calculationHistory.append(calculation)
        calculationHistoryStorage.setHistory(calculationHistory)
        
        expression.removeAll()
    }
    
}

extension CalculatorViewController {
    
    func setUpResultLabel() {
        resultLabel.font = .systemFont(ofSize: 90)
        resultLabel.textColor = .label
        resultLabel.textAlignment = .right
        resultLabel.adjustsFontSizeToFitWidth = true
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            resultLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            resultLabel.bottomAnchor.constraint(equalTo: keyboardView.topAnchor, constant: -16),
        ])
    }
    
    func setUpKeyboardView() {
        keyboardView.axis = .vertical
        
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "H", titleColor: .secondaryLabel, backgroundColor: .systemGray3, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(showCalculationHistory)),
            (title: "C", titleColor: .secondaryLabel, backgroundColor: .systemGray3, widthMultiplier: 0.5, heightMultiplier: 0.13, onClick: #selector(clearResultLabel)),
            (title: Operation.divide.rawValue, titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleOperationButtonClick))
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "7", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "8", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "9", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: Operation.multiply.rawValue, titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleOperationButtonClick))
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "4", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "5", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "6", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: Operation.subtract.rawValue, titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleOperationButtonClick))
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "1", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "2", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "3", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: Operation.add.rawValue, titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleOperationButtonClick))
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: ".", titleColor: .secondaryLabel, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "0", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.5, heightMultiplier: 0.13, onClick: #selector(handleDigitOrPeriodButtonClick)),
            (title: "=", titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13, onClick: #selector(handleCalculateButtonClick))
        )
    }
    
    func setUpButton(on keyboardRow: UIStackView, withTitle title: String, withTitleColor titleColor: UIColor, withBackgroundColor backgroundColor: UIColor, withWidthMultiplier widthMultiplier: CGFloat, withHeightMultiplier heightMultiplier: CGFloat, onClick: Selector) {
        let button = UIButton()
        
        keyboardRow.addArrangedSubview(button)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(.tertiaryLabel, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = backgroundColor
        
        button.addTarget(self, action: onClick, for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: keyboardRow.widthAnchor, multiplier: widthMultiplier),
            button.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: heightMultiplier)
        ])
    }
    
    func setUpKeyboardRow(on keyboardView: UIStackView, withButtons: ButtonData...) {
        let keyboardRow = UIStackView()

        keyboardView.addArrangedSubview(keyboardRow)
        
        for buttonData in withButtons {
            setUpButton(on: keyboardRow, withTitle: buttonData.title, withTitleColor: buttonData.titleColor, withBackgroundColor: buttonData.backgroundColor, withWidthMultiplier: buttonData.widthMultiplier, withHeightMultiplier: buttonData.heightMultiplier, onClick: buttonData.onClick)
        }
    }
    
}
