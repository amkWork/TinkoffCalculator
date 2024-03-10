//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Airat K on 10/3/2024.
//

import UIKit


typealias ButtonData = (
    title: String,
    titleColor: UIColor,
    backgroundColor: UIColor,
    widthMultiplier: CGFloat,
    heightMultiplier: CGFloat
)


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setUpKeyboardView()
    }
    
    @objc
    func handleAnyButtonClick(sender: UIButton) {
        print(sender.titleLabel!.text!)
    }

}

extension ViewController {
    
    func setUpKeyboardView() {
        let keyboardView = UIStackView()

        view.addSubview(keyboardView)
        
        keyboardView.axis = .vertical
        
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            keyboardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "C", titleColor: .secondaryLabel, backgroundColor: .systemGray3, widthMultiplier: 0.75, heightMultiplier: 0.13),
            (title: "/", titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13)
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "7", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "8", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "9", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "x", titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13)
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "4", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "5", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "6", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "−", titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13)
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: "1", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "2", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "3", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "+", titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13)
        )
        setUpKeyboardRow(on: keyboardView, withButtons:
            (title: ",", titleColor: .secondaryLabel, backgroundColor: .systemGray4, widthMultiplier: 0.25, heightMultiplier: 0.13),
            (title: "0", titleColor: .label, backgroundColor: .systemGray4, widthMultiplier: 0.5, heightMultiplier: 0.13),
            (title: "=", titleColor: .systemGray5, backgroundColor: .systemBlue, widthMultiplier: 0.25, heightMultiplier: 0.13)
        )
    }
    
    func setUpButton(on keyboardRow: UIStackView, withTitle title: String, withTitleColor titleColor: UIColor, withBackgroundColor backgroundColor: UIColor, withWidthMultiplier widthMultiplier: CGFloat, withHeightMultiplier heightMultiplier: CGFloat) {
        let button = UIButton()
        
        keyboardRow.addArrangedSubview(button)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(.tertiaryLabel, for: .highlighted)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = backgroundColor
        
        button.addTarget(self, action: #selector(handleAnyButtonClick), for: .touchUpInside)
        
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
            setUpButton(on: keyboardRow, withTitle: buttonData.title, withTitleColor: buttonData.titleColor, withBackgroundColor: buttonData.backgroundColor, withWidthMultiplier: buttonData.widthMultiplier, withHeightMultiplier: buttonData.heightMultiplier)
        }
    }
    
}
