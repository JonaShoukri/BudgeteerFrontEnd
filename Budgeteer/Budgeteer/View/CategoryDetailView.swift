//
//  CategoryDetailView.swift
//  Budgeteer
//
//  Created by Jonas Shoukri on 2025-03-27.
//

import SwiftUI
import Charts

enum TimeFrame: String, CaseIterable {
    case day = "D"
    case week = "W"
    case month = "M"
    case sixMonths = "6M"
    case year = "Y"
}

struct CategoryDetailView: View {
    let category: String
    let transactions: [Transaction]
    
    @State private var selectedTimeFrame: TimeFrame = .month
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(category)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Picker("", selection: $selectedTimeFrame) {
                ForEach(TimeFrame.allCases, id: \.self) { frame in
                    Text(frame.rawValue).tag(frame)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            BarChartView(transactions: transactions, timeFrame: selectedTimeFrame)  // Pass timeFrame
                .frame(height: 300)
                .padding()
            
            List(transactions.sorted(by: { $0.date > $1.date })) { transaction in
                HStack {
                    VStack(alignment: .leading) {
                        Text(transaction.name)
                            .font(.headline)
                        Text(transaction.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text(String(format: "%.2f CAD", transaction.value))
                        .font(.headline)
                        .foregroundColor(transaction.value >= 0 ? .green : .red)
                }
                .padding(.vertical, 5)
            }
        }
        .navigationBarTitle(category, displayMode: .inline)
    }
}

import SwiftUI
import Charts

struct BarChartView: View {
    let transactions: [Transaction]
    let timeFrame: TimeFrame  // TimeFrame is passed here
    
    var body: some View {
        let groupedData = groupTransactions(transactions, by: timeFrame)  // Use timeFrame
        
        return Chart {
            ForEach(groupedData, id: \.key) { date, total in
                BarMark(
                    x: .value("Date", date),
                    y: .value("Total", total)
                )
                .foregroundStyle(total >= 0 ? Color.green : Color.red)
            }
        }
    }
    
    private func groupTransactions(_ transactions: [Transaction], by timeFrame: TimeFrame) -> [(key: Date, value: Double)] {
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Filter transactions based on timeFrame and the last available date
        let filteredTransactions: [Transaction]
        
        switch timeFrame {
        case .day:
            filteredTransactions = transactions.filter {
                currentDate.timeIntervalSince($0.date) <= 86400 // Last 24 hours (in seconds)
            }
        case .week:
            filteredTransactions = transactions.filter {
                currentDate.timeIntervalSince($0.date) <= 604800 // Last 7 days (in seconds)
            }
        case .month:
            filteredTransactions = transactions.filter {
                currentDate.timeIntervalSince($0.date) <= 2592000 // Last 30 days (in seconds)
            }
        case .sixMonths:
            filteredTransactions = transactions.filter {
                currentDate.timeIntervalSince($0.date) <= 15768000 // Last 6 months (in seconds)
            }
        case .year:
            filteredTransactions = transactions.filter {
                currentDate.timeIntervalSince($0.date) <= 31536000 // Last 1 year (in seconds)
            }
        }
        
        // Define the grouping logic based on timeFrame
        let dateGrouping: (Date) -> Date
        
        switch timeFrame {
        case .day:
            // Group by the hour of the day
            dateGrouping = { calendar.date(bySettingHour: calendar.component(.hour, from: $0), minute: 0, second: 0, of: $0)! }
        case .week:
            // Group by each day in the week
            dateGrouping = { calendar.startOfDay(for: $0) }
        case .month:
            // Group by each day in the month
            dateGrouping = { calendar.startOfDay(for: $0) }
        case .sixMonths:
            // Group by each week
            dateGrouping = { calendar.dateInterval(of: .weekOfYear, for: $0)?.start ?? $0 }
        case .year:
            // Group by month
            dateGrouping = { calendar.date(from: calendar.dateComponents([.year, .month], from: $0)) ?? $0 }
        }
        
        // Group the transactions by the defined date interval
        let grouped = Dictionary(grouping: filteredTransactions, by: { dateGrouping($0.date) })
            .mapValues { $0.reduce(0) { $0 + $1.value } }
        
        return grouped.sorted { $0.key < $1.key }
    }
}
