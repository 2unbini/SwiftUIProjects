//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

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
