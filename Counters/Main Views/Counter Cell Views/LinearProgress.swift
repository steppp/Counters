//
//  LinearProgress.swift
//  Counters
//
//  Created by Stefano Andriolo on 04/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct LinearProgress: View {
    let counter: Counter

    var body: some View {
        HStack {
            Text(self.counter.description)
            
            Spacer()

            Circle()
                .fill(Color(AppearanceManager.shared.getColorFor(id: self.counter.tintColor)))
        }
    }
}

struct LinearProgress_Previews: PreviewProvider {
    static var previews: some View {
        LinearProgress(counter: Counter.exampleLinearCounter)
    }
}
