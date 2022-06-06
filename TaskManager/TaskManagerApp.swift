//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by Viatcheslav Lebedev on 31.05.2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}


@main
struct TaskManagerApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if let user = AuthService.shared.currentUser {
                MainScreenView(viewModel: MainScreenViewModel(user: user, isStart: true))
            } else {
                AuthView(viewModel: AuthViewModel())
            }
        }
    }
}
