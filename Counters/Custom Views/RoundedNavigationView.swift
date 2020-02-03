//
//  RoundedNavigationView.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct RoundedNavigationView<Content: View>: View {
    
    let cornerRadius: CGFloat
    let navBarColor: Color
    let content: () -> Content
    
    init(cornerRadius: CGFloat = AppearanceManager.shared.defaultNavBarCornerRadius,
         navBarColor: Color = AppearanceManager.shared.defaultNavBarColor,
         @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.navBarColor = navBarColor
        
        self.content = content
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                GeometryReader { geometry in
                    self.content()
                    
                    RoundedRectangle(cornerRadius: self.cornerRadius, style: .circular)
                        .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top, alignment: .top)
                        .edgesIgnoringSafeArea(.top)
                        .foregroundColor(.blue)
                        
                    Rectangle()
                        .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top / 2, alignment: .top)
                        .edgesIgnoringSafeArea(.top)
                        .foregroundColor(.blue)
                }
            }
        }.background(Color(.systemBackground))
    }
}
