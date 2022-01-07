//
//  SingleDayView.swift
//  MonthlyCalendar
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct DayView: View {
    let label: String
    
    init(presenting label: String) {
        self.label = label
    }
    
    var body: some View {
        Text("Day")
            .hidden()
            .padding(10)
            .padding(.bottom, 20)
            .overlay(
                VStack {
                    Divider()
                    Text(label)
                }
            )
    }
}

