//
//  DetailView.swift
//  Counters
//
//  Created by Stefano Andriolo on 03/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI
import Combine

struct DetailView: View {
    let counter: Counter?
    
    @State var counterName: String
    @State var initialValue: String
    @State var step: String
    @State var hasFinalValue: Bool
    @State var finalValue: String
    @State var tintColor: TintColorId
    @State var visualizationMode: CounterCellVisualizationMode
    
    @State var formIsValid: Bool = false
    
    var navBarTitle: Text {
        if let _ = self.counter {
            return Text(Localizations.detailViewNavBarTitleEdit)
        }
        
        return Text(Localizations.detailViewNavBarTitleAdd)
    }
    
    @Environment(\.presentationMode) var presentation
    
    var doneButton: some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
        }) {
            Text(Localizations.detailViewNavBarButtonsDone)
        }.disabled(!self.formIsValid)
    }
    
    var cancelButton: some View {
        Button(action: {
            self.presentation.wrappedValue.dismiss()
        }) {
            Text(Localizations.detailViewNavBarButtonsCancel)
        }
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
            
            return CounterCore(initialValue: initialValue, step: step, finalValue: finalValue)
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
    }
    
    init(counter: Counter? = nil) {
        self.counter = counter
        
        guard let c = counter else {
            self._counterName = .init(initialValue: "")
            self._initialValue = .init(initialValue: "")
            self._step = .init(initialValue: "")
            self._finalValue = .init(initialValue: "")
            self._hasFinalValue = .init(initialValue: false)
            self._tintColor = .init(initialValue: .systemGray)
            self._visualizationMode = .init(initialValue: AppearanceManager.shared.defaultCounterCellVisualizationMode)

            return
        }
        
        self._counterName = .init(initialValue: c.name)
        self._initialValue = .init(initialValue: c.initialValue.description)
        self._step = .init(initialValue: c.step.description)
        self._finalValue = .init(initialValue: c.finalValue?.description ?? "")
        self._hasFinalValue = .init(initialValue: c.finalValue != nil)
        self._tintColor = .init(initialValue: c.tintColor)
        self._visualizationMode = .init(initialValue: c.visualizationMode)
        
        self._formIsValid = .init(initialValue: true)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(Localizations.detailViewCounterNameHeader)) {
                    TextField(Localizations.detailViewCounterNameLabel, text: self.$counterName,
                        onEditingChanged: { _ in self.updateFormStatus() })
                }
                
                Section(header: Text(Localizations.detailViewCounterParametersHeader)) {
                    
                    // TODO: decide if the update function should be passed to the textfield, if so the `.onReceive` modifier is not needed
                    InputAccessoryTextField(text: self.$initialValue, placeholder: "Help")
                        .keyboardType(.numberPad)
                        .onReceive(self.initialValue.publisher.last()) { _ in
                            self.updateFormStatus()
                            print(self.initialValue)
                    }
                    
//                    TextField(Localizations.detailViewCounterInitialValueLabel, text: self.$initialValue,
//                              onEditingChanged: { _ in self.updateFormStatus() })
//                        .keyboardType(.numberPad)
                    
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
        .onDisappear(perform: {
            AppearanceManager.toggleListSeparators()
            AppearanceManager.setTableViewCellBackgroundColor()
        })
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView().environment(\.locale, .init(identifier: "en"))
    }
}
