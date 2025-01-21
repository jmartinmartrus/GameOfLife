//
//  GameOfLifeApp.swift
//  GameOfLife
//
//  Created by Joan Martín i Martrus on 30/5/24.
//

import SwiftUI

@main
struct GameOfLifeApp: App {
    @StateObject private var themeManager = ThemeManager()
    let gameGridViewModel: GameGridViewModel

    init() {
        gameGridViewModel = GameGridViewModel()
    }

    var body: some Scene {
        WindowGroup {
            GameGridView(viewModel: gameGridViewModel)
                .environmentObject(themeManager)
        }
    }
}
