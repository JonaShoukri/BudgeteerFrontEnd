//
//  Overview.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-11.
//

import SwiftUI

struct OverviewView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Overview")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    
                    OverviewCard(title: "Current Savings", value: "7,850", unit: "CAD", color: .gray)
                    OverviewCard(title: "Average Savings Per Cicle", value: "72", unit: "CAD", color: .gray)
                    OverviewCard(title: "Savings Rate", value: "8.4", unit: "%", color: .gray)
                    OverviewCard(title: "Biggest Expenses", value: "1. Mortgage", unit: "2. Groceries", color: .gray)
                    OverviewCard(title: "Total Savings", value: "1. Mortgage", unit: "2. Groceries", color: .gray)
                    
                    Spacer()
                }
                .padding(.top)
            }
        }
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
