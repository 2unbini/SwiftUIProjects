//
//  ContentView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

struct ContentView: View {
    
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
