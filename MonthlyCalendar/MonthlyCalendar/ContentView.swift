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
        CalendarView(calendarConfig)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
