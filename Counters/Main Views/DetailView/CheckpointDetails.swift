//
//  CheckpointDetails.swift
//  Counters
//
//  Created by Stefano Andriolo on 07/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct CheckpointDetails: View {
    var checkpoint: Checkpoint
    
    @State var action: CheckpointAction
    @State var actionType: ActionType
    @State var triggerType: TriggerType
    @State var targetValue: String
    
    @Environment(\.presentationMode) var presentation
    
    private var actionLocalizedKeys: [LocalizedStringKey] = [
        PlaySoundAction.localizedActionType,
        IncrementCounterAction.localizedActionType,
        DeleteCounterAction.localizedActionType,
        ShowAlertAction.localizedActionType
    ]
    
    init(checkpoint: Checkpoint) {
        self._action = .init(wrappedValue: checkpoint.action)
        self._actionType = .init(wrappedValue: checkpoint.action.actionType)
        self._triggerType = .init(wrappedValue: checkpoint.triggerType)
        self._targetValue = .init(wrappedValue: checkpoint.targetValue.description)
        
        self.checkpoint = checkpoint
    }
    
    var body: some View {
        Form {
            Section(header: Text("Action settings")) {
                Picker(selection: self.$actionType, label: Text("Action Type")) {
                    ForEach(ActionType.allCases, id: \.self) { type in
                        Text(type.localizedName)
                    }
                }
            }
            
            Section(header: Text("Trigger condition")) {
                Picker(selection: self.$triggerType, label: Text("Trigger type")) {
                    ForEach(TriggerType.allCases, id: \.self) { type in
                        Text(type.localizedName)
                    }
                }
                
                InputAccessoryTextField(text: self.$targetValue, placeholder: "Target Value")
                    .keyboardType(.numberPad)
            }
            
            Section {
                Button(action: {
                    // TODO: delete checkpoint from the counter
                    self.presentation.wrappedValue.dismiss()
                }) {
                    Text(Localizations.checkpointDetailDeleteCounterLabel)
                }
                .foregroundColor(Color(.systemRed))
            }
        }
    }
}

struct CheckpointDetails_Previews: PreviewProvider {
    static var previews: some View {
        CheckpointDetails(checkpoint: Checkpoint.example)
    }
}
