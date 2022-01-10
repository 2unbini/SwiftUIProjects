//
//  ContentView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.calendar) var calendar
    @StateObject var calendarConfig: CalendarConfiguration = CalendarConfiguration()
    
    var body: some View {
        CalendarView(calendarConfig) { day in
            DayView(presenting: day, with: calendarConfig)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
