//
//  MainView.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var countersManager: CountersManager
    
    @State var presentModal: Bool = false
    
    var body: some View {
        RoundedNavigationView {
            List {
                ForEach(self.countersManager.counters, id: \.self) { counter in
                    Text(counter.description)
                }
            }
            .navigationBarTitle("Counters")
            .navigationBarItems(trailing:
                Button(action: { self.presentModal.toggle() }) {
                    Image(systemName: "plus.circle.fill")
                }.sheet(isPresented: self.$presentModal, content: {
                    DetailView()
                })
            )
            .foregroundColor(.black)
            .background(Color(.systemBackground))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(CountersManager.sharedExample)
    }
}
