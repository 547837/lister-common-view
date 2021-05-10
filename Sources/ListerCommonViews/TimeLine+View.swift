//
//  SwiftUIView.swift
//  
//
//  Created by 李斯特 on 2021/5/9.
//

import SwiftUI

public struct TimeLineView<TimeView: View, Content: View>: View {
    
    var leftWidth: CGFloat { UIScreen.main.bounds.size.width * 0.2 }
    var rightWidth: CGFloat { UIScreen.main.bounds.size.width - leftWidth }
    
    private let isEnd: Bool
    private let timeView: TimeView
    private let content: Content
    
    public init(isEnd: Bool = false, @ViewBuilder timeView: () -> TimeView, @ViewBuilder content: () -> Content) {
        self.isEnd = isEnd
        self.timeView = timeView()
        self.content = content()
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing, spacing: 2) {
                timeView
            }
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .padding(.horizontal, 10)
            .frame(width: leftWidth, alignment: .trailing)
            .overlay(
                icon("circle.fill")
            )
            
            VStack(alignment: .leading, spacing: 5) {
                content
            }
            .frame(width: rightWidth, alignment: .leading)
        }
        .background(
            GeometryReader { geo in
                VStack(alignment: .leading) {
                    Path { path in
                        path.move(to: CGPoint(x: leftWidth, y: 0))
                        path.addLine(to: CGPoint(x: leftWidth, y: geo.size.height + (isEnd ? 0 : 15)))
                    }
                    .stroke(Color.gray, lineWidth: 1)
                    .padding(.top, 7)
                }
            }
        )
        
    }
    
    private func icon(_ iconName: String) -> some View{
        Image(systemName: iconName)
            .foregroundColor(Color.gray)
            .font(.footnote)
            .offset(x: UIScreen.main.bounds.size.width  * 0.2, y: -20)
            .scaleEffect(0.5)
    }
}
// Color("TimeLineColor")

struct TimeLineView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            ForEach(1..<4) { _ in
                TimeLineView {
                    VStack(alignment: .trailing) {
                        Text("4月1日").font(.none)
                        Text("2021年").font(.footnote)
                    }
                } content: {
                    VStack(alignment: .leading) {
                        Text("借出").fontWeight(.bold).foregroundColor(.blue)
                        Text("金额 99999")
                        Text("备注 xxxxxxxxx")
                    }
                }
            }
            TimeLineView(isEnd: true) {
                VStack(alignment: .trailing) {
                    Text("4月1日").font(.none)
                    Text("2021年").font(.footnote)
                }
            } content: {
                VStack(alignment: .leading) {
                    Text("借出").fontWeight(.bold).foregroundColor(.blue)
                    Text("金额 99999")
                    Text("备注 xxxxxxxxx")
                    
                }
            }
        }

    }
}
