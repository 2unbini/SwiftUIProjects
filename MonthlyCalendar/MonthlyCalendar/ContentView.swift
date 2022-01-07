//
//  ContentView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.calendar) var calendar
    
    var body: some View {
        CalendarView { day in
            DayView(presenting: String(calendar.component(.day, from: day)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
