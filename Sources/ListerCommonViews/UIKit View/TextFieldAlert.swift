//
//  TextAlert.swift
//
//  Created by 李斯特 on 2021/3/31.
//


#if !os(macOS)

import Foundation
import Combine
import SwiftUI
import ListerCommon

public struct TextFieldAlert {
    
    // MARK: Instance var
    
    public let title: String
    public var message: String = ""
    public var placeholder: String = "" // Placeholder text for the TextField
    public var defaultValue: String = ""
    public var keyboardType: UIKeyboardType = .default // Keyboard tzpe of the TextField
    public let accept: String // The left-most button label
    public var cancel: String? // The optional cancel (right-most) button label
    public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
    
    public init(title: String, message: String = "", placeholder: String = "", defaultValue: String = "", keyboardType: UIKeyboardType = .default, accept: String, cancel: String?, action: @escaping (String?) -> Void) {
        self.title = title
        self.message = message
        self.placeholder = placeholder
        self.defaultValue = defaultValue
        self.keyboardType = keyboardType
        self.accept = accept
        self.cancel = cancel
        self.action = action
    }
}

public class TextFieldAlertViewController: UIViewController {
    
    public init(isPresented: Binding<Bool>, alert: TextFieldAlert) {
        self._isPresented = isPresented
        self.alert = alert
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @Binding
    private var isPresented: Bool
    private var alert: TextFieldAlert
    
    // Private Properties
    private var subscription: AnyCancellable?
    
    // Lifecycle
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlertController()
    }
    
    private func presentAlertController() {
        guard subscription == nil else { return } // present only once
        
        let vc = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        // add a textField and create a subscription to update the `text` binding
        vc.addTextField {
            $0.placeholder = self.alert.placeholder
            $0.keyboardType = self.alert.keyboardType
            $0.text = self.alert.defaultValue
        }
        if let cancel = alert.cancel {
            vc.addAction(UIAlertAction(title: cancel, style: .cancel) { _ in
                self.isPresented = false
            })
        }
        let textField = vc.textFields?.first
        vc.addAction(UIAlertAction(title: alert.accept, style: .default) { _ in
            self.isPresented = false
            self.alert.action(textField?.text)
        })
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - AlertWrapper
public struct AlertWrapper:  UIViewControllerRepresentable {
    
    @Binding public var isPresented: Bool
    public let alert: TextFieldAlert
    
    public typealias UIViewControllerType = TextFieldAlertViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIViewControllerType {
        TextFieldAlertViewController(isPresented: $isPresented, alert: alert)
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        // no update needed
    }
}

// MARK: - TextFieldWrapper
public struct TextFieldWrapper<PresentingView: View>: View {
    
    // MARK: Instance var
    
    public let presentingView: PresentingView
    public let content: TextFieldAlert
    
    // MARK: Binding
    
    @Binding public var isPresented: Bool
    
    // MARK: View
    
    public var body: some View {
        ZStack {
            presentingView
            if (isPresented) {
                AlertWrapper(isPresented: $isPresented, alert: content)
            }
        }
    }
}

#endif
