//
//  FinanceQuestionsManager.swift
//  SwipeDemoSwift
//
//  Created by Grzegorz Izworski on 09/06/2017.
//

import Foundation

class FinanceQuestionsManager : NSObject {
    static let sharedInstance = FinanceQuestionsManager()
    
    var currentQuestion: Int = 1
    
    var calibrationPosition = 0
    var calibrationValue = 0
    var lossAversionExitStep = 0
    var lossAversionValue = 0
    var uncertanityAversionExitStep = 0
    var uncertanityAversionValue = 0
    var emotionalExperiencePosition = 0
    var investmentTemperamentPosition = 0
    
    var data: [[String]] = [[]]

    class CalibrationQuestion {
        var currentPosition = FinanceQuestionsManager.sharedInstance.getDataElement(row: 0, column: 0)
        var currentCalibration: Int {
            for (index, row) in FinanceQuestionsManager.sharedInstance.data.enumerated() {
                if Int(row[0]) == currentPosition {
                    return FinanceQuestionsManager.sharedInstance.getDataElement(row: index, column: 1)
                }
            }
            
            return 1
         }
        
        var possiblePositions: [(Int, Int)] {
            var possiblePositions: [(exitStep: Int, exitValue: Int)] = []
            let manager = FinanceQuestionsManager.sharedInstance
            
            for row in manager.data {
                let tupleToCheck = (Int(row[0])!, Int(row[1])!)
                
                if !FinanceQuestionsManager.sharedInstance.checkTuple(tupleToCheck: tupleToCheck, theTupleArray: possiblePositions) {
                    let exitStep = Int(row[0])
                    let exitValue = Int(row[1])
                    
                    possiblePositions.append((exitStep: exitStep!, exitValue: exitValue!))
                }
            }
            
            return possiblePositions
        }
    }
    
    class LossAversionQuestion {
        
        init(calibrationPosition: Int, calibrationValue: Int) {
            FinanceQuestionsManager.sharedInstance.calibrationPosition = calibrationPosition
            FinanceQuestionsManager.sharedInstance.calibrationValue = calibrationValue
            
            FinanceQuestionsManager.sharedInstance.reduceDataTable(step: FinanceQuestionsManager.sharedInstance.calibrationPosition, stepIndex: 0)
        }
        
        var possibleExitSteps: [(Int, Int)] {
            let manager = FinanceQuestionsManager.sharedInstance
            let data = manager.data
            var possibleSteps: [(exitStep: Int, exitValue: Int)] = []
            
            for row in data {
                let tupleToCheck = (Int(row[2])!, Int(row[3])!)
                
                if !FinanceQuestionsManager.sharedInstance.checkTuple(tupleToCheck: tupleToCheck, theTupleArray: possibleSteps) {
                    let exitStep = Int(row[2])
                    let exitValue = Int(row[3])
                
                    possibleSteps.append((exitStep: exitStep!, exitValue: exitValue!))
                }
            }
            
            return possibleSteps
        }
    }
    
    class UncertanityAversionQuestion {
        
        init(lossAversionExitStep: Int, lossAversionValue: Int) {
            FinanceQuestionsManager.sharedInstance.lossAversionExitStep = lossAversionExitStep
            FinanceQuestionsManager.sharedInstance.lossAversionValue = lossAversionValue
            
            FinanceQuestionsManager.sharedInstance.reduceDataTable(step: lossAversionExitStep, stepIndex: 2)
        }
        
        var possibleExitSteps: [(Int, Int)] {
            let manager = FinanceQuestionsManager.sharedInstance
            let data = manager.data
            var possibleSteps: [(exitStep: Int, exitValue: Int)] = []
            
            for  row in data {
                let tupleToCheck = (Int(row[4])!, Int(row[5])!)
                
                if !FinanceQuestionsManager.sharedInstance.checkTuple(tupleToCheck: tupleToCheck, theTupleArray: possibleSteps) {
                    let exitStep = Int(row[4])
                    let exitValue = Int(row[5])
                
                    possibleSteps.append((exitStep: exitStep!, exitValue: exitValue!))
                }
            }
            
            return possibleSteps
        }
    }
    
