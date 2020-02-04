//
//  CircularProgress.swift
//  Counters
//
//  Created by Stefano Andriolo on 04/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct CircularProgress: View {
    let counter: Counter

    var body: some View {
        HStack {
            VStack {
                ZStack {
                    Circle()
                        .stroke(self.counter.tintColor, style: .init(lineWidth: CGFloat(6), lineCap: .round, lineJoin: .round, miterLimit: CGFloat(0), dash: [], dashPhase: CGFloat(0)))
                        .padding(8)
                    
                    Text(verbatim: self.counter.currentValue.description)
                        .font(Font.system(size: 40, weight: .bold))
                }
                
                HStack {
                    Spacer()
                    
                    Text("\(self.counter.initialValue)")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Spacer()
                    
                    if self.counter.finalValue == nil {
                        Text(Localizations.circularCounterCellFinalValueAbsent)
                            .font(.system(size: 20, weight: .semibold))
                    } else {
                        Text("\(self.counter.finalValue!.description)")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            Spacer()
            
            VStack {
                Text(self.counter.name)
                    .font(.system(size: 30, weight: .semibold))
                
                Button(action: {
                    print(self.counter.step.description)
                }) {
                    Text(self.counter.step.description)
                        .font(.system(size: 30, weight: .semibold))
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 80, maxHeight: 80)
                .background(self.counter.tintColor)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding()
            }
        }
    .padding(8)
    .overlay(
        RoundedRectangle(cornerRadius: 30, style: .circular)
            .stroke(Color.black, lineWidth: 3)
        )
    }
}

struct CircularProgress_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgress(counter: Counter.exampleCircularCounter)
    }
}
