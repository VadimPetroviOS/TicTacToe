//
//  MainView.swift
//  TicTacToe
//
//  Created by Вадим on 06.04.2024.
//

import SwiftUI

struct MainView<ViewModel: MainViewModelProtocol>: View {
    @StateObject
    private var viewModel: ViewModel
    
    // MARK: - Initializing View

    init() where ViewModel == MainViewModel {
        _viewModel = StateObject(
            wrappedValue: MainViewModel()
        )
    }
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    private var contentView: some View {
        playField
    }
    
    @ViewBuilder
    private var playField: some View {
        VStack(spacing: 20) {
            ForEach(0 ..< 3, id:\.self) { row in
                HStack(spacing: 20) {
                    ForEach(0 ..< 3, id:\.self) { column in
                        Button(action: {
                            viewModel.ticTacToeDict["\(row)\(column)"] = "multiply"
                            viewModel.nextStep()
                        }) {
                            Image(systemName: viewModel.ticTacToeDict["\(row)\(column)"] ?? "")
                                .imageScale(.large)
                                .foregroundColor(.accentColor)
                                .frame(width: 50, height: 50)
                                .background(Color.yellow)
                        }
                        .alert(isPresented: $viewModel.showingWinner) {
                            Alert(
                                title: Text(viewModel.sign),
                                message: Text("Сыграем еще?"),
                                primaryButton: .default(Text("ДА")) {
                                    viewModel.ticTacToeDict = [:]
                                },
                                secondaryButton: .default(Text("НЕТ"))
                            )
                        }
                        .allowsHitTesting(
                            viewModel.isButtonActive(row,column)
                        )
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
