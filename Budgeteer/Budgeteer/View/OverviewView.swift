//
//  Overview.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct OverviewView: View {
    @State private var transactions: [Transaction] = []
    @State private var totalSpent: Double = 0.0
    @State private var biggestExpenses: [String] = []  // To store top 2 categories of biggest expenses
    
    var totalSavings: Double {
        transactions.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Overview")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    OverviewCard(title: "Current Savings", value: String(format: "%.2f", totalSavings), unit: "CAD", color: .gray)
                    OverviewCard(title: "Amount Spent", value: formatCurrency(totalSpent), unit: "CAD", color: .red)
                    
                    // Show biggest expenses
                    // Show biggest expenses with numbers
                                        OverviewCard(title: "Biggest Expenses", value: biggestExpenses.prefix(2).enumerated().map { "\($0.offset + 1). \($0.element)" }.joined(separator: ", "), unit: "", color: .gray)
                                        
                    
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
        .onAppear(perform: fetchTransactions)
    }
    
    private func fetchTransactions() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is signed in")
            return
        }

        let db = Firestore.firestore()
        db.collection("transactions").whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
                return
            }

            transactions = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let category = data["category"] as? String,
                      let value = data["value"] as? Double,
                      let timestamp = data["date"] as? Timestamp else { return nil }
                
                return Transaction(userId: userId, name: name, category: category, value: value, date: timestamp.dateValue())
            } ?? []
            
            // After fetching transactions, calculate the total spent and update the state
            totalSpent = calculateTotalSpent(from: transactions)
            
            // Update biggest expenses
            biggestExpenses = getBiggestExpenses(from: transactions)
        }
    }
    
    private func calculateTotalSpent(from transactions: [Transaction]) -> Double {
        return transactions
            .filter { $0.value < 0 }  // Assuming negative values indicate expenses
            .reduce(0) { $0 + $1.value }
    }
    
    private func getBiggestExpenses(from transactions: [Transaction]) -> [String] {
        // Group transactions by category and sum their expenses
        let expenseCategories = transactions
            .filter { $0.value < 0 }  // Only consider expenses
            .reduce(into: [String: Double]()) { result, transaction in
                result[transaction.category, default: 0] += transaction.value
            }
        
        // Sort categories by total expense and take the top 2
        let sortedCategories = expenseCategories
            .sorted { $0.value < $1.value }  // Sort by expense amount (ascending)
        
        // Return the top 2 categories with the highest expenses
        return sortedCategories.prefix(2).map { $0.key }
    }
        
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}

struct OverviewCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.gray)
                HStack(alignment: .lastTextBaseline) {
                    Text(value)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(unit)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.2))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
