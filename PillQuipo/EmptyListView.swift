//
//  EmptyListView.swift
//  testui
//
//  Created by Дарья Воробей on 2/27/21.
//

import SwiftUI

var username = "Example"
var notification = false
var userKey = ""

struct EmptyListView: View {
    var body: some View {
        ZStack{
            Color(ColorsSaved.clear).opacity(0)
                .edgesIgnoringSafeArea(.all)
            VStack(){
                
                Text("😇")
                    .font(.system(size: 80))
                    .padding(.top, 48)
                
                Text("No scheduled medications for this day")
                    .font(Font.custom("Karla-Bold", size: 18))
                    .padding(.top, 16)
                    .frame(width: 235, height: 65)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
            }
        }
    }
}

struct EmptyListView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyListView()
    }
}
