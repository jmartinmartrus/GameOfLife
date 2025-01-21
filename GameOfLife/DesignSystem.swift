//
//  DesignSystem.swift
//  GameOfLife
//
//  Created by Joan Martín i Martrus on 21/1/25.
//

import Foundation
import SwiftUI
import Combine

class ThemeManager: ObservableObject {

    @Published var theme: Theme

    private var cancellables: [AnyCancellable] = []

    init() {
        theme = Theme(rawValue: UserDefaults.standard.integer(forKey: "theme")) ?? .clear
        $theme.sink { theme in
            UserDefaults.standard.setValue(theme.rawValue, forKey: "theme")
        }.store(in: &cancellables)
    }

    func switchTo(theme: Theme) {
        withAnimation {
            self.theme = theme
        }
    }
}

enum Theme: Int, CaseIterable {

    case clear
    case dark
    case warmBreeze
    case warmSerenity

    var primaryColor: Color {
        switch self {
        case .clear:
            Color.black
        case .dark:
            Color.white
        case .warmBreeze:
            Color.smoothOrange
        case .warmSerenity:
            Color.warmDarkGray
        }
    }

    var secondaryColor: Color {
        switch self {
        case .clear:
            Color.white
        case .dark:
            Color.black
        case .warmBreeze:
            Color.lightBlue
        case .warmSerenity:
            Color.beige
        }
    }

    var separatorColor: Color {
        switch self {
        case .clear:
            Color.darkGray
        case .dark:
            Color.lightGray
        case .warmBreeze:
            Color.smoothGray
        case .warmSerenity:
            Color.coral
        }
    }

    var textPrimaryColor: Color {
        switch self {
        case .warmBreeze:
            return Color.black
        default:
            return primaryColor
        }
    }
    var backgroundColor: Color {
        switch self {
        case .warmBreeze:
            return Color.white
        default:
            return secondaryColor
        }
    }
}

extension Theme: Identifiable {
    var id: Int {
        self.rawValue
    }
}
