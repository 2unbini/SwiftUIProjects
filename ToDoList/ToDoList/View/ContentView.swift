//
//  ContentView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

struct ContentView: View {
    
    // 전역변수 toDoList
    @EnvironmentObject var toDoList: ToDoLists
    
    // 앱 사용하는 유저 이름 UserDefault에 저장
    @State var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        
        // UserDefault에 유저 이름 없으면 받아오고 있으면 Main뷰로 이동
        if username == nil {
            GetUserNameView()
        }
        else {
            MainToDoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
