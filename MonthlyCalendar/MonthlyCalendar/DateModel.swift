//
//  DateModel.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct Project: Comparable, Hashable, Identifiable {
    var id = UUID()
    
    static func < (lhs: Project, rhs: Project) -> Bool {
        return lhs.startDate < rhs.startDate
    }
    
    var name: String!
    var startDate: Date!
    var endDate: Date!
}

class CalendarConfiguration: ObservableObject {
    @Published var stringified: Stringified
    @Published var calendarInterval: DateInterval
    @Published var initialDateId: Date
    
    @Published var projects: [Project]
    
    let calendar: Calendar
    let today: Today
    var cellSize: CGSize
    
    struct Today {
        var date: Date
        var year: Int
        var month: Int
        var day: Int
        var components: DateComponents
        var compareableDate: Date
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        
        init() {
            date = Date()
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
            components = DateComponents(year: year, month: month, day: day)
            compareableDate = calendar.date(from: components) ?? Date()
        }
        
        private mutating func update() {
            date = Date()
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
            components = DateComponents(year: year, month: month, day: day)
            compareableDate = calendar.date(from: components) ?? Date()
        }
    }
    
    struct Stringified {
        var year: String
        var month: String
        var day: String
    }
    
    init() {
        let startDate = DateComponents(year: CalendarYear.start.rawValue, month: 1, day: 1)
        let endDate = DateComponents(year: CalendarYear.end.rawValue, month: 12, day: 31)
        
        calendar = Calendar(identifier: .gregorian)
        
        today = Today()
        stringified = Stringified(year: String(today.year), month: String(today.month), day: String(today.day))
        
        calendarInterval = DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!)
        
        initialDateId = calendar.date(from: DateComponents(year: today.year, month: today.month)) ?? Date()
        
        cellSize = CGSize()
        projects = [Project(name: "A", startDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 14)), endDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 17))),
                    Project(name: "B", startDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 15)), endDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 25))),
                    Project(name: "C", startDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 15)), endDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 16))),
                    Project(name: "D", startDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 17)), endDate: calendar.date(from: DateComponents(year: 2022, month: 2, day: 28)))]
    }
    
    // 문자열화 된 현재의 년도로 바꾸는 함수
    func changeYearString(with year: Date) {
        let updatedYear = calendar.component(.year, from: year)
        self.stringified.year = String(updatedYear)
    }
    
    // 오늘과 date가 같은 날인지 판별하는 함수
    func isSameDayAsToday(_ day: Date) -> Bool {
        return day == today.compareableDate
    }
    
    func isSameMonthAsToday(_ month: Date) -> Bool {
        return month == calendar.date(from: DateComponents(year: today.year, month: today.month))
    }
}
