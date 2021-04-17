//
//  TextAlert.swift
//
//  Created by 李斯特 on 2021/3/31.
//


#if !os(macOS)

import Foundation
import Combine
import SwiftUI

public struct TextFieldAlert {
    
    // MARK: Instance var
    
    public let title: String
    public let message: String?
    public var placeholder: String = "" // Placeholder text for the TextField
    public var defaultValue: String = ""
    public var keyboardType: UIKeyboardType = .default // Keyboard tzpe of the TextField
    public var accept: String = "好".localizedString // The left-most button label
    public var cancel: String? = "取消".localizedString // The optional cancel (right-most) button label
    public var action: (String?) -> Void // Triggers when either of the two buttons closes the dialog
    
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
    override func viewDidAppear(_ animated: Bool) {
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
    
    @Binding var isPresented: Bool
    let alert: TextFieldAlert
    
    typealias UIViewControllerType = TextFieldAlertViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AlertWrapper>) -> UIViewControllerType {
        TextFieldAlertViewController(isPresented: $isPresented, alert: alert)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<AlertWrapper>) {
        // no update needed
    }
}

// MARK: - TextFieldWrapper
public struct TextFieldWrapper<PresentingView: View>: View {
    
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: TextFieldAlert
    
    var body: some View {
        ZStack {
            presentingView
            if (isPresented) {
                AlertWrapper(isPresented: $isPresented, alert: content)
            }
        }
    }
}

#endif
