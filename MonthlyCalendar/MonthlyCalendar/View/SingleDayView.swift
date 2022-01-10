//
//  SingleDayView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct DayView: View {
    let date: Date
    let calendarConfig: CalendarConfiguration
    let isSameDayAsToday: Bool
    let isWeekend: Bool
    let hasSchedule: Bool = true
    
    init(presenting date: Date, isWeekend: Bool, with calendarConfig: CalendarConfiguration) {
        self.date = date
        self.calendarConfig = calendarConfig
        self.isSameDayAsToday = calendarConfig.isSameDayAsToday(date)
        self.isWeekend = isWeekend
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ZStack(alignment: .center) {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isSameDayAsToday ? .red : .clear)
                Text("\(calendarConfig.calendar.component(.day, from: date))")
                    .font(.system(size: 17))
                    .foregroundColor(isSameDayAsToday ? .white : isWeekend ? .gray : .black)
            }
            .padding(.top, 5)
            if hasSchedule {
                Circle()
                    .font(.system(size: 10))
                    .foregroundColor(.gray.opacity(0.3))
                    .padding(.top, 3)
            }
        }
        .padding(.bottom, 30)
    }
}

