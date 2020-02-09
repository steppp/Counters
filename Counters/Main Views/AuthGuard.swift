//
//  AuthGuard.swift
//  Counters
//
//  Created by Stefano Andriolo on 08/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI
import Foundation
import LocalAuthentication

struct AuthGuard: View {
    @State var authenticated: Bool = false
    @State var retryButtonVisible: Bool = false
    
    @EnvironmentObject var countersManager: CountersManager
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = NSLocalizedString(Localizations.authGuardBiometricsUsageDescription, comment: "")
            
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, authError) in
                DispatchQueue.main.async {
                    if success {
                        self.retryButtonVisible = false
                        self.authenticated = true
                    } else {
                        debugPrint("Auth failed")
                        self.retryButtonVisible = true
                        // TRY AGAIN
                    }
                }
            }
        } else {
            self.authenticated = true
            debugPrint("Biometric authentication not available")
        }
    }
    
    var body: some View {
        Group {
            if self.authenticated {
                MainView()
            } else {
                ZStack {
                    Rectangle()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .foregroundColor(Color(.systemBackground))
                        .edgesIgnoringSafeArea(.all)
                    
                    Button(action: {
                        self.authenticate()
                    }, label: {
                        Text(Localizations.authGuardRetryButtonLabel)
                    })
                }
            }
        }
        .onAppear {
            if PreferencesManager.shared.requiresBiometricAuthorization {
                self.authenticate()
            } else {
                self.authenticated = true
            }
        }
    }
}

struct AuthGuard_Previews: PreviewProvider {
    static var previews: some View {
        AuthGuard()
    }
}
