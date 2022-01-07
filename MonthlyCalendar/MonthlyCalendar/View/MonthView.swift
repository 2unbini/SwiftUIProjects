//
//  MonthView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct MonthView<DayView>: View where DayView: View {
    @Environment(\.calendar) var calendar: Calendar
    @ObservedObject var currentDay: CurrentDayState
    
    let month: Date
    let content: (Date) -> DayView
    
    init(of month: Date, _ currentDay: CurrentDayState, @ViewBuilder content: @escaping (Date) -> DayView) {
        self.month = month
        self.content = content
        self.currentDay = currentDay
    }
    
    // 해당 월의 주 배열
    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        
        return calendar.generateDates(
            interval: monthInterval,
            with: DateComponents(hour:0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<weeks.count, id: \.self) { nth in
                if nth == 0 {
                    MonthLabel(of: month, upon: weeks[nth])
                }
                WeekView(of: weeks[nth], content: content)
                    .onAppear {
                        currentDay.changeYear(with: month)
                    }
            }
        }
    }
}
