//
//  SwiftUIView.swift
//  Care-time
//
//  Created by Дарья Воробей on 2/22/21.
//

import SwiftUI


struct LoadingView: View {
    
    @State var circleEnd: CGFloat = 0.001
    @State var smallerCircleEnd: CGFloat = 1
    
    @State var rotationDegree: Angle = Angle.degrees(-90)
    @State var smallerRotationDegree: Angle = Angle.degrees(-30)
    
    let trackerRotation: Double = 1
    let animationDuration: Double = 1.35
    
    var body: some View {
        ZStack {
            Color(ColorsSaved.clear)
                .edgesIgnoringSafeArea(.all)
            
            ZStack {
                Circle()
                    .trim(from: 0, to: circleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .fill(Color(ColorsSaved.gradientBlue))
                    .rotationEffect(self.rotationDegree)
                    .frame(width: 90, height: 90)
                Circle()
                    .trim(from: 0, to: smallerCircleEnd)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .fill(Color(ColorsSaved.gradientBlue).opacity(0.9))
                    .rotationEffect(self.smallerRotationDegree)
                    .frame(width: 40, height: 40 )
            }.offset(y: -48)
            Text("@shubham_iosdev")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .medium, design: .monospaced))
                .opacity(0.7)
                .offset(x: 96, y: 380)
            .onAppear() {
                animate()
                Timer.scheduledTimer(withTimeInterval: animationDuration * 3, repeats: true) { _ in
                    reset()
                    animate()
                }
            }
        }
    }
    
    func animate() {
        withAnimation(Animation.easeOut(duration: animationDuration)) {
            self.circleEnd = 1
        }
        withAnimation(Animation.easeOut(duration: animationDuration * 1.1)) {
            self.rotationDegree = RotationDegrees.initialCicle.getRotationDegrees()
        }
        
        withAnimation(Animation.easeOut(duration: animationDuration * 0.85)) {
                self.smallerCircleEnd = 0.001
            self.smallerRotationDegree = RotationDegrees.initialSmallCircle.getRotationDegrees()
        }
        
        
        Timer.scheduledTimer(withTimeInterval: animationDuration * 0.7, repeats: false) { _ in
            withAnimation(Animation.easeIn(duration: animationDuration * 0.4)) {
                self.smallerRotationDegree = RotationDegrees.middleSmallCircle.getRotationDegrees()
                self.rotationDegree = RotationDegrees.middleCircle.getRotationDegrees()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: false) { _ in
            withAnimation(Animation.easeOut(duration: animationDuration)) {
                self.rotationDegree = RotationDegrees.last.getRotationDegrees()
                self.circleEnd = 0.001
            }
            
            withAnimation(Animation.linear(duration: animationDuration * 0.8)) {
                self.smallerCircleEnd = 1
                self.smallerRotationDegree = RotationDegrees.last.getRotationDegrees()
            }
        }
    }
    
    func reset() {
        self.rotationDegree = .degrees(-90)
        self.smallerRotationDegree = Angle.degrees(-30)
    }
}


enum RotationDegrees {
    case initialCicle
    case initialSmallCircle
    
    case middleCircle
    case middleSmallCircle
    
    case last
    
    func getRotationDegrees() -> Angle {
        switch self {
        case .initialCicle:
            return .degrees(365)
        case .initialSmallCircle:
            return .degrees(679)
            
        case .middleCircle:
            return .degrees(375)
        case .middleSmallCircle:
            return .degrees(825)
            
        case .last:
            return .degrees(990)
        }
    }
}
