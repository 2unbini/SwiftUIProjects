//
//  WeekView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct WeekView<DayView>: View where DayView: View {
    @Environment(\.calendar) var calendar
    
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
            ForEach(0..<7, id: \.self) { index in
                let day = days[index]
                if calendar.isDate(day, equalTo: week, toGranularity: .month) {
                    if (1...5).contains(index) {
                        dayView(day)
                    }
                    else {
                        dayView(day).foregroundColor(.gray)
                    }
                } else {
                    dayView(day).hidden()
                }
            }
        }
    }
}


