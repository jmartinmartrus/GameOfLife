//
//  ContentView.swift
//  GameOfLife
//
//  Created by Joan Martín i Martrus on 30/5/24.
//

import SwiftUI

struct GameGridView<ViewModel: GameGridViewModelType>: View {

    @EnvironmentObject var themeManager: ThemeManager

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    ThemeSelector()
                        .padding(.horizontal)
                    HStack {
                        Text("x\(viewModel.timeMultiplier, specifier: "%.2f")")
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(themeManager.theme.textPrimaryColor)
                        Slider(value: $viewModel.timeMultiplier,
                               in: 0.5...10.0)
                        Spacer()
                        Text("Generation: \(viewModel.generation)")
                            .font(.system(size: 12))
                            .minimumScaleFactor(0.5)
                            .foregroundStyle(themeManager.theme.textPrimaryColor)
                            .padding()
                            .border(themeManager.theme.textPrimaryColor, width: 1)
                            .padding()
                    }
                    PixelsGrid(viewModel: viewModel)
                }
            }.scrollDisabled(true)
            VStack {
                Spacer()
                HStack(spacing: 16) {
                    Spacer()
                    Button {
                        viewModel.onResumePauseButtonTap()
                    } label: {
                        Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                            .foregroundColor(themeManager.theme.primaryColor)
                    }
                    Button {
                        viewModel.onStopButtonTap()
                    } label: {
                        Image(systemName: "stop.fill")
                            .foregroundColor(themeManager.theme.primaryColor)
                    }
                    Spacer()
                }

            }
        }
        .background(themeManager.theme.backgroundColor)
        .onAppear {
            viewModel.startGame()
        }
    }
}


struct PixelsGrid<ViewModel: GameGridViewModelType>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        Grid(alignment: .center, 
             horizontalSpacing: 0,
             verticalSpacing: 0) {
            ForEach(0..<viewModel.dimensions.rows, 
                    id: \.self) { row in
                PixelsRow(viewModel: viewModel,
                          row: row)
            }
        }
    }
}

struct PixelsRow<ViewModel: GameGridViewModelType>: View {

    @ObservedObject var viewModel: ViewModel

    let row: Int

    var body: some View {
        GridRow {
            ForEach(0..<viewModel.dimensions.columns,
                    id: \.self) { column in
                PixelView(viewModel: viewModel, 
                          row: row,
                          column: column)
            }
        }
    }
}

struct PixelView<ViewModel: GameGridViewModelType>: View {

    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: ViewModel

    let row: Int
    let column: Int

    var cell: Cell {
        viewModel.cellAt(row: row, 
                         column: column)
    }

    var body: some View {
        Rectangle()
            .aspectRatio(1.0, contentMode: .fill)
            .border(themeManager.theme.separatorColor, width: 1)
            .foregroundColor(cell.state.associatedColor(theme: themeManager.theme))
            .onTapGesture {
                viewModel.onTapAt(row: row,
                                  column: column)
            }
    }
}

struct ThemeSelector: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        HStack {
            Spacer()
            ForEach(Theme.allCases) { theme in
                Button(action: {
                    themeManager.switchTo(theme: theme)
                }, label: {
                    ZStack(alignment: .center) {
                        Circle()
                        .fill(theme.secondaryColor)
                        .stroke(theme.separatorColor, lineWidth: 1)
                        .shadow(color: theme.separatorColor,
                                    radius: 3)
                        if theme == themeManager.theme {
                            Image(systemName: "checkmark")
                                .foregroundStyle(theme.primaryColor)
                        }
                    }
                })
                .frame(width: 36, height: 36)
            }
        }
    }
}

#Preview {
    GameGridView(viewModel: GameGridViewModel())
}
