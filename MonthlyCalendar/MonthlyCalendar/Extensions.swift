//
//  Extensions.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import Foundation

// 달의 첫 날인지 확인
extension Calendar {
    func isFirstDayOfMonth(_ day: Date, ofMonth month: Date) -> Bool {
        let startDay = self.startOfDay(for: month)
        
        if day == startDay {
            return true
        }
        
        return false
    }
}

// interval에서 dateComponent만큼의 Date 배열
// 예) 한 주의 7일 배열, 한 달의 4 - 5주 배열, 일 년의 12달 배열 등
extension Calendar {
    func generateDates(interval: DateInterval, with dateComponent: DateComponents) -> [Date] {
        var dates: [Date] = []
        // MARK: 왜 첫 번째 애는 enumerateDates에서 들어가지 않는가...
        dates.append(interval.start)
        
        enumerateDates(
            startingAfter: interval.start,
            matching: dateComponent,
            matchingPolicy: .nextTime
        ) { date, strict, stop in
            if let date = date {
                if date < interval.end {
                    dates.append(date)
                }
                else {
                    stop = true
                }
            }
        }
        
        return dates
    }
}

extension Date: Identifiable {
    public var id: String {
        description
    }
    
    private var calendar: Calendar {
        Calendar.current
    }
    
    func getComponent(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        calendar.component(component, from: self)
    }
    
    var day: Int { self.getComponent(.day) }
    var month: Int { self.getComponent(.month) }
    var year: Int { self.getComponent(.year) }
    var isToday: Bool { calendar.isDateInToday(self)}
    var isWeekend: Bool { calendar.isDateInWeekend(self)}
    
    var midnight: Date {
        calendar.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? self
    }
    
    var tomorrowMidnight: Date {
        calendar.date(byAdding: .day, value: 1, to: midnight) ?? midnight
    }
}

extension Date {
    
    var date: Date { calendar.date(from: DateComponents(year: self.year, month: self.month, day: self.day)) ?? Date() }
    
    func isDateInRange(of project: Project) -> Bool {
        return project.startDate.date <= self && project.endDate.date >= self
    }

    func removeUnderHour() -> Date {
        guard let date = Calendar.current.date(
            from: Calendar.current.dateComponents(
                [.year, .month, .day],
                from: self)
        ) else {
            fatalError("Failed to strip time from Date object")
        }
        
        return date
    }
}
