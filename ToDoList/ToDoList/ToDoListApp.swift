//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI
import CoreData

@main
struct ToDoListApp: App {
    let container = PersistenceController.shared.container
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, container.viewContext)
        }
    }
}
