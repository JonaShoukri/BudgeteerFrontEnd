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
    let timeFrame: TimeFrame

    var body: some View {
        let groupedData = groupTransactions(transactions, by: timeFrame)
        
        Chart {
            ForEach(groupedData, id: \.key) { date, total in
                BarMark(
                    x: .value("Date", date),
                    y: .value("Total", total)
                )
                .foregroundStyle(total >= 0 ? Color.green : Color.red)
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { mark in
                if let dateValue = mark.as(Date.self) {
                    AxisValueLabel {
                        Text(dateValue, format: dateFormat(for: timeFrame))
                    }
                }
            }
        }
    }

    private func dateFormat(for timeFrame: TimeFrame) -> Date.FormatStyle {
        switch timeFrame {
        case .day:
            return Date.FormatStyle().hour(.defaultDigits(amPM: .abbreviated))
        case .week, .month:
            return Date.FormatStyle().month(.abbreviated).day(.defaultDigits)
        case .sixMonths, .year:
            return Date.FormatStyle().month(.abbreviated).year()
        }
    }

    private func groupTransactions(_ transactions: [Transaction], by timeFrame: TimeFrame) -> [(key: Date, value: Double)] {
        let calendar = Calendar.current
        let now = Date()

        let startDate: Date = {
            switch timeFrame {
            case .day:
                return calendar.date(byAdding: .day, value: -1, to: now)!
            case .week:
                return calendar.date(byAdding: .day, value: -7, to: now)!
            case .month:
                return calendar.date(byAdding: .month, value: -1, to: now)!
            case .sixMonths:
                return calendar.date(byAdding: .month, value: -6, to: now)!
            case .year:
                return calendar.date(byAdding: .year, value: -1, to: now)!
            }
        }()

        let filteredTransactions = transactions.filter { $0.date >= startDate }

        let dateGrouping: (Date) -> Date = { date in
            switch timeFrame {
            case .day:
                return calendar.date(bySettingHour: calendar.component(.hour, from: date), minute: 0, second: 0, of: date)!
            case .week, .month:
                return calendar.startOfDay(for: date)
            case .sixMonths:
                return calendar.dateInterval(of: .weekOfYear, for: date)!.start
            case .year:
                return calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            }
        }

        var grouped = Dictionary(grouping: filteredTransactions, by: { dateGrouping($0.date) })
            .mapValues { $0.reduce(0) { $0 + $1.value } }

        // Fill missing dates with 0
        let allDates = generateTimeIntervals(from: startDate, to: now, for: timeFrame)
        for date in allDates where grouped[date] == nil {
            grouped[date] = 0
        }

        return grouped.sorted { $0.key < $1.key }
    }

    private func generateTimeIntervals(from start: Date, to end: Date, for timeFrame: TimeFrame) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        var current = start

        while current <= end {
            dates.append(current)
            switch timeFrame {
            case .day:
                current = calendar.date(byAdding: .hour, value: 1, to: current)!
            case .week, .month:
                current = calendar.date(byAdding: .day, value: 1, to: current)!
            case .sixMonths:
                current = calendar.date(byAdding: .weekOfYear, value: 1, to: current)!
            case .year:
                current = calendar.date(byAdding: .month, value: 1, to: current)!
            }
        }

        return dates
    }
}
