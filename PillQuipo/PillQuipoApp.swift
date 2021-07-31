//
//  PillQuipoApp.swift
//  PillQuipo
//
//  Created by Дарья Воробей on 4/26/21.
//

//разрешение на отправку уведомлений

import SwiftUI
import Firebase

@main
struct PillQuipoApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(Delegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            
            ContentView(coreDM: CoreDataViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}

class Delegate: NSObject, UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge]) {(granted, error) in
                    print("Permission granted: \(granted)")
            }
    }
}
