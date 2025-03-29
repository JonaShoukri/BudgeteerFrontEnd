//
//  HomeView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {
    @State private var transactions: [Transaction] = []
        
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Home")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.leading)
                        
                        HStack {
                            BudgetBar(moneyCount: calculateTotal(), maxAmount: calculateMaxAmount())
                        }
                        .frame(maxWidth: .infinity)
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: CreateTransactionView(onSave: { transaction in
                                transactions.append(transaction)
                            })) {
                                Image(systemName: "plus")
                                    .font(.title)
                                    .padding()
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.trailing)
                        
                        VStack {
                            if transactions.isEmpty {
                                Text("No transactions yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(groupedTransactions(), id: \.key) { category, totalValue in
                                    NavigationLink(destination: CategoryDetailView(category: category, transactions: transactions.filter { $0.category == category })) {
                                        ListCard(category: category, value: totalValue, color: totalValue >= 0 ? .green : .red)
                                    }
                                }
                            }
                        }
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
                      let timestamp = data["date"] as? Timestamp,
                      let userId = data["userId"] as? String else { return nil }

                return Transaction(userId: userId, name: name, category: category, value: value, date: timestamp.dateValue())
            } ?? []
        }
    }
    
    private func groupedTransactions() -> [(key: String, value: Double)] {
        let grouped = Dictionary(grouping: transactions, by: { $0.category })
            .mapValues { $0.reduce(0) { $0 + $1.value } }
        return grouped.sorted { $0.key < $1.key }
    }
    
    private func calculateTotal() -> Double {
           return transactions.reduce(0) { $0 + $1.value }
    }
    
    private func calculateMaxAmount() -> Double {
            return transactions.filter { $0.value > 0 }.reduce(0) { $0 + $1.value }
    }
}

#Preview {
    HomeView()
}
