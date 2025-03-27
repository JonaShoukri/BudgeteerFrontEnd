//
//  HomeView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI
import FirebaseFirestore

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
                        BudgetBarView(moneyCount: calculateTotal())
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
        let db = Firestore.firestore()
        db.collection("transactions").getDocuments { snapshot, error in
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
                
                return Transaction(name: name, category: category, value: value, date: timestamp.dateValue())
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
}

struct ListCard: View {
    let category: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(category)
                    .font(.headline)
                    .foregroundColor(.gray)
                HStack(alignment: .lastTextBaseline) {
                    Text(String(format: "%.2f", value))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("CAD")
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

struct BudgetBarView: View {
    var moneyCount: Double
    var maxAmount: Double = 860.71
    
    private var progress: Double {
        min(Double(moneyCount) / Double(maxAmount), 1.0)
    }
    private var overBudgetProgress: Double {
        moneyCount > maxAmount ? min(Double(moneyCount - maxAmount) / Double(maxAmount), 1.0) : 0.0
    }
    
    private var progressColor: Color {
        switch progress {
        case 0.7...1.0: return .green
        case 0.4..<0.7: return .orange
        default: return .red
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 1.0)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                    .frame(width: 200, height: 200)

                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(progressColor, lineWidth: 10)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 200, height: 200)
                    .animation(.easeOut(duration: 1.0), value: progress)
                
                if moneyCount > maxAmount {
                    Circle()
                        .trim(from: 0.0, to: CGFloat(overBudgetProgress))
                        .stroke(.blue, lineWidth: 10)
                        .rotationEffect(.degrees(-90))
                        .frame(width: 200, height: 200)
                        .animation(.easeOut(duration: 1.0), value: progress)
                }
                VStack{
                    Text("\(String(format: "%.2f", moneyCount))/\(String(format: "%.2f", maxAmount))")
                        .font(.title3)
                        .fontWeight(.bold)
                    Text("Current Amount")
                        .font(.headline)
                }
                
                
            }
        }
    }
}

#Preview {
    HomeView()
}
