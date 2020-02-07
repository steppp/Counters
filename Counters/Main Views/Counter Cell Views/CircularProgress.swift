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
    
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var counter: Counter
    @State var presentModal: Bool = false
        
    var initialValueTextView: Text
    var finalValueTextView: Text
        
    init(counter: Counter) {
        self.counter = counter
        
        if PreferencesManager.shared.isHapticFeedbackEnabled {
            let hapticsCapabilities = CHHapticEngine.capabilitiesForHardware()
            
            if (hapticsCapabilities.supportsHaptics) {
                // TODO: use UINotification{Impact, Feedback}Generator
            } else {
                // TODO: use hack for iphone 6s
                // see https://medium.com/nerdmade/ios-haptic-feedback-for-iphone-7-and-6s-1bc6e7f1c285
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
            Color(AppearanceManager.getBackgroundCellColor(for: self.colorScheme))
                .cornerRadius(20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.center)
                .shadow(color: Color(.systemGray3).opacity(0.5), radius: 3, x: 0, y: 0)

            HStack {
                ZStack(alignment: .leading) {
                    ZStack {
                        ProgressCircle(counter: self.counter, colorScheme: self.colorScheme)
                        
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
                            if self.counter.getCheckpoints().isEmpty {
                                Text(Localizations.circularCounterCellNoCheckpoints)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } else {
                                ForEach(self.counter.getCheckpoints(), id: \.self) { checkpoint in
                                    Image(systemName: "pencil.circle.fill")
                                }
                            }
                        }
                        .padding()
                        
                    // TODO: animate the counter value when it changes, see https://swiftui-lab.com/swiftui-animations-part1/
                    Button(action: {
                        let res = self.counter.next()
                        print(res)
                        
                        if PreferencesManager.shared.isHapticFeedbackEnabled {
                            // TODO: release haptic feedback
                        }
                    }) {
                        Text(self.counter.step.description)
                            .font(.system(size: 30, weight: .semibold))
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 60, maxHeight: 60)
                    .background(Color(AppearanceManager.shared.getColorFor(id: self.counter.tintColor)))
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
            .environment(\.colorScheme, .light)
    }
}
