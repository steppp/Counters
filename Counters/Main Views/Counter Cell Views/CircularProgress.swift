//
//  CircularProgress.swift
//  Counters
//
//  Created by Stefano Andriolo on 04/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI
import UIKit
import CoreHaptics

struct CircularProgress: View {
    
    @ObservedObject var counter: Counter
    @State var presentModal: Bool = false
    
    var hapticPlayer: CHHapticPatternPlayer?
    
    var initialValueTextView: Text
    var finalValueTextView: Text
        
    init(counter: Counter) {
        self.counter = counter
        
        let hapticsCapabilities = CHHapticEngine.capabilitiesForHardware()
        print(hapticsCapabilities.supportsHaptics)
        
        if PreferencesManager.shared.isHapticFeedbackEnabled {
            do {
                let hapticEngine = try CHHapticEngine()
                try hapticEngine.start()
                
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
                ], relativeTime: 0)
                let pattern = try CHHapticPattern(events: [event], parameters: [])
                self.hapticPlayer = try hapticEngine.makePlayer(with: pattern)
            } catch {
                print("Cannot create haptic engine/player")
            }
        }
        
        self.initialValueTextView = Text("\(counter.initialValue)").font(.system(size: 20, weight: .semibold))
        
        if counter.finalValue == nil {
            self.finalValueTextView = Text(Localizations.circularCounterCellFinalValueAbsent)
                .font(.system(size: 20, weight: .semibold))
        } else {
            self.finalValueTextView = Text("\(counter.finalValue!.description)")
                .font(.system(size: 20, weight: .semibold))
        }
    }

    var body: some View {
        ZStack {
            Color(AppearanceManager.shared.mainViewCellBackgroundColor)
                .cornerRadius(20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.center)
                .shadow(color: Color(.systemGray).opacity(0.5), radius: 3, x: 0, y: 0)

            HStack {
                ZStack(alignment: .leading) {
                    ZStack {
                        ProgressCircle(counter: self.counter)
                        
                        Text(verbatim: self.counter.currentValue.description)
                            .font(Font.system(size: 40, weight: .bold))
                    }
                    
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            if self.counter.step > 0 {
                                self.initialValueTextView
                                
                                Spacer()
                                
                                self.finalValueTextView
                            } else {
                                self.finalValueTextView
                                
                                Spacer()
                                
                                self.initialValueTextView
                            }
                            
                            Spacer()
                        }
                    }
                    
                }
                
                VStack(alignment: .trailing) {
                    Text(self.counter.name)
                        .font(Font.system(size: 20))
                        .fontWeight(.semibold)
                        .padding(.trailing, 8)
                        
                        HStack {
                            if self.counter.getActiveCheckpoints().isEmpty {
                                Text(Localizations.circularCounterCellNoCheckpoints)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(self.counter.getActiveCheckpoints(), id: \.self) { checkpoint in
                                    Image(systemName: "pencil.circle.fill")
                                }
                            }
                        }
                        .padding()
                        
                    
                    Button(action: {
                        let res = self.counter.next()
                        print(res)
                        
                        if PreferencesManager.shared.isHapticFeedbackEnabled {
                            do {
                                try self.hapticPlayer?.start(atTime: CHHapticTimeImmediate)
                            } catch {
                                print("Cannot start haptic player")
                            }
                        }
                    }) {
                        Text(self.counter.step.description)
                            .font(.system(size: 30, weight: .semibold))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 60, maxHeight: 60)
                    .background(self.counter.tintColor)
                    .foregroundColor(.white)
                    .cornerRadius(CGFloat(20))
                    .padding(.init(top: 8, leading: 20, bottom: 0, trailing: 8))
                    .buttonStyle(PlainButtonStyle())
                    
                    ZStack(alignment: .trailing) {
                        Button(action: {
                            self.presentModal.toggle()
                        }) {
                            HStack {
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 5, height: 5, alignment: .center)
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 5, height: 5, alignment: .center)
                                Circle()
                                    .fill(Color(.systemGray4))
                                    .frame(width: 5, height: 5, alignment: .center)
                            }
                        }
                        .frame(width: 50, height: 30, alignment: .center)
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 8))
                    .sheet(isPresented: self.$presentModal) {
                        DetailView(counter: self.counter)
                    }
                }
            }
            .padding(8)
        }
    }

}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(counter: Counter.exampleCircularCounter)
    }
}
