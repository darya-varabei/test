//
//  PillquipoApp.swift
//  Pillquipo
//
//  Created by Дарья Воробей on 4/23/21.
//

import SwiftUI
import Firebase

@main
struct PillquipoApp: App {
    // let persistenceController = PersistenceController.shared
     @UIApplicationDelegateAdaptor(Delegate.self) var delegate
     var body: some Scene {
         WindowGroup {
             ContentView()
 //                .environment(\.managedObjectContext, persistenceController.container.viewContext)
         }
     }
}

class Delegate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didRecive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.actionIdentifier == "open"{
            NotificationCenter.default.post(name: NSNotification.Name("Detail"), object: nil)
        }
    }
}

