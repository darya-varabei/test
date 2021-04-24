//
//  SwiftUIView.swift
//  Care-time
//
//  Created by Дарья Воробей on 2/22/21.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(Color(ColorsSaved.almostWhite))
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(ColorsSaved.gradientBlue)))
                .scaleEffect(2)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
