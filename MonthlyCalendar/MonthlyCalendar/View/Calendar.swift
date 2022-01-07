//
//  Calendar.swift
//  MontlyCalendar
//
//  Created by 권은빈 on 2022/01/05.
//

import SwiftUI

struct CalendarView<DayView> : View where DayView: View {
    @Environment(\.calendar) var calendar
    @ObservedObject var currentDay: CurrentDayState
    @State private var isInitializedFirst: Bool = true
    
    let content: (Date) -> DayView
    
    init(@ViewBuilder content: @escaping (Date) -> DayView) {
        self.currentDay = CurrentDayState()
        self.content = content
    }
    
    private var years: [Date] {
        return calendar.generateDates(
            interval: currentDay.interval,
            with: DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(0..<years.count, id: \.self) { i in
                            YearView(of: years[i], currentDay, content: content)
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            CustomBarTitle(presenting: currentDay.stringified.year)
                        }
                    }
                }
//                .onAppear(perform: {
//                    DispatchQueue.main.async {
//                        proxy.scrollTo(currentDay.scrollIndexToInit, anchor: .top)
//                    }
//                })
            }
        }
    }
}

struct ScrollBackToToday: View {
    
    let proxy: ScrollViewProxy
    let id: Int
    
    init(with proxy: ScrollViewProxy, to id: Int) {
        self.proxy = proxy
        self.id = id
    }
    
    var body: some View {
        Button("Today") {
            proxy.scrollTo(id, anchor: .top)
        }
    }
}

struct CustomBarTitle: View {
    
    let year: String
    
    init(presenting year: String) {
        self.year = year
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(year).font(.headline)
            Header().font(.footnote)
            Spacer()
        }
    }
    
    struct Header: View {
        private var daySymbols: [String] {
            return Calendar.current.shortWeekdaySymbols
        }
        
        var body: some View {
            HStack(alignment: .center, spacing: 26) {
                ForEach(daySymbols, id: \.self) { symbol in
                    Text(symbol)
                }
            }
        }
    }
}


