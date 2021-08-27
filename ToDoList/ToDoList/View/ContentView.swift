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
            UserNameFieldView(hasUsername: $hasUsername)
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
