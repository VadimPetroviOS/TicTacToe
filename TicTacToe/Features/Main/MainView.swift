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
    
    @State private var showStartView = false
    
    // MARK: - Initializing View

    init() where ViewModel == MainViewModel {
        _viewModel = StateObject(
            wrappedValue: MainViewModel()
        )
    }
    
    var body: some View {
        contentView
            .fullScreenCover(isPresented: $showStartView) {
                StartView()
            }
    }
    
    @ViewBuilder
    private var contentView: some View {
        ZStack {
            backgroundImage
            VStack {
                Spacer()
                playField
                Spacer()
                scoreView
            }
        }
    }
    
    @ViewBuilder
    private var backgroundImage: some View {
        Image("background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private var playField: some View {
        VStack(spacing: 20) {
            ForEach(0 ..< 3, id:\.self) { row in
                HStack(spacing: 20) {
                    ForEach(0 ..< 3, id:\.self) { column in
                        Button(action: {
                            viewModel.ticTacToeDict["\(row)\(column)"] = "multiply"
                            AudioService.shared.playCrossActionSound()
                            viewModel.nextStep()
                        }) {
                            Image(systemName: viewModel.ticTacToeDict["\(row)\(column)"] ?? "")
                                .imageScale(.large)
                                .foregroundColor(.black)
                                .frame(width: 50, height: 50)
                                .background(Color.yellow)
                        }
                        .disabled(viewModel.isTimeStop)
                        .alert(isPresented: $viewModel.showingWinner) {
                            Alert(
                                title: Text(viewModel.sign),
                                message: Text("Сыграем еще?"),
                                primaryButton: .default(Text("ДА")) {
                                    viewModel.ticTacToeDict = [:]
                                },
                                secondaryButton: .default(Text("НЕТ")) {
                                    showStartView = true
                                }
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
    
    @ViewBuilder
    private var scoreView: some View {
        HStack {
            Spacer()
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text(": \(viewModel.personScore)")
                    .font(.system(size: 40))
            }
            Spacer()
            HStack {
                Image(systemName: "desktopcomputer")
                    .resizable()
                    .frame(width: 40, height: 40)
                Text(": \(viewModel.computerScore)")
                    .font(.system(size: 40))
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
