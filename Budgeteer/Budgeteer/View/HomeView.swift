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

#Preview {
    HomeView()
}
