//
//  ContentView.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 4/26/21.
//

import CoreData
import Firebase
import Foundation
import SwiftUI

struct ColorsSaved {
    static let gradientBlue = UIColor( red: 0.385, green: 0.569, blue: 0.8, alpha: 1.0)
    static let gradientTorquise = UIColor( red: 0.346, green: 0.688, blue: 0.762, alpha: 1.0)
    static let customBlue =  UIColor(red: 0.863, green: 0.954, blue: 1, alpha: 1)
    static let textBlue = UIColor(red: 0.051, green: 0.118, blue: 0.251, alpha: 1)
    static let textTorquise =   UIColor(red: 0.069, green: 0.317, blue: 0.45, alpha: 1)
    static let almostWhite =   UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
    static let clear =   UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0)
}


struct ContentView: View {
    
    @State private var top: Bool = false
    let coreDM: CoreDataViewModel
    @State var isActive:Bool = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            
            Color(ColorsSaved.almostWhite)
            
            VStack(){
            HStack(spacing: self.spacing) {
                ForEach(0..<self.numberOfBalls, id: \.self) { i in
                    DNABalls(delay: (Double(i)/4),
                             ballSpeed: self.ballSpeed,
                             ballSize: self.ballSize,
                             firstBallColor: self.firstBallColor,
                             secondBallColor: self.secondBallColor)
                        .frame(width: self.ballSize, height: self.frameHeight)
                }
            }
                
                Text("PillQuipo")
                    .foregroundColor(Color(ColorsSaved.gradientBlue))
                    .font(Font.custom("Karla-Bold", size: 28))
            }
            .onAppear() {
                Timer.scheduledTimer(withTimeInterval: self.ballSpeed, repeats: true) { _ in
                    self.top.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            if self.isActive {
                HomeView( coreDM: coreDM)
                    .transition(.move(edge: .trailing))
            }
        }
    }
    let numberOfBalls: Int = 5
    let spacing: CGFloat = 20
    let ballSpeed: Double = 0.75
    let ballSize: CGFloat = 30
    let frameHeight: CGFloat = 60
    let firstBallColor:  LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    let secondBallColor: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing)
}

struct HomeView: View{
    @AppStorage("log_Status") var status = false
    @StateObject var model = ModelData()
    let coreDM: CoreDataViewModel
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(1), Color(ColorsSaved.gradientTorquise).opacity(1)]), startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.all)
            if status{
                MainTabView()
                    .transition(.move(edge: .trailing))
            }
            else {
                ScrollView(.vertical, showsIndicators: false){
                    Home()
                        .transition(.move(edge: .trailing))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(coreDM: CoreDataViewModel()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



struct Home: View {
    
    @State var index = 0
    @State var fontSize: CGFloat = 16
    
    @AppStorage("log_Status") var status = false
    @StateObject var model = ModelData()
    
    
    var body:  some View{
        VStack{
            Image("Union")
                .resizable()
                .frame(width: 80, height: 80)
            Text("PillQuipo")
                .font(.system(size: 24))
                .foregroundColor(Color(ColorsSaved.almostWhite))
            
            HStack{
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                        self.index=0
                    }
                }){
                    Text("Log in")
                        .font(Font.custom("Karla-Bold", size: 16))
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 80)/2)
                        .foregroundColor(self.index == 0 ? .black: .white)
                }.background(self.index == 0 ? Color.white: Color.clear)
                .clipShape(Capsule())
                
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                        self.index = 1
                    }
                }){
                    Text("Register")
                        .font(Font.custom("Karla-Bold", size: 16))
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 80)/2)
                        .foregroundColor(self.index == 1 ? .black: .white)
                }.background(self.index == 1 ? Color.white : Color.clear)
                .clipShape(Capsule())
            }.background(Color.black.opacity(0.1))
            .clipShape(Capsule())
            .padding(.top, 25)
            
            if self.index == 0 {
                Login()
                
            } else {
                SignUp()
            }
        }.padding(.top, 50)
    }
}



struct Login : View {
    
