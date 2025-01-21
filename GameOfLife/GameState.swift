//
//  GameState.swift
//  GameOfLife
//
//  Created by Joan Martín i Martrus on 30/5/24.
//

import Foundation
import SwiftUI

class GameState {
    let dimensions: Dimensions
    var cellMatrix: CellMatrix
    var generation: Int

    init() {
        let dimensions = Dimensions(rows: 60, columns: 30)
        self.dimensions = dimensions
        cellMatrix = CellMatrix(dimensions: dimensions)
        generation = 0
    }

    init(cellMatrix: CellMatrix, generation: Int) {
        let dimensions = cellMatrix.dimensions
        self.dimensions = dimensions
        self.cellMatrix = cellMatrix
        self.generation = generation
    }

    func toogleCell(row: Int, column: Int) {
        guard row < dimensions.rows, column < dimensions.columns else { return }
        cellMatrix.toogleCell(row: row, column: column)
    }
}

struct Dimensions {
    let rows: Int
    let columns: Int
}

struct CellMatrix {
    let dimensions: Dimensions
    var matrix: [[Cell]]

    init(dimensions: Dimensions) {
        self.dimensions = dimensions
        matrix = []
        for row in 0..<dimensions.rows {
            matrix.append([])
            for column in 0..<dimensions.columns {
                matrix[row].append(Cell(state: .dead, row: row, column: column))
            }
        }
    }

    mutating func toogleCell(row: Int,
                     column: Int) {
        matrix[row][column].toogle()
    }
}

struct Cell {
    var state: CellState

    let row: Int
    let column: Int

    mutating func toogle() {
        switch state {
        case .live:
            state = .dead
        case .dead:
            state = .live
        }
    }
}

enum CellState {
    case live
    case dead

    func associatedColor(theme: Theme) -> Color{
        switch self {
        case .live:
            theme.primaryColor
        case .dead:
            theme.secondaryColor
        }
    }
}



