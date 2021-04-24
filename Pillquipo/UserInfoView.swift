//
//  UserInfoView.swift
//  Pillquipo
//
//  Created by Дарья Воробей on 4/23/21.
//

import SwiftUI

enum Settings {
    static let notifications = "notifications"
}

struct UserInfoView: View {
    
    @StateObject var model = ModelUser()
    @StateObject var modeldata = ModelData()
    @AppStorage(Settings.notifications) var notifications: Bool = false
    @State var notificationsOn = false
    
    static let gradientStart = Color(ColorsSaved.gradientBlue)
    static let gradientEnd = Color(ColorsSaved.gradientTorquise)
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ZStack(){
                NavigationLink("", destination: Detail(show: self.$notificationsOn), isActive: self.$notificationsOn)
                    
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: 300, height: 300, alignment: .center)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
                    .shadow(radius: 15)
                VStack(){
                    ZStack{
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(LinearGradient(
                                gradient: .init(colors: [Self.gradientStart, Self.gradientEnd]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 90, height: 90, alignment: .top)
                            .shadow(radius: 10 )
                        
                        Image("Union")
                            .frame(width: 60, height: 60, alignment: .center)
                    }
                    
                    Text(model.userName)
                        .font(.system(size:20))
                        .foregroundColor(Color(ColorsSaved.textTorquise))
                        .bold()
                        .padding(.horizontal, 50)
                        .padding(.bottom, 7)
                    Button(action: {
                        sendNotifications()
                    }){
                        Text("Change name")
                            .font(.system(size:16))
                    }.padding(.bottom, 20)
                    
                    HStack{
                        Toggle(isOn: $notificationsOn) {
                                Text("Notifications")
                            }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 60)
                    
                    
                    Button(action:modeldata.logOut, label:{
                        Text("Quit")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 200)
                        
                    }).background(LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .cornerRadius(14)
                    .offset(y: 40)
                    .padding(.bottom, -40)
                    .shadow(radius: 15)
                }.padding(.bottom,100)
            }
        }
    }
    
    func sendNotifications(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {  (_, _) in
            
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Message"
        content.body = "Message"
        
        let open = UNNotificationAction(identifier: "open", title: "Open", options: .foreground)
        let cancel = UNNotificationAction(identifier: "cancel", title: "Cancel", options: .destructive)
        
        let categories = UNNotificationCategory(identifier: "action", actions: [open, cancel], intentIdentifiers: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([categories])
        
        content.categoryIdentifier = "action"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let req = UNNotificationRequest(identifier: "req", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView()
    }
}

struct Detail: View{
    
    @Binding var  show: Bool
    
    var body: some View{
        
        Text("Detail")
            .navigationBarTitle("Detail view")
            .navigationBarBackButtonHidden(true)
    }
}
