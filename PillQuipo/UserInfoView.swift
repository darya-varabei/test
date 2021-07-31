//
//  UserInfoView.swift
//  Care-time
//
//  Created by Дарья Воробей on 3/18/21.
//

import SwiftUI

enum Settings {
    static let notifications = "notifications"
}

class TextBindingManager: ObservableObject {
    @Published var text = "Example" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 20){
        characterLimit = limit
    }
}


struct UserInfoView: View {
    
    @ObservedObject var textBindingManager = TextBindingManager(limit: 20)
    @StateObject var modeldata = ModelData()
    @AppStorage(Settings.notifications) var notifications: Bool = false
    @State var notificationsOn = true
    @State var IsNameChange = false
    @State var showList = false
    @State private var showingAlert = false
    static let gradientStart = Color(ColorsSaved.gradientBlue)
    static let gradientEnd = Color(ColorsSaved.gradientTorquise)
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            
            ZStack(){
                NavigationLink("", destination: Detail(show: self.$notificationsOn), isActive: self.$notificationsOn)
                
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(width: UIScreen.main.bounds.width - 75, height: UIScreen.main.bounds.height - 305, alignment: .center)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
                    .shadow(radius: 15)
                ZStack{
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
                            
                            Image("logo")
                                .frame(width: 60, height: 60, alignment: .center)
                        }
                        
                        Text(textBindingManager.text)
                            .font(.system(size:20))
                            .foregroundColor(Color(ColorsSaved.textTorquise))
                            .bold()
                            .padding(.horizontal, 50)
                            .padding(.bottom, 7)

                            Text("Change name")
                                .foregroundColor(Color(ColorsSaved.gradientBlue))
                                .font(.system(size:16))
                                .onTapGesture {
                                    self.showingAlert.toggle()
                                    print(userKey)
                                    defineName()
                                }.padding(.bottom, 20)
                        
                        HStack{
                            Toggle(isOn: $notificationsOn) {
                                Text("Notifications")
                                    .foregroundColor(Color(ColorsSaved.textBlue))
                            }.onChange(of: notificationsOn, perform: { value in
                                notification = notificationsOn
                            })
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 80)
                        
                            Button(action: {
                                self.showList = true
                            }) {
                                HStack(spacing: 100){
                                Text("List of medications")
                                    .foregroundColor(Color(ColorsSaved.textBlue))
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color(ColorsSaved.textBlue))
                            }
                            
                        }.sheet(isPresented: $showList) {
                            FullListView()
                        }
                        
                        
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
                if self.showingAlert{
                    AlertControlView(textString: $textBindingManager.text,
                                                     showAlert: $showingAlert,
                                                     title: "Change username",
                                                     message: "Type in a textfield below")
                }
            }
        }
    }
    
    func defineName(){
        username = textBindingManager.text
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
