//
//  SignUpView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isSignedUp = false
    @State private var navigateToSignIn = false

    var body: some View {
        if isSignedUp {
            ContentView()
        } else if navigateToSignIn {
            SignInView()
        } else {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .padding(.horizontal)
                }

                TextField("Full Name", text: $fullName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button(action: signUp) {
                    Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

                Button(action: { navigateToSignIn = true }) {
                    Text("Sign In")
                        .font(.callout)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
            }
            .padding()
        }
    }

    func signUp() {
        errorMessage = ""

        guard !fullName.isEmpty else {
            errorMessage = "Full name is required"
            return
        }

        guard isValidEmail(email) else {
            errorMessage = "Invalid email format"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        // Firebase Authentication
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else if let user = result?.user {
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "fullName": fullName,
                    "email": email,
                    "uid": user.uid
                ]) { err in
                    if let err = err {
                        errorMessage = err.localizedDescription
                    } else {
                        isSignedUp = true
                    }
                }
            }
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailRegex.evaluate(with: email)
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
