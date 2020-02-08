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
    
    @Binding var checkpoints: [Checkpoint]
    
    var isEditing: Bool = false
    @State var deleteButtonPressed: Bool = false
    
//    @Binding var showSelf: Bool
    
    @State var action: CheckpointAction?
    @State var actionType: ActionType
    @State var actionTargetCounter: String
    
    @State var triggerType: TriggerType
    @State var targetValue: String
    
    @State var soundName: String
    
    @State var shortcutName: String
    @State var shortuctInput: String
    
    @State var showingInvalidFormAlert: Bool = false
    
    @Environment(\.presentationMode) var presentation
    
    init(checkpoint: Checkpoint?, counter: Counter? = nil, checkpoints: Binding<[Checkpoint]>) {
        self.counter = counter
        self._checkpoints = checkpoints
        
        if let ch = checkpoint {
            self._action = .init(wrappedValue: ch.action)
            self._actionType = .init(wrappedValue: ch.action.actionType)
            self._actionTargetCounter = .init(wrappedValue: (ch.action.counter as? Counter)?.name ?? "")
            
            self._triggerType = .init(wrappedValue: ch.triggerType)
            self._targetValue = .init(wrappedValue: ch.targetValue.description)
            
            if let playSoundAction = ch.action as? PlaySoundAction {
                let stringPath = playSoundAction.url.lastPathComponent
                let name = stringPath[..<stringPath.index(stringPath.endIndex, offsetBy: -4)]
                self._soundName = .init(wrappedValue: String(name))
            } else {
                self._soundName = .init(wrappedValue: PreferencesManager.defaultSoundName)
            }
            
            if let runShorctutAction = ch.action as? RunShortcutAction {
                self._shortcutName = .init(wrappedValue: runShorctutAction.shortcutName)
                self._shortuctInput = .init(wrappedValue: runShorctutAction.shortcutInput ?? "")
            } else {
                self._shortcutName = .init(wrappedValue: "")
                self._shortuctInput = .init(wrappedValue: "")
            }
            
            self.isEditing = true
            self.checkpoint = checkpoint

            return
        }
        
        self._action = .init(wrappedValue: nil)
        self._actionType = .init(wrappedValue: .playSoundAction)
        self._actionTargetCounter = .init(wrappedValue: "")
        self._triggerType = .init(wrappedValue: .exactlyEqualTo)
        self._targetValue = .init(wrappedValue: "")
        self._soundName = .init(wrappedValue: PreferencesManager.defaultSoundName)
        self._shortcutName = .init(wrappedValue: "")
        self._shortuctInput = .init(wrappedValue: "")
        
        self.checkpoint = nil
    }
    
    private func finalizeIfValid() -> Bool {
        var action: CheckpointAction
        
        switch self.actionType {
        case .deleteCounterAction:
            guard let target =
                CountersManager.shared.getCounter(forName: self.actionTargetCounter) else { return false }
            action = DeleteCounterAction(deleteCounter: target, from: CountersManager.shared)
            
        case .incrementCounterAction:
            guard let target =
                CountersManager.shared.getCounter(forName: self.actionTargetCounter) else { return false }
            action = IncrementCounterAction(target: target)
            
        case .playSoundAction:
            action = PlaySoundAction(target: Counter.placeholder, playSoundAtPath: self.soundName)
                        
        case .runShortcutAction:
            guard !self.shortcutName.isEmpty else { return false }
            action = RunShortcutAction(counter: Counter.placeholder, shortcutName: self.shortcutName, shortcutInput: self.shortuctInput)
        }
        
        guard let tVal = Int(self.targetValue) else { return false }
        
        guard self.isEditing else {
            let ch = Checkpoint(triggerWhen: self.triggerType, value: tVal, executeAction: action)
            self.checkpoints.append(ch)
            
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
                Section(header: Text("Action settings")) {
                    Picker(selection: self.$actionType, label: Text("Action Type")) {
                        ForEach(ActionType.allCases, id: \.self) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                    
                    if self.actionType == .incrementCounterAction || self.actionType == .deleteCounterAction {
                        Picker(selection: self.$actionTargetCounter, label: Text("Target Counter")) {
                            ForEach(CountersManager.shared.getCountersNames(excludingCounter: self.counter),
                                    id: \.self) { name in
                                Text(name).tag(name)
                            }
                        }
                    }
                    
                    if self.actionType == .playSoundAction {
                        Picker(selection: self.$soundName, label: Text("Sound Name")) {
                            ForEach(PreferencesManager.shared.availableSounds, id: \.self) { name in
                                Text(name).tag(name)
                            }
                        }
                    }
                    
                    if self.actionType == .runShortcutAction {
                        TextField("Shortcut Name", text: self.$shortcutName).tag(2)
                        
                        TextField("Shortcut Input Text", text: self.$shortuctInput).tag(3)
                    }
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
                        debugPrint("Should dismiss..")
                        self.deleteButtonPressed.toggle()
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text(Localizations.checkpointDetailDeleteSelfButtonLabel)
                    }
                    .foregroundColor(Color(.systemRed))
                }
            }
            .navigationBarTitle("Checkpoint Details", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                if self.finalizeIfValid() {
                    self.presentation.wrappedValue.dismiss()
                } else {
                    self.showingInvalidFormAlert = true
                }
            }) {
                    Text("Save")
            })
            .onDisappear {
                if self.deleteButtonPressed && self.checkpoint != nil {
                    self.checkpoints = Counter.removing(checkpoint: self.checkpoint!, from: self.checkpoints)
                }
            }
            .alert(isPresented: self.$showingInvalidFormAlert) {
                Alert(title: Text("Could not save Checkpoint"),
                      message: Text("Check that all values are correctly set."),
                      dismissButton: .default(Text("Ok")))
            }
        }
    }
}

struct CheckpointDetails_Previews: PreviewProvider {
    static var previews: some View {
        CheckpointDetails(checkpoint: Checkpoint.example, checkpoints: .constant([]))
    }
}
