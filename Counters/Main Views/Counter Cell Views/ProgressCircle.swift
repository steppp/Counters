//
//  ProgressCircle.swift
//  Counters
//
//  Created by Stefano Andriolo on 05/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct ProgressCircle: View {
    
    @State var colScheme: ColorScheme
    @State var center: CGPoint = CGPoint.zero
    @ObservedObject var counter: Counter
    
    var colors: [Color]
    var startAngle: Angle
    var endAngle: Angle

    init(counter: Counter, colors: [Color]? = nil, colorScheme: ColorScheme) {
        self.counter = counter
        self.colors = []
        self.startAngle = Angle.zero
        self.endAngle = Angle.zero
        
        let cols: [Color]
        if let unwrappedColors = colors {
            cols = unwrappedColors
        } else {
            let backgroundColor = AppearanceManager.getBackgroundCellColor(for: colorScheme)
            let tintColor = Color(AppearanceManager.shared.getColorFor(id: counter.tintColor))
            cols = [tintColor, Color(backgroundColor)]
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
        
        // see https://stackoverflow.com/questions/58758370/how-could-i-initialize-the-state-variable-in-the-init-function-in-swiftui
        self._colScheme = .init(initialValue: colorScheme)
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
        ProgressCircle(counter: Counter.exampleCircularCounter, colorScheme: .light)
    }
}
