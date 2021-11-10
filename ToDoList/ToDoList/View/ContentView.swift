//
//  ContentView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

struct ContentView: View {
    
<<<<<<< HEAD
    // 전역변수 toDoList
    @EnvironmentObject var toDoList: ToDoLists
    
    // 앱 사용하는 유저 이름 UserDefault에 저장
    @State var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        
        // UserDefault에 유저 이름 없으면 받아오고 있으면 Main뷰로 이동
        if username == nil {
            GetUserNameView()
=======
    @State var hasUsername = false
    @State var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        if hasUsername == false || username == nil {
            NavigationView {
                VStack {
                    Text("To-Day-To-Do")
                        .font(.title.bold())
                        .padding(.bottom, 30)
                    UserNameFieldView(hasUsername: $hasUsername)
                        .padding(.bottom, 180)
                    NavigationLink(destination: CreateNewUserView(), label: {
                        Text("Create New Account")
                    })
                }
            }
>>>>>>> 84493dd914ebbcd9e1d85143a0f9725fbf37e34e
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