    @State var visible = false
    @StateObject var model = ModelData()
    @State var medication = CoreDataViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @State var countPositions = 2
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(
        entity: Medication.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Medication.generic_name, ascending: true)
        ]
    ) var medications: FetchedResults<Medication>
    
    var body: some View{
        ZStack{
            VStack{
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope")
                            .foregroundColor(.black)
                        
                        TextField("Email", text: self.$model.email)
                    }.padding(.vertical, 20)
                    
                    Divider()
                    HStack(spacing: 20){
                        Image(systemName: "lock")
                            .resizable()
                            .frame(width: 15, height: 18)
                            .foregroundColor(.black)
                        
                        ZStack(){
                            VStack{
                                if self.visible{
                                    TextField("Password", text: $model.password)
                                }
                                else{
                                    SecureField("Password", text: $model.password)
                                }
                            }
                            
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill": "eye.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }.padding(.leading, 200)
                        }
                    }.padding(.vertical, 20)
                }.padding(.vertical)
                .padding(.horizontal, 20)
                .padding(.bottom,40)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 25)
                
                Button(action:model.login){
                    Text("Login")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 100)
                }.background(LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(14)
                .offset(y: -40)
                .padding(.bottom, -40)
                .shadow(radius: 15)
            }
            .padding(.horizontal, 20)
            
            Button(action: model.resetPassword){
                Text("Forgot password?")
                    .fontWeight(.bold)
                    .foregroundColor(Color(ColorsSaved.almostWhite))
            }.padding(.vertical, 22)
            .offset(y: 180)
            .alert(isPresented: $model.alert, content: {
                Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok")))
            })
            if model.isLoading{
                LoadingView()
            }
        }
    }
}



struct SignUp : View {
    
    @StateObject var model = ModelData()
    @State var repassword = ""
    @State var visible = false
    @State var revisible = false
    @State var message = false
    
    var body : some View{
        ZStack{
            VStack{
                VStack{
                    HStack(spacing: 15){
                        Image(systemName: "envelope")
                            .foregroundColor(.black)
                        
                        TextField("Email", text: self.$model.email_SignUp)
                    }.padding(.vertical, 20)
                    
                    Divider()
                    HStack(spacing: 20){
                        Image(systemName: "lock")
                            .resizable()
                            .frame(width: 15, height: 18)
                            .foregroundColor(.black)
                        
                        ZStack(){
                            VStack{
                                if self.visible{
                                    TextField("Password", text: $model.password_SignUp)
                                }
                                else{
                                    
                                    SecureField("Password", text: $model.password_SignUp)
                                }
                            }
                            Button(action: {
                                self.visible.toggle()
                            }) {
                                Image(systemName: self.visible ? "eye.slash.fill": "eye.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }.padding(.leading, 200)
                        }
                    }.padding(.vertical, 20)
                    
                    Divider()
                    HStack(spacing: 20){
                        Image(systemName: "lock")
                            .resizable()
                            .frame(width: 15, height: 18)
                            .foregroundColor(.black)
                        
                        ZStack(){
                            VStack{
                                if self.revisible{
                                    TextField("Repeat Password", text: $model.reEnterPassword)
                                }
                                else{
                                    
                                    SecureField("Repeat Password", text: $model.reEnterPassword)
                                }
                            }
                            Button(action: {
                                self.revisible.toggle()
                            }) {
                                Image(systemName: self.revisible ? "eye.slash.fill": "eye.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing)
                            }.padding(.leading, 200)
                        }
                    }.padding(.vertical, 20)
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
                .padding(.bottom,40)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 25)
                
                Button(action:{
                    model.signUp()
                    message = true
                }){
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 100)
                }.background(LinearGradient(gradient: Gradient(colors: [Color(ColorsSaved.gradientBlue).opacity(0.9), Color(ColorsSaved.gradientTorquise).opacity(0.9)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(8)
                .offset(y: -40)
                .padding(.bottom, -40)
                .shadow(radius: 15)
            }
            .padding(.horizontal, 20)
            
            .alert(isPresented: $model.alert, content: {
                Alert(title: Text("Message"), message: Text(model.alertMsg), dismissButton: .destructive(Text("Ok"), action: {
                    message = false
                    
                    if model.alertMsg == "Email verification has been sent"{
                        
                        model.isSignUp.toggle()
                        model.email_SignUp = ""
                        model.password_SignUp = ""
                        model.reEnterPassword = ""
                    }
                }))
            })
            if (model.isLoading || message){
                LoadingView()
            }
        }
    }
}

