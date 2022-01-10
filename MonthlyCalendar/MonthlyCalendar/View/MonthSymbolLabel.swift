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
        let suffix: String = "월"
        let stringifiedMonth: String = String(calendar.component(.month, from: month))
        return stringifiedMonth + suffix
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
            .frame(maxWidth: .infinity)
            .hidden()
            .overlay(
                Text(symbolOfMonth)
                    .font(.system(size: 19)).bold()
            )
    }
    
    init(of month: Date, upon week: Date) {
        self.week = week
        self.month = month
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(daysOfWeek, id: \.self) { day in
                if day == startDayOfMonth {
                    symbolLabel
                }
                else {
                    symbolLabel.hidden()
                }
            }
        }
        .padding([.top, .bottom], 10)
    }
}


