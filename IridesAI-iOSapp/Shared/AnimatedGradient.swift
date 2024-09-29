//
//  AnimatedGradient.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import SwiftUI

struct AnimatedGradient: View {
    @State private var start = UnitPoint(x: 0, y: -2)
    @State private var end = UnitPoint(x: 1, y: 1) // Initial end point

    let colors = [
        Color(#colorLiteral(red: 0.9843137255, green: 0.9176470588, blue: 0.6470588235, alpha: 1)),
        Color(#colorLiteral(red: 1, green: 0.3333333333, blue: 0.6117647059, alpha: 1)),
        Color(#colorLiteral(red: 0.4156862745, green: 0.7098039216, blue: 0.9294117647, alpha: 1)),
        Color(#colorLiteral(red: 0.337254902, green: 0.1137254902, blue: 0.7490196078, alpha: 1)),
        Color(#colorLiteral(red: 0.337254902, green: 0.9215686275, blue: 0.8509803922, alpha: 1))
    ]

    let timer = Timer.publish(every: 3, on: .main, in: .default).autoconnect()

    var body: some View {
        background
            .blur(radius: 10)
    }

    var background: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .edgesIgnoringSafeArea(.all)
            .animation(Animation.easeInOut(duration: 10).repeatForever(autoreverses: true))
            .onReceive(timer) { _ in
                // Smoothly animate the start and end points
                withAnimation(.easeInOut(duration: 3)) {
                    self.start = UnitPoint(x: Double.random(in: -1...1), y: Double.random(in: -1...1))
                    self.end = UnitPoint(x: Double.random(in: -1...1), y: Double.random(in: -1...1))
                }
            }
    }
}

#Preview {
    AnimatedGradient()
}
