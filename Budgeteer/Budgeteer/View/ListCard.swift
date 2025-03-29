//
//  ListCard.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-29.
//

import SwiftUI

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
