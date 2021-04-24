//
//  MainTabView.swift
//  Pillquipo
//
//  Created by Дарья Воробей on 4/23/21.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView{
            MainListView()
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            AddPillView()
                .tabItem{
                    Label("Add", systemImage: "plus.circle")
                }
            UserInfoView()
                .tabItem{
                    Label("Account", systemImage: "person")
                }
        }.onAppear(){
            UITabBar.appearance().barTintColor = .white
        }
        .accentColor(Color(ColorsSaved.gradientBlue))
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
