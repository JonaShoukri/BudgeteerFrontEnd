//
//  BudgeteerApp.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct BudgeteerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var isUserLoggedIn: Bool? = nil

    var body: some Scene {
        WindowGroup {
            if let isUserLoggedIn = isUserLoggedIn {
                if isUserLoggedIn {
                    ContentView()
                } else {
                    SignInView()
                }
            } else {
                // Show a loading view while checking authentication
                ProgressView()
                    .onAppear(perform: checkAuthState)
            }
        }
    }

    // Check if user is already authenticated
    func checkAuthState() {
        if Auth.auth().currentUser != nil {
            isUserLoggedIn = true
        } else {
            isUserLoggedIn = false
        }
    }
}
