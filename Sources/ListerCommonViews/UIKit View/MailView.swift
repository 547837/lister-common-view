//
//  MailView.swift
//
//  Created by 李斯特 on 2021/3/9.
//
#if !os(macOS)
import SwiftUI
import MessageUI

public struct MailView: UIViewControllerRepresentable {
    
    // MARK: Instance var
    
    public var subject: String
    public var toRecipients: [String]
    
    // MARK: Binding
    
    @Binding public var isShowing: Bool
    @Binding public var result: Result<MFMailComposeResult, Error>?
    
    public init(subject: String, toRecipients: [String], isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
        self.subject = subject
        self.toRecipients = toRecipients
        self._isShowing = isShowing
        self._result = result
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setSubject(subject)
        mail.setToRecipients(toRecipients)
        return mail
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) {
        // no body
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding public var isShowing: Bool
        @Binding public var result: Result<MFMailComposeResult, Error>?
        
        public init(isShowing: Binding<Bool>, result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
}
#endif
