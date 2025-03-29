//
//  Transaction.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-12.
//

import Foundation

struct Transaction: Identifiable {
    let id: UUID = UUID()
    let userId: String
    let name: String
    let category: String
    let value: Double
    let date: Date
}
