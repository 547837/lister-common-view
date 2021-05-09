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
    
    private let timeView: TimeView
    private let content: Content
    
    public init(@ViewBuilder timeView: () -> TimeView, @ViewBuilder content: () -> Content) {
        self.timeView = timeView()
        self.content = content()
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .trailing, spacing: 2) {
                timeView
            }
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
                Path { path in
                    path.move(to: CGPoint(x: leftWidth, y: 0))
                    path.addLine(to: CGPoint(x: leftWidth, y: geo.size.height + 15))
                }
                .stroke(Color("TimeLineColor"), lineWidth: 1)
                .padding(.top, 7)
            }
        )
        
    }
    
    private func icon(_ iconName: String) -> some View{
        Image(systemName: iconName)
            .foregroundColor(Color("TimeLineColor"))
            .font(.footnote)
            .offset(x: UIScreen.main.bounds.size.width  * 0.2, y: -20)
            .scaleEffect(0.5)
    }
}

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
                    HStack {
                        ForEach(1..<4) { _ in
                            Image("Appearance")
                                .resizable()
                                .frame(width: 70, height: 70, alignment: .center)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            }
        }

    }
}
