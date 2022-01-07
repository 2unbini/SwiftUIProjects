//
//  YearView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct YearView<DayView>: View where DayView: View {
    @Environment(\.calendar) var calendar: Calendar
    @ObservedObject var currentDay: CurrentDayViewModel
    
    let year: Date
    let content: (Date) -> DayView
    
    init(of year: Date, _ currentDay: CurrentDayViewModel, @ViewBuilder content: @escaping (Date) -> DayView) {
        self.year = year
        self.content = content
        self.currentDay = currentDay
    }
    
    // 해당 년도의 달 배열
    private var months: [Date] {
        guard let yearInterval = calendar.dateInterval(of: .year, for: year) else { return [] }
        return calendar.generateDates(
            interval: yearInterval,
            with: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        LazyVStack {
            ForEach(months, id: \.self) { month in
                MonthView(of: month, currentDay, content: content)
            }
        }
    }
}
