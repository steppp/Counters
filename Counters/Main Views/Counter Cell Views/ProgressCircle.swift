//
//  ProgressCircle.swift
//  Counters
//
//  Created by Stefano Andriolo on 05/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct ProgressCircle: View {
    
    @State var center: CGPoint = CGPoint.zero
    @ObservedObject var counter: Counter
    
    var colors: [Color]
    var startAngle: Angle
    var endAngle: Angle

    init(counter: Counter, colors: [Color]? = nil) {
        self.counter = counter
        
        let cols: [Color]
        if let unwrappedColors = colors {
            cols = unwrappedColors
        } else {
            cols = [counter.tintColor, Color(AppearanceManager.shared.mainViewCellBackgroundColor)]
        }
        
        if counter.step > 0 {
            self.colors = cols
            self.startAngle = Angle(degrees: -180)
            self.endAngle = Angle(degrees: 50)
        } else {
            self.colors = cols.reversed()
            self.startAngle = Angle(degrees: -225)
            self.endAngle = Angle(degrees: -35)
        }
    }
    
    // TODO: - make the open circular path increase its lenght towards the maximum value when it is set and a step is performed, see also https://www.simpleswiftguide.com/how-to-build-a-circular-progress-bar-in-swiftui/

    var body: some View {
        GeometryReader { geometry in
            Group {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(AngularGradient(gradient: Gradient(colors: self.colors), center: .center, startAngle: self.startAngle, endAngle: self.endAngle))
                    .mask(
                        Path { path in
                            path.addArc(center: self.center, radius: self.optimalCircleRadius(screenSize: geometry.size), startAngle: Angle(degrees: 135), endAngle: Angle(degrees: 45), clockwise: false)
                        }
                        .strokedPath(.init(lineWidth: 10, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [], dashPhase: 0))
                )
                    
                
            }
            .onAppear(perform: {
                self.center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
            })
        }
    }
    
    func optimalCircleRadius(screenSize: CGSize) -> CGFloat {
        let minDimension = min(screenSize.width, screenSize.height)
        return (minDimension / 2) - (minDimension * 0.1)
    }
}

struct ProgressCircle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircle(counter: Counter.exampleCircularCounter)
    }
}
