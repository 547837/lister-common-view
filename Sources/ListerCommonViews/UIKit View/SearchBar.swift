//
//  SearchBar.swift
//
//  Created by 李斯特 on 2021/3/20.
//

#if !os(macOS)
import SwiftUI
import Combine

public extension View {
    

}

public struct SearchBar: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SearchBarWrapperController
    
    public var search: (_ text: String) -> Void
    
    
    /// @escaping 解决逃逸闭包的方式 https://www.jianshu.com/p/dd0537a40fc6
    /// - Parameter search: search description
    public init(search: @escaping (_ text: String) -> Void) {
        self.search = search
    }
    
    public func makeUIViewController(context: Context) -> SearchBarWrapperController {
        return SearchBarWrapperController()
    }
    
    public func updateUIViewController(_ uiViewController: SearchBarWrapperController, context: Context) {
        uiViewController.searchController = context.coordinator.searchController
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(search: search)
    }
    
    public class Coordinator: NSObject, UISearchResultsUpdating {
        var search: (_ text: String) -> Void
        let searchController: UISearchController
        
        private var subscription: AnyCancellable?
        
        /// @escaping 解决逃逸闭包的方式 https://www.jianshu.com/p/dd0537a40fc6
        init(search: @escaping (_ text: String) -> Void) {
            self.searchController = UISearchController(searchResultsController: nil)
            self.search = search
            super.init()
            
            searchController.searchResultsUpdater = self
            // 搜索时是否隐藏导航栏
            searchController.hidesNavigationBarDuringPresentation = true
            // 搜索时是否隐藏（置灰）基础内容
            searchController.obscuresBackgroundDuringPresentation = false
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            self.search(text)
        }
    }
    
    public class SearchBarWrapperController: UIViewController {
        var searchController: UISearchController? {
            didSet {
                self.parent?.navigationItem.searchController = searchController
            }
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.parent?.navigationItem.searchController = searchController
        }
        override func viewDidAppear(_ animated: Bool) {
            self.parent?.navigationItem.searchController = searchController
        }
    }
}
#endif
