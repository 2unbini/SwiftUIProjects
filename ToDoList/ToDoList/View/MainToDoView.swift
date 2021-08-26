//
//  MainToDoView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct MainToDoView: View {
    
    @State var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        VStack {
            Spacer()
            Text("What to do Today,  " + username! + "?")
                .font(.title2)
                .frame(width: 500, height: 100, alignment: .center)
            TextFieldView()
            Spacer()
            Spacer()
            ToDoListView()
        }
    }
}

struct MainToDoView_Previews: PreviewProvider {
    static var previews: some View {
        MainToDoView()
    }
}
