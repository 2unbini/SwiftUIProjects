//
//  YearView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct YearView: View {
    @EnvironmentObject var calendarConfig: CalendarConfiguration
    
    let year: Date
    
    init(of year: Date) {
        self.year = year
    }
    
    // 해당 년도의 달 배열
    private var months: [Date] {
        guard let yearInterval = calendarConfig.calendar.dateInterval(of: .year, for: year) else { return [] }
        return calendarConfig.calendar.generateDates(
            interval: yearInterval,
            with: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        LazyVStack {
            ForEach(months, id: \.self) { month in
                MonthView(of: month)
                    .id(month)
            }
        }
    }
}
