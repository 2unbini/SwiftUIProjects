//
//  ContentView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

class ToDoLists: ObservableObject {
    @Published var list = [ToDo]()
}

struct ContentView: View {
    @StateObject var toDoList = ToDoLists()
    @State var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        if username == nil {
            GetUserNameView()
        }
        else {
            MainToDoView().environmentObject(toDoList)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
