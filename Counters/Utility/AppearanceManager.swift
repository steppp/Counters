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
    
    
    // MARK: - Default values constants
    
    final let defaultNavBarColor = Color(UIColor.systemRed)
    final let defaultNavBarCornerRadius = CGFloat(20)
    
    final let defaultCounterCellVisualizationMode: CounterCellVisualizationMode = .compact
    final let defaultCounterCellColor = Color.accentColor
    // TODO: set and use the accent color for the entire app somewhere
    final let mainViewCellBackgroundColor = UIColor.white
    
    
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
    
    static func setTableViewBackgroundColor(to color: UIColor) {
        UITableView.appearance().backgroundColor = color
        UITableViewCell.appearance().backgroundColor = color
    }
}

enum CounterCellVisualizationMode: String {
    case circularProgress, linearProgress, compact
}
