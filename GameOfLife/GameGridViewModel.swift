//
//  GameGridViewModel.swift
//  GameOfLife
//
//  Created by Joan Martín i Martrus on 20/1/25.
//

import Foundation
import SwiftUI

protocol GameGridViewModelType: ObservableObject {
    func cellAt(row: Int, column: Int) -> Cell
    func onTapAt(row: Int, column: Int)
    func onResumePauseButtonTap()
    func onStopButtonTap()
    func startGame()

    var dimensions: Dimensions { get }
    var isPlaying: Bool { get set }
    var generation: Int { get }
    var timeMultiplier: Double { get set }
}

@MainActor
class GameGridViewModel: ObservableObject {
    @Published var gameState: GameState = GameState()
    @Published var isPlaying: Bool = false
    @Published var timeMultiplier: Double = 1.0
    let gameStateManager: GameStateManager = GameStateManager.shared
    private let defaultTimeInMiliseconds = 1_000_000_000
}

extension GameGridViewModel: GameGridViewModelType {
    
    func cellAt(row: Int, column: Int) -> Cell {
        gameState.cellMatrix.matrix[row][column]
    }

    func onTapAt(row: Int, column: Int) {
        withAnimation {
            gameState = gameStateManager.computeTapOn(row: row,
                                                      column: column,
                                                      for: gameState)
        }
    }

    func onResumePauseButtonTap() {
        isPlaying.toggle()
    }

    func onPauseButtonTap() {
        isPlaying = false
    }

    func onStopButtonTap() {
        isPlaying = false
        gameState = GameState()
    }
    
    func startGame() {
        Task {
            while true {
                if isPlaying {
                    withAnimation {
                        gameState = gameStateManager.computeNextGeneration(currentState: gameState)
                    }
                }
                try? await Task.sleep(nanoseconds: UInt64(timeForNextStep))
            }
        }
    }

    var dimensions: Dimensions {
        gameState.dimensions
    }

    var generation: Int {
        return gameState.generation
    }
}

private extension GameGridViewModel {
    var timeForNextStep: Double {
        Double(defaultTimeInMiliseconds) / timeMultiplier
    }

}
