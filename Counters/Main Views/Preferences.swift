//
//  Preferences.swift
//  Counters
//
//  Created by Stefano Andriolo on 09/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct Preferences: View {
    
    @Environment(\.presentationMode) var presentation
    @State var hapticFeedbackEnabled: Bool = PreferencesManager.shared.isHapticFeedbackEnabled
    @State var requireBiometricAuthorization: Bool = PreferencesManager.shared.requiresBiometricAuthorization
    
    private func dismiss() {
        AppearanceManager.hideListSeparators()
        AppearanceManager.applyNavigationBarFix()
        AppearanceManager.setTableViewCellBackgroundColor()
        self.presentation.wrappedValue.dismiss()
    }
    
    private func finalize() {
        // write to preferences
        PreferencesManager.shared.isHapticFeedbackEnabled = self.hapticFeedbackEnabled
        PreferencesManager.shared.requiresBiometricAuthorization = self.requireBiometricAuthorization
        
        // write to disk
        PreferencesManager.shared.savePreferences(usingDataManager: DataManager.shared)
    }
    
    var doneButton: some View {
        Button(action: {
            self.finalize()
            self.dismiss()
        }) {
            Text(Localizations.preferencesViewNavBarDoneButtonLabel)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: self.$hapticFeedbackEnabled) {
                    Text(Localizations.preferencesViewHapticFeedbackToggleLabel)
                }
                
                Toggle(isOn: self.$requireBiometricAuthorization) {
                    Text(Localizations.preferencesViewBiometricAuthToggleLabel)
                }
                
                Section {
                    Text(Localizations.preferencesViewSectionFooterFlag)
                        .font(.largeTitle)
                }
            }
            .navigationBarTitle(Localizations.preferencesViewNavBarTitle, displayMode: .inline)
            .navigationBarItems(trailing: self.doneButton)
        }
        .onAppear {
            AppearanceManager.showListSeparators()
            AppearanceManager.applyNavigationBarFix(visible: true)
            AppearanceManager.setTableViewCellBackgroundColor(to: .secondarySystemBackground)
        }
    }
}

struct Preferences_Previews: PreviewProvider {
    static var previews: some View {
        Preferences()
    }
}
