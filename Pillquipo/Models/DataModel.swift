//
//  UserModel.swift
//  Pillquipo
//
//  Created by Дарья Воробей on 4/23/21.
//

import Foundation
import SwiftUI
import Firebase

class ModelData: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var isSignUp = false
    @Published var email_SignUp = ""
    @Published var password_SignUp = ""
    @Published var reEnterPassword = ""
    @Published var isLinkSend = false
    @Published var alert = false
    @Published var alertMsg = ""
    @Published var key = ""
    
    @AppStorage("log_Status") var status = false
    
    @Published var isLoading = false
    
    func resetPassword(){
        
        let alert = UIAlertController(title: "Reset", message: "Enter your email to reset you password", preferredStyle: .alert)
        
        alert.addTextField{ (password) in
            password.placeholder = "Email"
        }
        let proceed = UIAlertAction(title: "Reset", style: .default){ (_) in
            if alert.textFields![0].text! != ""{
                withAnimation{
                    self.isLoading.toggle()
                }
                
                Auth.auth().sendPasswordReset(withEmail: alert.textFields![0].text!){ (err) in
                    withAnimation{
                        self.isLoading.toggle()
                    }
                    
                    if err != nil{
                        self.alertMsg = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    self.alertMsg = "Password reset link has been sent successfully"
                    self.alert.toggle()
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(proceed)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func login(){
        
        if email == "" || password == ""{
            self.alertMsg = "Fill the content properly"
            self.alert.toggle()
            return
        }
        
        withAnimation{
            self.isLoading.toggle()
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            
            withAnimation{
                self.isLoading.toggle()
            }
            
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            let user = Auth.auth().currentUser
            
            if !user!.isEmailVerified{
                self.alertMsg = "Verify your email address"
                self.alert.toggle()
                
                try! Auth.auth().signOut()
                
                return
            }
            
            withAnimation{
                self.status = true
            }
        }
    }
    
    func signUp(){
        
        if email_SignUp == "" || password_SignUp == "" || reEnterPassword == ""{
            self.alertMsg = "Fill the content properly"
            self.alert.toggle()
            return
        }
        
        if password_SignUp != reEnterPassword{
            self.alertMsg = "Password doesn't match"
            self.alert.toggle()
            return
        }
        
        withAnimation{
            self.isLoading.toggle()
        }
        
        Auth.auth().createUser(withEmail: email_SignUp, password: password_SignUp){  (result, err) in
            withAnimation{
                self.isLoading
            }
            if err != nil{
                self.alertMsg = err!.localizedDescription
                self.alert.toggle()
                return
            }
            
            result?.user.sendEmailVerification(completion: {(err) in
                
                if err != nil{
                    self.alertMsg = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.alertMsg = "Verify your email address"
                self.alert.toggle()
            })
        }
    }
    func logOut(){
        try! Auth.auth().signOut()
        
        withAnimation{
            self.status = false
        }
        
        email = ""
        password = ""
        email_SignUp = ""
        password_SignUp = ""
        reEnterPassword = ""
    }
    
    func getKey() -> User?{
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print("Error handling user key")
          }
        }
        return currentUser
    }
}


