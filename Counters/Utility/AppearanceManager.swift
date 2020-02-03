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
    
    
    // MARK: - Default values constants
    
    final let defaultNavBarColor = Color(UIColor.systemRed)
    final let defaultNavBarCornerRadius = CGFloat(20)
    
    
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
}
