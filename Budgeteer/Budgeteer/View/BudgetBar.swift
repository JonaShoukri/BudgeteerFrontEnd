//
//  BudgetBar.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-29.
//

import SwiftUI

struct BudgetBar: View {
    var moneyCount: Double
    var maxAmount: Double
    
    private var progress: Double {
        maxAmount > 0 ? min(moneyCount / maxAmount, 1.0) : 0.0
    }
    
    private var overBudgetProgress: Double {
        moneyCount > maxAmount ? min((moneyCount - maxAmount) / maxAmount, 1.0) : 0.0
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
                
                VStack {
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
