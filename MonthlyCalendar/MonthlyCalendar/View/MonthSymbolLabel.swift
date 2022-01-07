//
//  MonthSymbolLabel.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct MonthLabel: View {
    @Environment(\.calendar) var calendar
    let week: Date
    let month: Date
    
    private var symbolOfMonth: String {
        var symbol: String = ""
        let suffix: String = "월"
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM"
        let stringifiedMonth: String = formatter.string(from: week)
        
        switch stringifiedMonth.hasPrefix("0") {
        case true:
            symbol = stringifiedMonth.filter { $0 != "0" } + suffix
        case false:
            symbol = stringifiedMonth + suffix
        }
        
        return symbol
    }
    
    private var startDayOfMonth: Date {
        return calendar.startOfDay(for: month)
    }
    
    private var daysOfWeek: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week) else { return [] }
        let dateComponent = DateComponents(hour: 0, minute: 0, second: 0)
        return calendar.generateDates(interval: weekInterval, with: dateComponent)
    }
    
    private var symbolLabel: some View {
        return Text("Day")
            .hidden()
            .padding([.leading, .trailing], 6)
            .padding(.top, 10)
            .overlay(
                Text(symbolOfMonth)
                    .fontWeight(.semibold)
            )
    }
    
    init(of month: Date, upon week: Date) {
        self.week = week
        self.month = month
    }
    
    var body: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                if day == startDayOfMonth {
                    symbolLabel
                }
                else {
                    symbolLabel.hidden()
                }
            }
        }
    }
}


