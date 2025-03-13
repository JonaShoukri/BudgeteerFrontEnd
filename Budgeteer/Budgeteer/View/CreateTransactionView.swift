//
//  CreateTransactionView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI

struct CreateTransactionView: View {
    
    @State private var name: String = ""
        @State private var category: String = ""
        @State private var value: String = ""
        @State private var date: Date = Date()
        
        var onSave: ((Transaction) -> Void)?
    var body: some View {
        NavigationView {
                    Form {
                        Section(header: Text("Transaction Details")) {
                            TextField("Name", text: $name)
                            TextField("Category", text: $category)
                            TextField("Value", text: $value)
                                .keyboardType(.decimalPad)
                            DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
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
                guard let transactionValue = Double(value) else { return }
                let newTransaction = Transaction(name: name, category: category, value: transactionValue, date: date)
                onSave?(newTransaction)
            }
    }


#Preview {
    CreateTransactionView()
}
