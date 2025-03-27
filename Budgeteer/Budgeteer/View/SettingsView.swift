//
//  HomeView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SettingsView: View {
    @State private var fullName: String = "Loading..."
    @State private var email: String = "Loading..."
    @State private var isLoading = true
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Text("Account")
                .font(.largeTitle)
                .bold()
            
            // Profile Image
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            // User Info
            if isLoading {
                ProgressView()
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Name: \(fullName)")
                    Text("Email: \(email)")
                }
                .font(.body)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
            }
            
            // Buttons
            Button(action: {
                // Edit Profile Action
            }) {
                Text("Edit Profile")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: logOut) {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
            Spacer()
        }
        .padding()
        .onAppear {
            fetchUserData()
        }
    }
    
    func logOut() {
            do {
                try Auth.auth().signOut()
                // Close the current view and return to the SignIn screen
                presentationMode.wrappedValue.dismiss()
            } catch {
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    
    private func fetchUserData() {
        guard let user = Auth.auth().currentUser else { return }
        email = user.email ?? "Unknown"
        
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).getDocument { document, error in
            if let document = document, document.exists, let data = document.data() {
                fullName = data["fullName"] as? String ?? "No Name"
            } else {
                fullName = "No Name"
            }
            isLoading = false
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SettingsView()
}

