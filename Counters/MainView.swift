//
//  MainView.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        RoundedNavigationView {
            Text("Help")
                .navigationBarTitle("Counters")
                .navigationBarItems(trailing: Button("Help", action: {
                    print("SND NDS")
                }))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
