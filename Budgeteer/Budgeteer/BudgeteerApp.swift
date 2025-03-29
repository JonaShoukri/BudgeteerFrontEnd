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
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                ContentView()
            } else {
                SignInView()
            }
        }
    }
}

