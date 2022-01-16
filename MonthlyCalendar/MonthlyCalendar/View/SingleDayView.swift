//
//  SingleDayView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct DayView: View {
    @EnvironmentObject var calendarConfig: CalendarConfiguration
    let date: Date
    let projectList: [Project]
    let isSameDayAsToday: Bool
    let isWeekend: Bool
    
    init(presenting date: Date, isWeekend: Bool, with projectList: [Project]) {
        self.date = date
        self.projectList = projectList
        self.isSameDayAsToday = date.isToday
        self.isWeekend = isWeekend
    }

    var body: some View {
        VStack(spacing: 0) {
            Divider()
            ZStack(alignment: .center) {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(isSameDayAsToday ? .red : .clear)
                Text("\(date.day)")
                    .font(.system(size: 17))
                    .foregroundColor(isSameDayAsToday ? .white : isWeekend ? .gray : .black)
            }
            .padding(.top, 5)
            VStack(spacing: 2) {
                ForEach(0..<projectList.count, id: \.self) { index in
                    let project = projectList[index]
                    
                    Rectangle()
                        .foregroundColor(.yellow)
                        .opacity(project.name == "Empty" ? 0 : 0.5)
                        .frame(width: calendarConfig.cellSize.width, height: calendarConfig.cellSize.height * 0.18)
                        .overlay(Text(project.name/* == "Empty" ? "" : project.name*/))
                }
            }
        }
        .padding(.bottom, 30)
    }
}

struct DateView: View {
    @Environment(\.calendar) private var calendar
    @EnvironmentObject private var calendarConfig: CalendarConfiguration
    
    let date: Date
    var projectList: [Project]
    
    init(date: Date, projectList: [Project]) {
        self.date = date
        self.projectList = projectList
    }
    
    var body: some View {
        VStack(spacing: 3) {
            Divider()
            dayLabel
            projectCell
        }
        .frame(maxWidth: calendarConfig.cellSize.width, minHeight: calendarConfig.cellSize.height, alignment: .top)
    }
    
    private var projectCell: some View {
        
        VStack(spacing: 2) {
            ForEach(projectList, id: \.self) { project in
                Rectangle()
                    .foregroundColor(.yellow)
                    .opacity(project.name == "Empty" ? 0 : 0.5)
                    .frame(width: calendarConfig.cellSize.width, height: calendarConfig.cellSize.height * 0.18)
                    .overlay(Text(project.name == "Empty" ? "" : project.name))
            }
        }
    }
    
    private var dayLabel: some View {
        Text("30")
            .hidden()
            .padding(7)
            .background(date.isToday ? Color.pink : nil)
            .clipShape(Circle())
            .overlay(
                Text(String(date.day))
            )
            .foregroundColor(date.isToday ? Color.white : date.isWeekend ? Color.gray : Color.primary)
            // TODO: bold if today
    }
}
