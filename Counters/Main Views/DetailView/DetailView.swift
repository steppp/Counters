//
//  DetailView.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var counter: Counter
    
    @State var checkpointDetailsVisible = false
    
    @State var counterName: String
    @State var initialValue: String
    @State var step: String
    @State var hasFinalValue: Bool
    @State var finalValue: String
    @State var tintColor: TintColorId
    @State var visualizationMode: CounterCellVisualizationMode
    @State var checkpoints: [Checkpoint]
    
    @State var formIsValid: Bool = false
    
    @Environment(\.presentationMode) var presentation
    
    var isEditing: Bool
    
    var navBarTitle: Text {
        if self.isEditing {
            return Text(Localizations.detailViewNavBarTitleEdit)
        }
        
        return Text(Localizations.detailViewNavBarTitleAdd)
    }
    
    var doneButton: some View {
        Button(action: {
            self.finalizeOperation()
            self.dismiss()
        }) {
            Text(Localizations.detailViewNavBarButtonsDone)
        }.disabled(!self.formIsValid)
    }
    
    var cancelButton: some View {
        Button(action: {
            self.dismiss()
        }) {
            Text(Localizations.detailViewNavBarButtonsCancel)
        }
    }
    
    private func writeChangesToDisk() {
        DispatchQueue.main.async {
            CountersManager.shared.saveToDisk(usingManager: DataManager.shared)
        }
    }
    
    private func dismiss() {
        self.writeChangesToDisk()
        AppearanceManager.toggleListSeparators()
        AppearanceManager.setTableViewCellBackgroundColor()
        self.presentation.wrappedValue.dismiss()
    }
    
    private func buildCounterCore() -> CounterCore {
        if let initialValue = Int(self.initialValue),
            let step = Int(self.step) {
            
            var finalValue: Int? = nil
            
            if self.hasFinalValue {
                if let final = Int(self.finalValue) {
                    finalValue = final
                }
            }
            
            let counterCore = CounterCore(initialValue: initialValue, step: step, finalValue: finalValue)
            counterCore.checkpoints = self.checkpoints
            
            return counterCore
        }
        
        fatalError("Wrong CounterCore values")
    }
    
    private func buildCounter(using core: CounterCore) -> Counter {
        return Counter(name: self.counterName, core: core,
                       tintColor: self.tintColor, visualizationMode: self.visualizationMode)
    }
    
    private func updateFormStatus() {
        // TODO: check that step respects the initialValue and the finalValue (if set) interval
        self.formIsValid = (
            self.counterName != "" &&
            self.initialValue != "" &&
            self.step != "" &&
                ((self.hasFinalValue && self.finalValue != "") || !self.hasFinalValue)
        )
    }
    
    /// Writes the changes to the counter
    private func finalizeOperation() {
        // TODO: write the function's body
        guard self.isEditing else {
            let core = self.buildCounterCore()
            let counter = self.buildCounter(using: core)
            counter.add(checkpoints: self.checkpoints)
            _ = CountersManager.shared.add(counters: [counter])
            
            return
        }
        
        self.counter.checkpoints = self.checkpoints
        self.counter.name = self.counterName
        self.counter.tintColor = self.tintColor
        self.counter.visualizationMode = self.visualizationMode
    }
    
    init(counter: Counter? = nil) {        
        guard let c = counter else {
            self.isEditing = false
            self._counterName = .init(initialValue: "")
            self._initialValue = .init(initialValue: "")
            self._step = .init(initialValue: "")
            self._finalValue = .init(initialValue: "")
            self._hasFinalValue = .init(initialValue: false)
            self._tintColor = .init(initialValue: .systemGray)
            self._visualizationMode = .init(initialValue: AppearanceManager.shared.defaultCounterCellVisualizationMode)
            self._checkpoints = .init(initialValue: [])
            
            self.counter = Counter.placeholder

            return
        }
        
        self.isEditing = true
        self.counter = c
        
        self._counterName = .init(initialValue: c.name)
        self._initialValue = .init(initialValue: c.initialValue.description)
        self._step = .init(initialValue: c.step.description)
        self._finalValue = .init(initialValue: c.finalValue?.description ?? "")
        self._hasFinalValue = .init(initialValue: c.finalValue != nil)
        self._tintColor = .init(initialValue: c.tintColor)
        self._visualizationMode = .init(initialValue: c.visualizationMode)
        self._checkpoints = .init(initialValue: c.getCheckpoints(includingNotActive: true))
        
        self._formIsValid = .init(initialValue: true)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // MARK: Name
                Section(header: Text(Localizations.detailViewCounterNameHeader)) {
                    TextField(Localizations.detailViewCounterNameLabel, text: self.$counterName,
                              onEditingChanged: { _ in self.updateFormStatus() })
                }
                
                // MARK: Counter parameters
                if !self.isEditing {
                    Section(header: Text(Localizations.detailViewCounterParametersHeader)) {

                        // TODO: decide if the update function should be passed to the textfield, if so the `.onReceive` modifier is not needed
                        InputAccessoryTextField(text: self.$initialValue, placeholder: Localizations.detailViewCounterInitialValueLabel)
                            .keyboardType(.numberPad)
                            .onReceive(self.initialValue.publisher.last()) { _ in
                                self.updateFormStatus()
                                print(self.initialValue)
                        }

                        TextField(Localizations.detailViewCounterStepLabel, text: self.$step,
                                  onEditingChanged: { _ in self.updateFormStatus() })
                            .keyboardType(.numberPad)

                        Toggle(isOn: self.$hasFinalValue) {
                            Text(Localizations.detailViewCounterHasFinalValueLabel)
                        }.onTapGesture {
                            self.updateFormStatus()
                        }

                        if self.hasFinalValue {
                            TextField(Localizations.detailViewCounterFinalValueLabel, text: self.$finalValue,
                                      onEditingChanged: { _ in self.updateFormStatus() })
                                .keyboardType(.numberPad)
                        }
                    }
                }
                
                // MARK: Checkpoints
                Section(header: Text(Localizations.detailViewCounterCheckpointsHeader)) {
                    if self.checkpoints.isEmpty {
                        Text(Localizations.circularCounterCellNoCheckpoints)
                            .foregroundColor(Color(.secondaryLabel))
                    } else {
                        ForEach(self.checkpoints, id: \.self) { checkpoint in
                            Button(action: {
                                self.checkpointDetailsVisible.toggle()
                            }) {
                                Text(checkpoint.localizedName)
                            }.sheet(isPresented: self.$checkpointDetailsVisible) {
                                CheckpointDetails(checkpoint: checkpoint, counter: self.counter, checkpoints: self.$checkpoints)
                            }.tag(checkpoint)
                                .foregroundColor(Color(.label))
                        }
                    }
                }
                
                Section {
                    // TODO: undestand why new checkpoints are not saved
                    Button(action: {
                        self.checkpointDetailsVisible.toggle()
                    }) {
                        Text(Localizations.detailViewCounterAddCheckpointButtonLabel)
                    }.sheet(isPresented: self.$checkpointDetailsVisible) {
                        CheckpointDetails(checkpoint: nil, checkpoints: self.$checkpoints)
                    }
                }
                
                // MARK: Visual Paramenters
                Section(header: Text(Localizations.detailViewCounterAppearanceHeader)) {
                    Picker(selection: self.$tintColor, label: Text(Localizations.detailViewCounterTintColorPickerLabel)) {
                        ForEach(TintColorId.allCases, id: \.self) { value in
                            HStack {
                                Circle()
                                    .fill(Color(AppearanceManager.shared.getColorFor(id: value)))
                                    .frame(width: 20, height: 20, alignment: .center)
                                
                                Text(value.localizedName)
                            }
                        }
                    }
                    
                    Picker(selection: self.$visualizationMode, label: Text(Localizations.detailViewCounterVisualizationModePickerLabel)) {
                        ForEach(CounterCellVisualizationMode.allCases, id: \.self) { value in
                            Text(value.localizedName).tag(value)
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        _ = CountersManager.shared.delete(counter: self.counter)
                        self.dismiss()
                    }, label: {
                        Text("Delete This Counter")
                    })
                        .foregroundColor(Color(.systemRed))
                    
                }
            }
            .navigationBarItems(leading: self.cancelButton, trailing: self.doneButton)
            .navigationBarTitle(self.navBarTitle, displayMode: .inline)
        }
        .background(Color(.systemBackground))
        .onAppear(perform: {
            AppearanceManager.toggleListSeparators()
            AppearanceManager.setTableViewCellBackgroundColor(to: .secondarySystemBackground)
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView().environment(\.locale, .init(identifier: "en"))
    }
}
