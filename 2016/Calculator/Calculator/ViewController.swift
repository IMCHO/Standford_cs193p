//
//  ViewController.swift
//  Calculator
//
//  Created by In Taek Cho on 2020-09-03.
//  Copyright © 2020 IMCHO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var userIsInTheMiddleOfTyping: Bool = false
    
    @IBOutlet private weak var display: UILabel!
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
//        print(digit ?? 0)
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(operand: displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathmaticalSymbol = sender.currentTitle {
//            if mathmaticalSymbol == "π" {
////                display.text = String(M_PI)
//                displayValue = Double.pi
//            } else if mathmaticalSymbol == "√" {
//                displayValue = sqrt(displayValue)
//            }
            brain.performOperation(symbol: mathmaticalSymbol)
        }
        displayValue = brain.result
    }
}

