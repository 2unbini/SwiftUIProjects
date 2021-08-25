//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

class ToDoLists: ObservableObject {
    @Published var list = [ToDo]()
}

@main
struct ToDoListApp: App {
    
    @StateObject var toDoList = ToDoLists()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(toDoList)
        }
    }
}
