//
//  File.swift
//  
//
//  Created by 李斯特 on 2021/4/17.
//

import Foundation
import SwiftUI

#if !os(macOS)
import UIKit
#endif

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
    public func navigationBarSearch(search: @escaping (_ text: String) -> Void) -> some View {
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
        TextFieldWrapper(presentingView: self, content: content, isPresented: isPresented)
    }
    
    /// 提供中间视图的navigationBarItems
    /// - Parameters:
    ///   - leading: 左边
    ///   - center: 中间
    ///   - trailing: 右边
    /// - Returns: description
    @available(iOS 14.0, *)
    public func navigationBarItems<L, C, T>(leading: L, center: C, trailing: T) -> some View where L: View, C: View, T: View {
        self.navigationBarItems(leading:leading, trailing: trailing)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    center
                }
            }
    }
    
    
    /// 提供中间视图的navigationBarItems
    /// - Parameters:
    ///   - leading: 左边
    ///   - center: 中间
    ///   - trailing: 右边
    /// - Returns: description
    public func navigationBarItems<L, C, T>(leading: L, center: C, trailing: T) -> some View where L: View, C: View, T: View {
        self.navigationBarItems(leading:
            HStack{
                HStack {
                    leading
                }
                .frame(width: 82, alignment: .leading)
                .font(.none)
                Spacer()
                HStack {
                    center
                }
                .frame(width: 130, alignment: .center)
                Spacer()
                HStack {
                    trailing
                }
                .frame(width: 82, alignment: .trailing)
                .font(.none)
            }
            .frame(width: UIScreen.main.bounds.size.width - 31)
        )
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