    class EmotionalExperienceQuestion {
        
        init (uncertanityAversionExitStep: Int, uncertanityAversionValue: Int) {
            FinanceQuestionsManager.sharedInstance.uncertanityAversionExitStep = uncertanityAversionExitStep
            FinanceQuestionsManager.sharedInstance.uncertanityAversionValue = uncertanityAversionValue
            
            FinanceQuestionsManager.sharedInstance.reduceDataTable(step: uncertanityAversionExitStep, stepIndex: 4)
        }
        
        func getPossiblePositions() -> [Int] {
            var possiblePositions = [Int]()
            let manager = FinanceQuestionsManager.sharedInstance
            
            for (index, _) in manager.data.enumerated() {
                if !possiblePositions.contains(manager.getDataElement(row: index, column: 6)) {
                    possiblePositions.append(manager.getDataElement(row: index, column: 6))
                }
            }
            
            return possiblePositions
        }
    }
    
    class InvestmentTemperamentQuestion {
        
        init (emotionalExperiencePosition: Int) {
            FinanceQuestionsManager.sharedInstance.emotionalExperiencePosition = emotionalExperiencePosition
            
            FinanceQuestionsManager.sharedInstance.reduceDataTable(step: emotionalExperiencePosition, stepIndex: 6)
        }
        
        func getPossiblePositions() -> [Int] {
            var possiblePositions = [Int]()
            let manager = FinanceQuestionsManager.sharedInstance
            
            for (index, _) in manager.data.enumerated() {
                if !possiblePositions.contains(manager.getDataElement(row: index, column: 7)) {
                    possiblePositions.append(manager.getDataElement(row: index, column: 7))
                }
            }
            
            return possiblePositions
        }
    }
    
    func getResult(investmentTemperamentPosition: Int) -> Int {
        return getDataElement(row: investmentTemperamentPosition - 1, column: 8)
    }
    
    func getDataElement(row: Int, column: Int) -> Int {
        let data = FinanceQuestionsManager.sharedInstance.data
        
        return Int(data[row][column])!
    }
    
    func reduceDataTable(step: Int, stepIndex: Int) {
        let manager = FinanceQuestionsManager.sharedInstance
        var data = manager.data
        
        var startIndex = 0
        var endIndex = 0
        
        for (index, row) in data.enumerated() {
            if Int(row[stepIndex]) == step {
                startIndex = index
                break
            }
        }
        
        for (index, row) in data.enumerated() {
            if index + 1 == data.endIndex {
                endIndex = index
                break
            }
            
            if Int(row[stepIndex]) == step && Int(data[index + 1][stepIndex])! > step {
                endIndex = index
                break
            }
        }
        
        let reducedData = data[startIndex...endIndex]
        FinanceQuestionsManager.sharedInstance.data = Array(reducedData)
    }
    
    func checkTuple(tupleToCheck:(Int, Int), theTupleArray:[(Int, Int)]) -> Bool{
        //Iterate over your Array of tuples
        for arrayObject in theTupleArray{
            //If a tuple is the same as your tuple to check, it returns true and ends
            if arrayObject.0 == tupleToCheck.0 && arrayObject.1 == tupleToCheck.1 {
                return true
            }
        }
        
        //If no tuple matches, it returns false
        return false
    }
    
    private override init() {
        // load the data from CSV
        func csv(data: String) -> [[String]] {
            let cleanData = data.replacingOccurrences(of: "\r", with: "")
            var result: [[String]] = []
            let rows = cleanData.components(separatedBy: "\n")
            for row in rows {
                let columns = row.components(separatedBy: ";")
                result.append(columns)
            }
            return result
        }
        
        do {
            let path: String = Bundle.main.path(forResource: "table", ofType: "csv")!
            let csvString = try String(contentsOfFile: path)
            
            data = csv(data: csvString)
            
        } catch {
            print(error)
        }
        
    }
}
