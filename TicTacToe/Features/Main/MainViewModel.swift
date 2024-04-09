//
//  MainViewModel.swift
//  TicTacToe
//
//  Created by Вадим on 08.04.2024.
//

import Foundation
import Combine

final class MainViewModel: MainViewModelProtocol {
    @Published
    var ticTacToeDict: [String : String] = [:]
    
    @Published
    var showingWinner = false
    
    @Published
    var sign = ""
    
    func nextStep() {
        DispatchQueue.global().async {
            var allPositionArray = ["00", "01", "02", "10", "11", "12", "20", "21", "22"]
            let ticTacToePositionArray = self.ticTacToeDict.keys
            for element in ticTacToePositionArray {
                if allPositionArray.contains(element) {
                    allPositionArray.removeAll { $0 == element }
                }
            }
            if let randomElement = self.getRandomElement(from: allPositionArray) {
                DispatchQueue.main.async {
                    self.ticTacToeDict[randomElement] = "circle"
                }
            }
            if ticTacToePositionArray.count > 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    if self.checkForVictory("multiply") {
                        self.showingWinner = true
                        self.sign = "Победили крестики!!!"
                    } else if self.checkForVictory("circle") {
                        self.showingWinner = true
                        self.sign = "Победили нолики!!!"
                    } else if allPositionArray.isEmpty {
                        self.showingWinner = true
                        self.sign = "Ничья"
                    }
                }
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
