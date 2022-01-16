//
//  WeekView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject var calendarConfig: CalendarConfiguration
    
    let weekdayRange: Range = Range(1...5)
    let week: Date
    
    init(of week: Date) {
        self.week = week
    }
    
    // 해당 주의 일 배열
    private var days: [Date] {
        guard let weekInterval = calendarConfig.calendar.dateInterval(of: .weekOfMonth, for: week) else { return [] }
        
        return calendarConfig.calendar.generateDates(
            interval: weekInterval,
            with: DateComponents(hour: 0, minute: 0, second: 0)
        )
    }
    
    private func daysBetween(startDate: Date, endDate: Date) -> Int? {
        if endDate < startDate {
            return nil
        }
        return Calendar.current.dateComponents(
            [.day],
            from: startDate.removeUnderHour(),
            to: endDate.removeUnderHour()
        ).day
    }
    
    private var weeklyProjectList: [[Project]] {
        var filteredList = [Project]()
        var sortedList = [Project]()
        var projectListToReturn = [[Project]]()
        
        for project in calendarConfig.projects {
            for day in days {
                if day.isDateInRange(of: project) && !filteredList.contains(project) {
                    filteredList.append(project)
                }
            }
        }
        
        sortedList = filteredList.sorted { first, second in
            let firstStartDate = first.startDate.removeUnderHour()
            let secondStartDate = second.startDate.removeUnderHour()
            guard let firstDays = daysBetween(startDate: first.startDate, endDate: first.endDate) else { fatalError() }
            guard let secondDays = daysBetween(startDate: second.startDate, endDate: second.endDate) else { fatalError() }
            
            if firstStartDate < secondStartDate {
                return true
            }
            else if firstStartDate > secondStartDate {
                return false
            }
            else {
                return firstDays > secondDays
            }
        }
        
        for day in days {
            var dailyProjectList: [Project] = []
            var filteredDailyList: [Project] = []
            
            for project in sortedList {
                if day.isDateInRange(of: project) {
                    dailyProjectList.append(project)
                }
                else {
                    dailyProjectList.append(Project(name: "Empty", startDate: project.startDate, endDate: project.endDate))
                }
            }
            
            filteredDailyList = dailyProjectList
            
            for (index, project) in dailyProjectList.enumerated() {
                if project.name == "Empty" && index < dailyProjectList.count - 1 {
                    let nextProject = dailyProjectList[index + 1]
                    
                    if project.endDate.removeUnderHour() < nextProject.startDate.removeUnderHour() {
                        filteredDailyList.remove(at: index)
                    }
                }
            }
            
            while filteredDailyList.count < sortedList.count {
                filteredDailyList.append(Project(name: "Empty"))
            }
            
            projectListToReturn.append(filteredDailyList)
        }
        
        return projectListToReturn
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<7, id: \.self) { index in
                let day = days[index]
                if calendarConfig.calendar.isDate(day, equalTo: week, toGranularity: .month) {
                    DateView(date: day, projectList: weeklyProjectList[index])
                } else {
                    DateView(date: day, projectList: weeklyProjectList[index]).hidden()
                }
            }
        }
    }
}


