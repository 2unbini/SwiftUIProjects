//
//  WeekView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct WeekView: View {
    let weekdayRange: Range = Range(1...5)
    let week: Date
    let calendarConfig: CalendarConfiguration
    
    init(of week: Date, _ calendarConfig: CalendarConfiguration) {
        self.week = week
        self.calendarConfig = calendarConfig
    }
    
    // 해당 주의 일 배열
    private var days: [Date] {
        guard let weekInterval = calendarConfig.calendar.dateInterval(of: .weekOfMonth, for: week) else { return [] }
        
        return calendarConfig.calendar.generateDates(
            interval: weekInterval,
            with: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                let day = days[index]
                if calendarConfig.calendar.isDate(day, equalTo: week, toGranularity: .month) {
                    DayView(presenting: day, isWeekend: weekdayRange.contains(index) ? false : true, with: calendarConfig)
                } else {
                    DayView(presenting: day, isWeekend: false, with: calendarConfig).hidden()
                }
            }
        }
    }
}


