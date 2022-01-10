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
        VStack(spacing: 0) {
            Divider()
            Text(label)
                .font(.system(size: 17))
                .padding(.top, 5)
        }
        .padding(.bottom, 40)
    }
}

