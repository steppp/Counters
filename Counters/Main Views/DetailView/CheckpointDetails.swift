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
    @State var actionTargetCounter: CounterCore
    
    @State var triggerType: TriggerType
    @State var targetValue: String
    
    @State var soundName: String
    
    @State var alertTitle: String
    @State var alertDescription: String
    
    @Environment(\.presentationMode) var presentation
    
    init(checkpoint: Checkpoint) {
        self._action = .init(wrappedValue: checkpoint.action)
        self._actionType = .init(wrappedValue: checkpoint.action.actionType)
        self._actionTargetCounter = .init(wrappedValue: checkpoint.action.counter)
        
        self._triggerType = .init(wrappedValue: checkpoint.triggerType)
        self._targetValue = .init(wrappedValue: checkpoint.targetValue.description)
        
        self._soundName = .init(wrappedValue: PreferencesManager.defaultSoundName)
        
        self._alertTitle = .init(wrappedValue: "")
        self._alertDescription = .init(wrappedValue: "")
        
        self.checkpoint = checkpoint
    }
    
    var body: some View {
        Form {
            // MARK: rows marked with 💩 are needed because of SwiftUI sheningangs
            Section(header: Text("Action settings")) {
                Picker(selection: self.$actionType, label: Text("Action Type")) {
                    ForEach(ActionType.allCases, id: \.self) { type in
                        Text(type.localizedName)
                    }
                }
                
                Group {
                    Picker(selection: self.$actionTargetCounter, label: Text("Target Counter")) {
                        ForEach(CountersManager.shared.counters, id: \.self) { counter in
                            Text(counter.name)
                        }
                    }.disabled(self.actionType != .incrementCounterAction &&        // 💩
                        self.actionType != .deleteCounterAction)                    // 💩
                }
            
                Group {
                    Picker(selection: self.$soundName, label: Text("Sound Name")) {
                        ForEach(PreferencesManager.shared.availableSounds, id: \.self) { name in
                            Text(name)
                        }
                    }.disabled(self.actionType != .playSoundAction)                 // 💩
                }
            
                Group {
                    TextField("Alert Title", text: self.$alertTitle)
                    
                    TextField("Alert Description", text: self.$alertDescription)
                }.disabled(self.actionType != .showAlertAction)                     // 💩
            }
            
            Section(header: Text("Trigger condition")) {
                Picker(selection: self.$triggerType, label: Text("Trigger Type")) {
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
