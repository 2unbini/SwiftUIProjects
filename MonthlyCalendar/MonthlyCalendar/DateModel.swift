//
//  DateModel.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

class CalendarConfiguration: ObservableObject {
    @Published var stringified: Stringified
    @Published var calendarInterval: DateInterval
    @Published var initialDateId: Date
    
    let calendar: Calendar
    let formatter: DateFormatter
    let today: Today
    
    struct Today {
        var date: Date
        var year: Int
        var month: Int
        var day: Int
        
        let calendar: Calendar = Calendar(identifier: .gregorian)
        
        init() {
            date = Date()
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
        }
        
        private mutating func update() {
            date = Date()
            year = calendar.component(.year, from: date)
            month = calendar.component(.month, from: date)
            day = calendar.component(.day, from: date)
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
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        today = Today()
        stringified = Stringified(year: String(today.year), month: String(today.month), day: String(today.day))
        
        calendarInterval = DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!)
        
        // 지금은 '오늘' 날짜로 되어 있음
        // 내가 움직일 날짜 형식(2022-01-31 15:00:00 +0000)으로 바꾸는 것 필요
        initialDateId = calendar.date(from: DateComponents(year: today.year, month: today.month)) ?? Date()
    }
    
    func updateInterval(with interval: DateInterval) {
        self.calendarInterval = interval
    }
    
    // 문자열화 된 현재의 년, 월, 일 업데이트 함수
    func updateCurrentDateString(with date: Date) {
        self.stringified.year = String(calendar.component(.year, from: date))
        self.stringified.month = String(calendar.component(.month, from: date))
        self.stringified.day = String(calendar.component(.day, from: date))
    }
    
    // 문자열화 된 현재의 년도로 바꾸는 함수
    func changeYearString(with year: Date) {
        let updatedYear = calendar.component(.year, from: year)
        
        self.stringified.year = String(updatedYear)
    }
    
    func initializeScrollId(with today: Today) -> Date {
        let dateComponent = DateComponents(year: today.year, month: today.month)
        return dateComponent.date!
    }
}
