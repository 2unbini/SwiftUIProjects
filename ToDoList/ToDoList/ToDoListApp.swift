//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI
import CoreData

class ToDoLists: ObservableObject {
    @Published var list = [ToDo]()
}

@main
struct ToDoListApp: App {
    let container = PersistenceController.shared.container
    @StateObject var toDoList = ToDoLists()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(toDoList)
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}
