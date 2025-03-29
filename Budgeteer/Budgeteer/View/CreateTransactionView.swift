//
//  CreateTransactionView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct CreateTransactionView: View {
    
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var value: String = ""
    @State private var date: Date = Date()
    @State private var isExpense: Bool = true  // Default: Expense
    
    @Environment(\.presentationMode) var presentationMode  // Add this
    
    var onSave: ((Transaction) -> Void)?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Transaction Details")) {
                    TextField("Name", text: $name)
                    TextField("Category", text: $category)
                    
                    TextField("Value", text: $value)
                        .keyboardType(.decimalPad)
                        .onChange(of: value) { newValue in
                            value = newValue.filter { $0.isNumber || $0 == "." } // Prevents negatives
                        }
                    
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                    
                    Picker("Transaction Type", selection: $isExpense) {
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Button(action: saveTransaction) {
                    Text("Save Transaction")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("New Transaction")
        }
    }
    
    private func saveTransaction() {
        guard let user = Auth.auth().currentUser else {
            print("No user is signed in.")
            return
        }

        guard let transactionValue = Double(value), transactionValue >= 0 else {
            print("Invalid value: must be a non-negative number")
            return
        }

        let adjustedValue = isExpense ? -transactionValue : transactionValue
        let transaction = Transaction(userId: user.uid, name: name, category: category, value: adjustedValue, date: date)

        let db = Firestore.firestore()
        db.collection("transactions").addDocument(data: [
            "name": transaction.name,
            "category": transaction.category,
            "value": adjustedValue,
            "date": transaction.date,
            "userId": user.uid // Store userId
        ]) { error in
            if let error = error {
                print("Error adding transaction: \(error.localizedDescription)")
            } else {
                print("Transaction successfully added!")
                onSave?(transaction)
                presentationMode.wrappedValue.dismiss() // Dismiss view after saving
            }
        }
    }
}

#Preview {
    CreateTransactionView()
}
