//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by In Taek Cho on 2020-09-07.
//  Copyright © 2020 IMCHO. All rights reserved.
//

import Foundation

//func multiply(op1: Double, op2: Double) -> Double {
//    return op1 * op2
//}

class CalculatorBrain {
    private var accumlator: Double = 0.0
    private var internalProgram = [Any]()
    
    func setOperand(operand: Double) {
        accumlator = operand
        internalProgram.append(operand)
    }
    
    func addUnaryOperation(symbol: String, operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.UnaryOperation(operation)
    }
    private var operations: Dictionary<String,Operation/*Double*/> = [
        "π" : Operation.Constant(Double.pi), // Double.pi,
        "e" : Operation.Constant(M_E), // M_E,
        "√" : Operation.UnaryOperation(sqrt), // sqrt
        "✕" : Operation.BinaryOperation { $0 * $1 },
        "÷" : Operation.BinaryOperation { $0 / $1 },
        "+" : Operation.BinaryOperation { $0 + $1 },
        "-" : Operation.BinaryOperation { $0 - $1 },
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
//        switch symbol {
//        case "π":
//            accumlator = Double.pi
//        case "√":
//            accumlator = sqrt(accumlator)
//        default:
//            break
//        }
        
//        if let constant = operations[symbol] {
//            accumlator = constant
//        }
        
        if let operation = operations[symbol] {
            internalProgram.append(symbol)
            switch operation {
            case .Constant(let associatedConstantValue):
                accumlator = associatedConstantValue
            case .UnaryOperation(let function):
                accumlator = function(accumlator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFuction: function, firstOperand: accumlator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumlator = pending!.binaryFuction(pending!.firstOperand, accumlator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFuction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = Any
    var program: PropertyList {
        get {
            return internalProgram
        }
        
        set {
            clear()
            if let arrayOfOps = newValue as? [Any] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumlator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumlator
        }
    }
}
