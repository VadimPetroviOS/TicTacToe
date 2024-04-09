//
//  MainViewModel.swift
//  TicTacToe
//
//  Created by Вадим on 08.04.2024.
//

import Foundation

final class MainViewModel: MainViewModelProtocol {
    @Published
    var ticTacToeDict: [String : String] = [:]
    
    @Published
    var showingWinner = false
    
    @Published
    var sign = ""
    
    func nextStep() {
        var allPositionArray = ["00", "01", "02", "10", "11", "12", "20", "21", "22"]
        let ticTacToePositionArray = ticTacToeDict.keys
        for element in ticTacToePositionArray {
            if allPositionArray.contains(element) {
                allPositionArray.removeAll { $0 == element }
            }
        }
        if let randomElement = getRandomElement(from: allPositionArray) {
                self.ticTacToeDict[randomElement] = "circle"
            if ticTacToePositionArray.count > 4 {
                if checkForVictory("cirle") {
                    showingWinner = true
                    sign = "нолики"
                }
            }
        }
        if ticTacToePositionArray.count > 4 {
            if checkForVictory("multiply") {
                showingWinner = true
                sign = "крестики"
            }
        }
    }
    
    private func getRandomElement(from array: [String]) -> String? {
        return array.randomElement()
    }
    
    private func checkForVictory(_ value: String) -> Bool {
        let ticTacToePositionArray = ticTacToeDict.filter { $0.value == value }.map { $0.key }
        let winPositions = [["00", "01", "02"], ["10", "11", "12"], ["20", "21", "22"], ["00", "10", "20"], ["01", "11", "21"], ["02", "12", "22"], ["00", "11", "22"], ["02", "11", "20"]]
            
        for position in winPositions {
            if Set(position).isSubset(of: ticTacToePositionArray) {
                return true
            }
        }
        
        return false
    }
}
