//
//  GameStateManager.swift
//  GameOfLife
//
//  Created by Joan Martín i Martrus on 30/5/24.
//

import Foundation
import SwiftUI

class GameStateManager {
    static let shared = GameStateManager()

    private init() { }

    func computeNextGeneration(currentState: GameState) -> GameState {
        var newCellMatrix = CellMatrix(dimensions: currentState.dimensions)

        currentState.cellMatrix.matrix.flatMap { $0 }.forEach { cell in
            let newState = computeNextGenerationState(state: cell.state,
                                                      liveNeighbours: countLiveNeighbours(gameState: currentState,
                                                                                          row: cell.row,
                                                                                          column: cell.column))
            let newCell = Cell(state: newState, row: cell.row, column: cell.column)
            newCellMatrix.matrix[cell.row][cell.column] = newCell
        }
        return GameState(cellMatrix: newCellMatrix, generation: currentState.generation + 1)
    }

    func computeTapOn(row: Int, column: Int, for currentState: GameState) -> GameState {
        currentState.toogleCell(row: row, column: column)
        return currentState
    }

    private func countLiveNeighbours(gameState: GameState, row: Int, column: Int) -> Int {
        let directions = [
            (-1,-1), (-1,0), (-1,1),
            (0,-1),          (0,1),
            (1,-1), (1,0), (1,1)
        ]

        var liveNeighboursCounter = 0

        for direction in directions {
            let newRow = row + direction.0
            let newCol = column + direction.1

            if newRow >= 0 && newRow < gameState.dimensions.rows && newCol >= 0 && newCol < gameState.dimensions.columns {
                if gameState.cellMatrix.matrix[newRow][newCol].state == .live {
                    liveNeighboursCounter += 1
                }
            }
        }

        return liveNeighboursCounter
    }

    private func computeNextGenerationState(state: CellState, liveNeighbours: Int) -> CellState {
        switch state {
        case .live:
            if liveNeighbours < 2 {
                return .dead
            } else if liveNeighbours <= 3 {
                return .live
            } else {
                return .dead
            }
        case .dead:
            if liveNeighbours == 3 {
                return .live
            } else {
                return .dead
            }
        }
    }
}
