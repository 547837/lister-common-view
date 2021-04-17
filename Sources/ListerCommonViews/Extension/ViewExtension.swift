//
//  File.swift
//  
//
//  Created by 李斯特 on 2021/4/17.
//

import Foundation
import SwiftUI

extension View {
    
    #if !os(macOS)
    /// 执行隐藏键盘的操作
    public func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// 在NavigationBar下嵌套搜索框
    /// - Parameter search: search function
    /// - Returns: SearchBar
    /// @escaping 解决逃逸闭包的方式 https://www.jianshu.com/p/dd0537a40fc6
    func navigationBarSearch(search: @escaping (_ text: String) -> Void) -> some View {
        return overlay(
            SearchBar(search: search).frame(width: 0, height: 0)
        )
    }
    
    /// Description
    /// - Parameters:
    ///   - isPresented: isPresented description
    ///   - content: content description
    /// - Returns: description
    public func alert(isPresented: Binding<Bool>, _ content: TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
    }
    
    #endif
    
    /// 提供一个根据条件决定是否使用 redacted
    /// 用于替代：.redacted(reason: 条件 ? [] : .placeholder)
    /// - Parameter isRedacted: 条件
    /// - Returns:
    @available(OSX 11.0, *)
    @available(iOS 14.0, *)
    @ViewBuilder public func redacted(_ isRedacted: Bool) -> some View  {
        if isRedacted {
            self.redacted(reason: .placeholder)
        } else {
            self.unredacted()
        }
    }
}


#if !os(macOS)
/// make the call the SwiftUI style:
/// view.allowAutDismiss(...)
extension View {
    /// Control if allow to dismiss the sheet by the user actions
    public func allowAutoDismiss(_ dismissable: @escaping () -> Bool) -> some View {
        self.background(MbModalHackView(dismissable: dismissable))
    }
    
    /// Control if allow to dismiss the sheet by the user actions
    public func allowAutoDismiss(_ dismissable: Bool) -> some View {
        self.background(MbModalHackView(dismissable: { dismissable }))
    }
}

#endif
