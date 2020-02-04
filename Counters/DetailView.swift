//
//  DetailView.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    let counter: Counter?
    var navBarTitle: Text {
        if let _ = self.counter {
            return Text(Localizations.detailViewNavBarTitleEdit)
        }
        
        return Text(Localizations.detailViewNavBarTitleAdd)
    }
    
    @Environment(\.presentationMode) var presentation
    
    init(counter: Counter? = nil) {
        self.counter = counter
    }
    
    var doneButton: some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
        }) {
            Text(Localizations.detailViewNavBarButtonsDone)
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if self.counter == nil {
                    Text(Localizations.detailViewContentNoCounterSelected)
                        .fontWeight(.semibold)
                } else {
                    Text(counter!.description)
                        .fontWeight(.semibold)
                }
            }
            .navigationBarItems(trailing: self.doneButton)
            .navigationBarTitle(self.navBarTitle, displayMode: .inline)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView().environment(\.locale, .init(identifier: "en"))
    }
}
