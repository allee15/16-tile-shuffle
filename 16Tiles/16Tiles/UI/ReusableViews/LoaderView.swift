//
//  LoaderView.swift
//  16Tiles
//
//  Created by Alexia Aldea on 19/09/2026.
//


import SwiftUI

struct LoaderView: View {
    var color: [Color]?
    @State var animated: Bool = false
    @State var animateStrokeStart: Bool = false
    @State var animateStrokeEnd: Bool = false
    var height: CGFloat? = 56
    var width: CGFloat? = 56
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: animateStrokeStart ? 1/3 : 1/9, to: animateStrokeEnd ? 2/5 : 1)
                .stroke(AngularGradient(colors: color ?? [Color.accentButton], center: .center), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: width, height: height)
                .rotationEffect(Angle(degrees: animated ? 360 : 0))
        }.onAppear {
            withAnimation(Animation.linear(duration: 0.5).repeatForever(autoreverses: false)) {
                self.animated.toggle()
            }
            
            withAnimation(Animation.linear(duration: 0.5).delay(0.25).repeatForever(autoreverses: true)) {
                self.animateStrokeStart.toggle()
            }
            
            withAnimation(Animation.linear(duration: 0.5).delay(0.25).repeatForever(autoreverses: true)) {
                self.animateStrokeEnd.toggle()
            }
        }
    }
}

struct LoaderViewWithBg: View {
   var body: some View {
       ZStack {
           Color.black.opacity(0.5)
           LoaderView()
       }.frame(maxWidth: .infinity, maxHeight: .infinity)
           .ignoresSafeArea(.all)
   }
}
