//
//  UITextFieldView.swift
//
//  Created by Lister on 2021/3/3.
//

#if !os(macOS)

import Foundation
import SwiftUI

public struct UITextFieldView: UIViewRepresentable {
    
    // MARK: Instance var
    
    public let contentType: UITextContentType
    public let returnKeyType: UIReturnKeyType
    public let placeholder: String
    public let tag: Int
    
    // MARK: Binding
    
    @Binding public var text: String
    @Binding public var isfocusAble: [Bool]
    
    public func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.textContentType = self.contentType
        textField.returnKeyType = self.returnKeyType
        textField.tag = self.tag
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.font = .systemFont(ofSize: 15)
        if textField.textContentType == .password || textField.textContentType == .newPassword {
            textField.isSecureTextEntry = true
        }
        
        return textField
    }
    
    public func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        if uiView.window != nil {
            if isfocusAble[tag] {
                if !uiView.isFirstResponder {
                    uiView.becomeFirstResponder()
                }
            } else {
                uiView.resignFirstResponder()
            }
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        
        public var parent: UITextFieldView
        
        public init(_ textField: UITextFieldView) {
            self.parent = textField
        }
        
        public func textFieldDidChangeSelection(_ textField: UITextField) {
            // Without async this will modify the state during view update.
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? ""
            }
        }
        
        public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            setFocus(tag: self.parent.tag)
            return true
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            setFocus(tag: self.parent.tag + 1)
            return true
        }
        
        private func setFocus(tag: Int) {
            let reset = tag >= parent.isfocusAble.count || tag < 0
            
            if reset || !parent.isfocusAble[tag] {
                var newFocus = [Bool] (repeatElement(false, count: self.parent.isfocusAble.count))
                if !reset {
                    newFocus[tag] = true
                }
                DispatchQueue.main.async {
                    self.parent.isfocusAble = newFocus
                }
            }
        }
    }
}

#endif
