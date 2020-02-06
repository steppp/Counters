//
//  InputAccessoryTextField.swift
//  Counters
//
//  Created by Stefano Andriolo on 06/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

// MARK: see https://stackoverflow.com/a/59115092

import SwiftUI
import UIKit
import Combine

struct InputAccessoryTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    
    let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 32))
    
    func makeUIView(context: UIViewRepresentableContext<InputAccessoryTextField>) -> UITextField {
        self.textField.placeholder = NSLocalizedString(self.placeholder, comment: "")
        self.textField.keyboardType = .numberPad
        return self.textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<InputAccessoryTextField>) {
        self.textField.text = text
    }
    
    // TODO: search what all of this shit means
    func makeCoordinator() -> InputAccessoryTextField.Coordinator {
        let coordinator = Coordinator(self)
        
        let toolbar = UIToolbar()
        toolbar.setItems([
            UIBarButtonItem(
                title: "Toggle Sign",
                style: .plain,
                target: coordinator,
                action: #selector(coordinator.toggleSign)
            ),
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            ),
            UIBarButtonItem(
                title: "OK",
                style: .done,
                target: coordinator,
                action: #selector(coordinator.onSet)
            )
        ], animated: true)
        
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        self.textField.inputAccessoryView = toolbar
        
        return coordinator
    }
    
    typealias UIViewType = UITextField
    
    class Coordinator: NSObject {
        let owner: InputAccessoryTextField
        private var subscriber: AnyCancellable
        
        init(_ owner: InputAccessoryTextField) {
            self.owner = owner
            
            self.subscriber = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification,
                                                                   object: self.owner.textField)
                .sink(receiveValue: { _ in
                    // TODO: understand why the change is not registered when the text is empty
                    owner.$text.wrappedValue = owner.textField.text ?? ""
                })
        }
        
        @objc fileprivate func onSet() {
            self.owner.textField.resignFirstResponder()
        }
        
        @objc fileprivate func toggleSign() {
            if let text = self.owner.textField.text {
                if let firstChar = text.first, firstChar == "-" {
                    self.owner.textField.text?.remove(at: text.startIndex)
                } else {
                    self.owner.textField.text?.insert("-", at: text.startIndex)
                }
            } else {
                self.owner.textField.text = "-"
            }
            
            self.owner.$text.wrappedValue = self.owner.textField.text ?? ""
        }
    }
}
