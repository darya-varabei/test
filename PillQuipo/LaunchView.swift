//
//  LaunchView.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 5/18/21.
//

import SwiftUI

struct DNABalls: View {
    @State var delay: Double
    @State var ballSpeed: Double
    @State var ballSize: CGFloat
    @State var firstBallColor: LinearGradient
    @State var secondBallColor: LinearGradient
    
    @State private var top = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader() { geo in
            ZStack {
                ZStack {
                    DNABall(delay: 0 + self.delay, ballSpeed: self.ballSpeed, ballSize: self.ballSize, rect: geo.size, color: self.firstBallColor)
                    DNABall(delay: self.ballSpeed + self.delay, ballSpeed: self.ballSpeed, ballSize: self.ballSize, rect: geo.size, color: self.secondBallColor)
                }
                .opacity(self.top ? 1 : 0)
                ZStack {
                    DNABall(delay: self.ballSpeed + self.delay, ballSpeed: self.ballSpeed, ballSize: self.ballSize, rect: geo.size, color: self.secondBallColor)
                    DNABall(delay: 0 + self.delay, ballSpeed: self.ballSpeed, ballSize: self.ballSize, rect: geo.size, color: self.firstBallColor)
                }
                .opacity(self.top ? 0 : 1)
            }
        }
        .onAppear() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                Timer.scheduledTimer(withTimeInterval: self.ballSpeed, repeats: true) { _ in
                    self.top.toggle()
                }
            }
        }.onReceive(timer) { time in
            print("The time is now \(time)")
    }
}
}


struct DNABall: View {
    @State var delay: Double
    @State var ballSpeed: Double
    @State var ballSize: CGFloat
    @State var rect: CGSize
    @State var color: LinearGradient
    
    @State private var offsetY: CGFloat = 0
    @State private var scale: CGFloat = 1
    
    var body: some View {
        Circle()
            .fill(color)
            .frame(width: self.ballSize, height: self.ballSize)
            .offset(x: 0, y: -(rect.height/2))
            .offset(x: 0, y: self.offsetY)
            .scaleEffect(self.scale)
            
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                    withAnimation(Animation.easeInOut(duration: self.ballSpeed).repeatForever(autoreverses: true)) {
                        self.offsetY = self.rect.height
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + self.ballSpeed/2) {
                        withAnimation(Animation.easeInOut(duration: self.ballSpeed).repeatForever(autoreverses: true)) {
                            self.scale = self.minBallScale
                        }
                    }
                }
            }
    }
    let minBallScale: CGFloat = 0.65
}
