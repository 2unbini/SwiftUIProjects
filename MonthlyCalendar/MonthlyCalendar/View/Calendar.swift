//
//  Calendar.swift
//  MontlyCalendar
//
//  Created by 권은빈 on 2022/01/05.
//

import SwiftUI

struct CalendarView<DayView> : View where DayView: View {
    @Environment(\.calendar) var calendar
    @ObservedObject var calendarConfig: CalendarConfiguration
    @State private var isInitializedFirst: Bool = true
    
    let content: (Date) -> DayView
    
    init(_ calendarConfig: CalendarConfiguration, @ViewBuilder content: @escaping (Date) -> DayView) {
        self.calendarConfig = calendarConfig
        self.content = content
    }
    
    private var years: [Date] {
        return calendar.generateDates(
            interval: calendarConfig.calendarInterval,
            with: DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0)
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // TODO: Fix view constraint crash in real Device...
                CustomBar(presenting: calendarConfig.stringified.year)
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(years, id: \.self) { year in
                                YearView(of: year, calendarConfig, content: content)
                            }
                        }
                        .navigationBarHidden(true)
                    }
                    .onAppear(perform: {
                        DispatchQueue.main.async {
                            proxy.scrollTo(calendarConfig.initialDateId, anchor: .top)
                        }
                    })
                }
            }
        }
    }
}

struct CustomBar: View {
    
    let year: String
    
    init(presenting year: String) {
        self.year = year
    }
    
    var body: some View {
        ZStack() {
            Rectangle()
                .strokeBorder(.gray.opacity(0.3))
                .foregroundColor(Color.gray.opacity(0.2))
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Buttons(presenting: year)
                daySymbolHeader.font(.caption)
            }
        }
        .frame(maxHeight: 60)
    }
    
    struct Buttons: View {
        
        let year: String
        
        init(presenting year: String) {
            self.year = year
        }
        
        var body: some View {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("\(year)년")
                }
                .padding(.leading, 10)
                .font(.headline)
                .foregroundColor(.red)
                Spacer()
                HStack(spacing: 20) {
                    Image(systemName: "list.bullet.below.rectangle")
                    Image(systemName: "magnifyingglass")
                    Image(systemName: "plus")
                }
                .padding(.trailing, 10)
                .font(.title3)
                .foregroundColor(.red)
            }
        }
    }
    
    private var daySymbolHeader: some View {
        let daySymbols = ["일", "월", "화", "수", "목", "금", "토"]
        
        return HStack(alignment: .center) {
                ForEach(daySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(symbol == "일" || symbol == "토" ? .gray : .black)
            }
        }
        .padding(.top, 10)
    }
}


