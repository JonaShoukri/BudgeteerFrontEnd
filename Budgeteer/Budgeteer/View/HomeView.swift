//
//  HomeView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Home")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    HStack {
                        BudgetBarView(moneyCount: 969.80)
                    }
                    .frame(maxWidth: .infinity)
                    
                    ListCard(category: "Pay check", value: 768.89, color: .gray)
                    ListCard(category: "Groceries", value: -126.78, color: .gray)
                    ListCard(category: "Snacks", value: -8.48, color: .gray)
                    ListCard(category: "OPUS", value: -60, color: .gray)
                    ListCard(category: "Rent", value: -600, color: .gray)
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
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
