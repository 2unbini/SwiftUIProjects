//
//  WeekView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct WeekView<DayView>: View where DayView: View {
    @Environment(\.calendar) var calendar: Calendar
    
    let week: Date
    let dayView: (Date) -> DayView
    
    init(of week: Date, @ViewBuilder content: @escaping (Date) -> DayView) {
        self.week = week
        self.dayView = content
    }
    
    // 해당 주의 일 배열
    private var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week) else { return [] }
        
        return calendar.generateDates(
            interval: weekInterval,
            with: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(days, id: \.self) { day in
                if calendar.isDate(day, equalTo: week, toGranularity: .month) {
                    dayView(day)
                } else {
                    dayView(day).hidden()
                }
            }
        }
    }
}


