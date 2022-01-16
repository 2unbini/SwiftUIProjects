//
//  ContentView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct ContentView: View {
    @StateObject var calendarConfig: CalendarConfiguration = CalendarConfiguration()
    
    var body: some View {
        CalendarView()
            .environmentObject(calendarConfig)
//        MyCalendarView()
    }
}

let calendar = Calendar(identifier: .gregorian)

struct MyCalendarView: View {
    
//    let year : Int
//    let month : Int
    let initialScrollDateId : Date = calendar.date(from: DateComponents(year: calendar.component(.year, from: Date()), month: calendar.component(.month, from: Date()))) ?? Date()
    
    init() {
//        let today = Date()
//        self.year = calendar.component(.year, from: today)
//        self.month = calendar.component(.month, from: today)
//        self.initialScrollDateId = calendar.date(from: DateComponents(year: year, month: month)) ?? Date()
    }
    
    private var years: [Date] {
        // 2000~2100에 해당하는 기간 동안 뷰에 표시할 years 배열 (구현 생략)
        // 참고: 코드 하단 깃허브 주소
        
        let startDate = DateComponents(year: 2000, month: 1, day: 1)
        let endDate = DateComponents(year: 2100, month: 12, day: 31)
        
        return calendar.generateDates(
            interval: DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!),
            with: DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack {
                    ForEach(years, id: \.self) { year in
                        Yearly(of: year)
                    }
                }
            }
            .onAppear {
//                DispatchQueue.global(qos: .userInteractive).async {
//                    proxy.scrollTo(initialScrollDateId, anchor: .top)
//                }
                    proxy.scrollTo(initialScrollDateId, anchor: .top)
            }
        }
    }
}

struct Yearly: View {
    let year: Date

    init(of year: Date) {
        self.year = year
    }

    private var months: [Date] {
        // year에 해당하는 기간 동안 뷰에 표시할 months 배열 (구현 생략)
        // 참고: 코드 하단 깃허브 주소
        
        guard let yearInterval = calendar.dateInterval(of: .year, for: year) else { return [] }
        return calendar.generateDates(
            interval: yearInterval,
            with: DateComponents(day: 1, hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        LazyVStack {
            ForEach(months, id: \.self) { month in
                let yearLabel: String = String(calendar.component(.year, from: year))
                let monthLabel: String = String(calendar.component(.month, from: month))
                VStack {
                    Text("\(yearLabel)년 \(monthLabel)월")
                        .font(.title3)
                    Divider()
                    Monthly(of: month)
                        .id(month)
                }
                .padding()
            }
        }
    }
}

struct Monthly: View {
    let month: Date

    init(of month: Date) {
        self.month = month
    }

    private var weeks: [Date] {
        // month에 해당하는 기간 동안 뷰에 표시할 weeks 배열 (구현 생략)
        // 참고: 코드 하단 깃허브 주소
        
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        
        return calendar.generateDates(
            interval: monthInterval,
            with: DateComponents(hour:0, minute: 0, second: 0, weekday: calendar.firstWeekday)
        )
    }

    var body: some View {
        LazyVStack {
            ForEach(weeks, id: \.self) { week in
                Weekly(of: week)
            }
        }
    }
}

struct Weekly: View {
    let week: Date

    init(of week: Date) {
        self.week = week
    }

    private var days: [Date] {
        // week에 해당하는 기간 동안 뷰에 표시할 days 배열 (구현 생략)
        // 참고: 코드 하단 깃허브 주소
        
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week) else { return [] }
        
        return calendar.generateDates(
            interval: weekInterval,
            with: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }

    var body: some View {
        LazyHStack() {
            ForEach(days, id: \.self) { day in
                if calendar.isDate(day, equalTo: week, toGranularity: .month) {
                    Daily(of: day)
                }
                else {
                    Daily(of: day).hidden()
                }
            }
        }
    }
}

struct Daily: View {
    let day: Date
    let dayLabel: String

    init(of day: Date) {
        let calendar = Calendar(identifier: .gregorian)
        self.day = day
        self.dayLabel = String(calendar.component(.day, from: day))
    }

    var body: some View {
        Text("Day")
            .hidden()
            .padding(5)
            .overlay(Text(dayLabel))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
