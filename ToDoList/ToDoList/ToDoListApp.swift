//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

// 전역변수처럼 사용할 Todo 리스트
// ObservableObject를 사용하기 위해선 class(reference type) 사용

class ToDoLists: ObservableObject {
    @Published var list = [ToDo]()
}

@main
struct ToDoListApp: App {
    
    @StateObject var appToDo = AppToDo()
    @StateObject var sharedToDo = ShareToDo()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appToDo)
                .environmentObject(sharedToDo)
        }
    }
}
