//
//  SignInView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage = ""
    @State private var isSignedIn = false
    @State private var navigateToSignUp = false
    
    var body: some View {
        if isSignedIn {
                    ContentView()
                } else if navigateToSignUp {
                    SignUpView()
                } else {VStack(spacing: 20) {
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.callout)
                        .padding(.horizontal)
                }
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Button(action: validateInputs) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                    
                    Button(action: { navigateToSignUp = true }) {
                                        Text("Don't have an account? Sign Up")
                                            .font(.callout)
                                            .foregroundColor(.blue)
                                            .padding(.top, 10)
                                    }
            }
            .padding()
        }
    }
    
    func validateInputs() {
        errorMessage = ""
        
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format"
            return
        }
        
        guard !password.isEmpty else {
            errorMessage = "Password is required"
            return
        }
        
        // Proceed with sign-in logic
        isSignedIn = true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailRegex.evaluate(with: email)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
