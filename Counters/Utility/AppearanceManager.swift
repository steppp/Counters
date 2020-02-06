//
//  AppearanceUtility.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI
import UIKit

class AppearanceManager {
    static let shared = AppearanceManager()
    
    static var listsHaveSeparators = true
    static let defaultTableViewSeparatorColor: UIColor = .gray
    static var applicationAccentColor = TintColorId.systemBlue
    
    
    // MARK: - Default values constants
    
    final let defaultNavBarColor = Color(UIColor.systemRed)
    final let defaultNavBarCornerRadius = CGFloat(20)
    final let defaultTableViewBackgroundColor = UIColor.systemBackground
    final let defaultTableViewCellBackgroundColor = UIColor.systemBackground
    
    final let defaultCounterCellVisualizationMode: CounterCellVisualizationMode = .compact
    final let defaultCounterCellColor = AppearanceManager.applicationAccentColor
    // TODO: set and use the accent color for the entire app somewhere
    final let mainViewCellBackgroundColorLight = UIColor.white
    final let mainViewCellBackgroundColorDark = UIColor.secondarySystemBackground
    
    final let possibleCounterTintColors: [TintColorId] = [
        .systemRed, .systemBlue, .systemGray, .systemGreen,
        .systemPink, .systemPurple, .systemTeal, .systemOrange,
        .systemIndigo, .systemYellow
    ]
    
    final func getColorFor(id: TintColorId) -> UIColor {
        switch id {
        case .systemBlue:
            return .systemBlue
        case .systemYellow:
            return .systemYellow
        case .systemRed:
            return .systemRed
        case .systemIndigo:
            return .systemIndigo
        case .systemOrange:
            return .systemOrange
        case .systemTeal:
            return .systemTeal
        case .systemGreen:
            return .systemGreen
        case .systemPurple:
            return .systemPurple
        case .systemPink:
            return .systemPink
        case .systemGray:
            return .systemGray
        }
    }
    
    
    // MARK: - Static methods
    
    /// Apply the fix to get a transparent Nav Bar
    /// - Parameter prefs: preferences to customize how the Nav Bar should be styled
    static func applyNavigationBarFix(prefs: Any? = nil) {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
    }
    
    /// Toggles list separators between UITableViews' cells
    static func toggleListSeparators() {
        self.listsHaveSeparators.toggle()
        
        UITableView.appearance().separatorColor = self.listsHaveSeparators ? self.defaultTableViewSeparatorColor : .clear
    }
    
    static func setTableViewBackgroundColor(to color: UIColor = AppearanceManager.shared.defaultTableViewBackgroundColor) {
        UITableView.appearance().backgroundColor = color
    }
    
    static func setTableViewCellBackgroundColor(to color: UIColor = AppearanceManager.shared.defaultTableViewCellBackgroundColor) {
        UITableViewCell.appearance().backgroundColor = color
    }
    
    static func getBackgroundCellColor(for scheme: ColorScheme) -> UIColor {        
        if scheme == .light {
            return shared.mainViewCellBackgroundColorLight
        }
        
        return shared.mainViewCellBackgroundColorDark
    }
}

enum CounterCellVisualizationMode: String, Equatable, CaseIterable {
    case circularProgress, linearProgress, compact
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.rawValue) }
}

enum TintColorId: String, Equatable, CaseIterable {
    case systemRed, systemBlue, systemGray, systemGreen,
        systemPink, systemPurple, systemTeal, systemOrange,
        systemIndigo, systemYellow
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.rawValue) }
    
}
