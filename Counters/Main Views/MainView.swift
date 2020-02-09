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
    @State var presentPreferencesModal: Bool = false
    @State var presentCounterModal: Bool = false
    
    var body: some View {
        RoundedNavigationView {
            List {
                ForEach(self.countersManager.counters, id: \.self) { counter in
                    ZStack {
                        Group {
                            if counter.visualizationMode == .circularProgress {
                                CircularProgress(counter: counter)
                            } else if counter.visualizationMode == .linearProgress {
                                LinearProgress(counter: counter)
                            } else {    // compact
                                Compact(counter: counter)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Counters")
            .navigationBarItems(leading: Button(action: {
                self.presentPreferencesModal = true
                self.presentCounterModal = false
                self.presentModal.toggle()
                }) {
                    Image(systemName: "gear")
                        .font(.title)
                        .foregroundColor(Color(.label))
                }, trailing: Button(action: {
                    self.presentPreferencesModal = false
                    self.presentCounterModal = true
                    self.presentModal.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(Color(.label))
                }.sheet(isPresented: self.$presentModal, content: {
                    Group {
                        if self.presentCounterModal {
                            DetailView()
                        } else {
                            if self.presentPreferencesModal {
                                Preferences()
                            }
                        }
                    }
                })
            )
            .background(Color(.systemBackground))
            .padding(.top, 8)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(CountersManager.sharedExample)
            .environment(\.colorScheme, .dark)
    }
}
