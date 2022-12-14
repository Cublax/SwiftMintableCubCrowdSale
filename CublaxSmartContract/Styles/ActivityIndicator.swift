//
//  ActivityIndicator.swift
//  CublaxSmartContract
//
//  Created by Meona on 13.12.22.
//

import SwiftUI

extension View {
    func loading(_ animate: Bool) -> some View {
        modifier(ActivityIndicator(animate: animate))
    }
}

fileprivate struct ActivityIndicator: ViewModifier {
    var animate: Bool
    
    fileprivate func body(content: Content) -> some View {
        ZStack {
            content
            
            Group {
                Color(UIColor.systemFill)
                ProgressView()
                    .progressViewStyle(MyActivityIndicator())
                    .padding()
            }
            .opacity(animate ? 1 : 0)
        }
    }
}


fileprivate struct MyActivityIndicator: ProgressViewStyle {
    @State private var isAnimating: Bool = false
    
    fileprivate func makeBody(configuration: ProgressViewStyleConfiguration) -> some View {
        VStack {
            ZStack {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .rotationEffect(Angle(degrees: isAnimating ? 360 : 0.0))
                    .animation(
                        isAnimating ? infiniteAnimation(duration: 1.0) : nil,
                        value: isAnimating
                    )
            }
        }
        .frame(width: 60, height: 60)
        .onAppear {
            isAnimating = true
        }
        .onDisappear {
            isAnimating = false
        }
    }
    
    private func infiniteAnimation(duration: Double) -> Animation {
        .linear(duration: duration)
        .repeatForever(autoreverses: false)
    }
}
