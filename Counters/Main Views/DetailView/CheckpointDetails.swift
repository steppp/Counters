//
//  CheckpointDetails.swift
//  Counters
//
//  Created by Stefano Andriolo on 07/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct CheckpointDetails: View {
    var checkpoint: Checkpoint?
    var counter: Counter?
    
    var isEditing: Bool = false
    
    @Binding var showSelf: Bool
    
    @State var action: CheckpointAction?
    @State var actionType: ActionType
    @State var actionTargetCounter: Counter?
    
    @State var triggerType: TriggerType
    @State var targetValue: String
    
    @State var soundName: String
    
    @State var alertTitle: String
    @State var alertDescription: String
    
    @Environment(\.presentationMode) var presentation
    
    init(checkpoint: Checkpoint?, counter: Counter? = nil, showSelf: Binding<Bool>?) {
        self._showSelf = showSelf!
        
        if let ch = checkpoint {
            self._action = .init(wrappedValue: ch.action)
            self._actionType = .init(wrappedValue: ch.action.actionType)
            self._actionTargetCounter = .init(wrappedValue: ch.action.counter as? Counter)
            
            self._triggerType = .init(wrappedValue: ch.triggerType)
            self._targetValue = .init(wrappedValue: ch.targetValue.description)
            
            if let playSoundAction = ch.action as? PlaySoundAction {
                let stringPath = playSoundAction.url.lastPathComponent
                let name = stringPath[..<stringPath.index(stringPath.endIndex, offsetBy: -4)]
                self._soundName = .init(wrappedValue: String(name))
            } else {
                self._soundName = .init(wrappedValue: PreferencesManager.defaultSoundName)
            }
            
            if let showAlertAction = ch.action as? ShowAlertAction {
                self._alertTitle = .init(wrappedValue: showAlertAction.alertToPresent.title!)
                self._alertDescription = .init(wrappedValue: showAlertAction.alertToPresent.message!)
            } else {
                self._alertTitle = .init(wrappedValue: "")
                self._alertDescription = .init(wrappedValue: "")
            }
            
            self.isEditing = true
            self.checkpoint = checkpoint
            self.counter = counter

            return
        }
        
        self._action = .init(wrappedValue: nil)
        self._actionType = .init(wrappedValue: .playSoundAction)
        self._actionTargetCounter = .init(wrappedValue: nil)
        self._triggerType = .init(wrappedValue: .exactlyEqualTo)
        self._targetValue = .init(wrappedValue: "")
        self._soundName = .init(wrappedValue: PreferencesManager.defaultSoundName)
        self._alertTitle = .init(wrappedValue: "")
        self._alertDescription = .init(wrappedValue: "")
        
        self.counter = nil
        self.checkpoint = nil
    }
    
    private func finalizeIfValid() -> Bool {
        var action: CheckpointAction
        
        switch self.actionType {
        case .deleteCounterAction:
            guard let tCounter = self.actionTargetCounter else { return false }
            action = DeleteCounterAction(deleteCounter: tCounter, from: CountersManager.shared)
            
        case .incrementCounterAction:
            guard let tCounter = self.actionTargetCounter else { return false }
            action = IncrementCounterAction(target: tCounter)
            
        case .playSoundAction:
            action = PlaySoundAction(target: Counter.placeholder, playSoundAtPath: self.soundName)
            
        case .showAlertAction:
            guard !self.alertTitle.isEmpty, let tCounter = self.actionTargetCounter else { return false }
            
            action = ShowAlertAction(counter: tCounter, alertPresenter: AlertPresenter(), alert: UIAlertController(title: self.alertTitle, message: self.alertDescription, preferredStyle: .alert))
        }
        
        guard let tVal = Int(self.targetValue) else { return false }
        
        guard self.isEditing else {
            let ch = Checkpoint(triggerWhen: self.triggerType, value: tVal, executeAction: action)
            self.counter?.add(checkpoint: ch)
            
            debugPrint("Finalizing..")
            
            return true
        }
        
        self.checkpoint?.action = action
        self.checkpoint?.triggerType = self.triggerType
        self.checkpoint?.targetValue = tVal
        
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: rows marked with 💩 are needed because of SwiftUI sheningangs
                Section(header: Text("Action settings")) {
                    Picker(selection: self.$actionType, label: Text("Action Type")) {
                        ForEach(ActionType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    
                    Group {
                        Picker(selection: self.$actionTargetCounter, label: Text("Target Counter")) {
                            ForEach(CountersManager.shared.counters, id: \.self) { counter in
                                Text(counter.name).tag(counter)
                            }
                        }.disabled(self.actionType != .incrementCounterAction &&        // 💩
                            self.actionType != .deleteCounterAction)                    // 💩
                    }
                    
                    Group {
                        Picker(selection: self.$soundName, label: Text("Sound Name")) {
                            ForEach(PreferencesManager.shared.availableSounds, id: \.self) { name in
                                Text(name).tag(name)
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
                            Text(type.localizedName).tag(type)
                        }
                    }
                    
                    InputAccessoryTextField(text: self.$targetValue, placeholder: "Target Value")
                        .keyboardType(.numberPad)
                }
                
                Section {
                    Button(action: {
                        // TODO: delete checkpoint from the counter
                    }) {
                        Text(Localizations.checkpointDetailDeleteCounterLabel)
                    }
                    .foregroundColor(Color(.systemRed))
                }
            }
            .navigationBarTitle("Checkpoint Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                if self.finalizeIfValid() {
                    // TODO: check if this is correct
                    self.presentation.wrappedValue.dismiss()
    //                self.showSelf.toggle()
                    debugPrint(self.showSelf)
                }
            }) {
                    Text("Save")

            })
        }
    }
}

struct CheckpointDetails_Previews: PreviewProvider {
    static var previews: some View {
        CheckpointDetails(checkpoint: Checkpoint.example, showSelf: nil)
    }
}
