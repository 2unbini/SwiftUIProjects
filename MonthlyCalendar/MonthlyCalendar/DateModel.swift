//
//  DateModel.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

class CurrentDayViewModel: ObservableObject {
    @Published var stringified: Stringified
    @Published var interval: DateInterval
    @Published var initialDateId: Date
    
    let calendar: Calendar
    let formatter: DateFormatter
    var scrollIndexToInit: Int
    private var today: Date
    
    struct Stringified {
        var year: String
        var month: String
        var day: String
    }
    
    init() {
        let year: Int
        let month: Int
        let day: Int
        let startDate = DateComponents(year: CalendarYear.start.rawValue, month: 1, day: 1)
        let endDate = DateComponents(year: CalendarYear.end.rawValue, month: 12, day: 31)
        
        calendar = Calendar(identifier: .gregorian)
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        today = Date()
        
        year = calendar.component(.year, from: today)
        month = calendar.component(.month, from: today)
        day = calendar.component(.day, from: today)
        
        stringified = Stringified(year: String(year), month: String(month), day: String(day))
        
        scrollIndexToInit = year - CalendarYear.start.rawValue
        
        interval = DateInterval(start: calendar.date(from: startDate)!, end: calendar.date(from: endDate)!)
        initialDateId = Date()
    }
    
    func updateInterval(with interval: DateInterval) {
        self.interval = interval
    }
    
    // 문자열화 된 현재의 년, 월, 일 업데이트 함수
    func updateCurrentDateString(with date: Date) {
        self.stringified.year = String(calendar.component(.year, from: date))
        self.stringified.month = String(calendar.component(.month, from: date))
        self.stringified.day = String(calendar.component(.day, from: date))
    }
    
    // 문자열화 된 현재의 년도로 바꾸는 함수
    func changeYear(with year: Date) {
        let updatedYear = calendar.component(.year, from: year)
        
        self.stringified.year = String(updatedYear)
    }
}
