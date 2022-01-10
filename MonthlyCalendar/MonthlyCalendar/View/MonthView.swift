//
//  MonthView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct MonthView<DayView>: View where DayView: View {
    @Environment(\.calendar) var calendar: Calendar
    @ObservedObject var calendarConfig: CalendarConfiguration
    
    let month: Date
    let content: (Date) -> DayView
    
    init(of month: Date, _ calendarConfig: CalendarConfiguration, @ViewBuilder content: @escaping (Date) -> DayView) {
        self.month = month
        self.content = content
        self.calendarConfig = calendarConfig
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
        LazyVStack {
            ForEach(0..<weeks.count, id: \.self) { nth in
                if nth == 0 {
                    MonthLabel(of: month, upon: weeks[nth])
                        .foregroundColor(calendarConfig.isSameMonthAsToday(month) ? .red : .black)
                        .onAppear {
                            // 월에 대한 라벨이 나올 때만 업데이트 -> 터치에 그나마 조금 덜 반응 + 월이 시작될 때 바뀜
                            calendarConfig.changeYearString(with: month)
                        }
                }
                WeekView(of: weeks[nth], content: content)
            }
        }
    }
}
