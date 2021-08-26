//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI
import CoreData

struct ToDoListView: View {
    
    let sys = GetSysName()
    
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.date, ascending: true)], animation: .easeIn) var results: FetchedResults<Todo>
    
    var body: some View {
        
        List(results) { item in
            
            HStack {
                Button(action: { checkBtnAction(item) }, label: {
                    Image(systemName: item.checked == true
                            ? sys.names[sys.checked]
                            : sys.names[sys.notChecked])
                })
                .buttonStyle(BorderlessButtonStyle())
                
                Text(item.content ?? "")
                Spacer()
                
                Button(action: { deleteList(item) }, label: {
                    Image(systemName: sys.names[sys.delete])
                })
                .buttonStyle(BorderlessButtonStyle())
            }
            
        }.overlay(
            
            Text(results.isEmpty ? "No Todo found" : "")
            
        )
    }
    
    struct GetSysName {
        let names = ["square", "checkmark.square", "trash"]
        let notChecked = 0
        let checked = 1
        let delete = 2
    }
    
    func checkBtnAction(_ todo: Todo) {
        todo.checked.toggle()
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteList(_ todo: Todo) {
        context.delete(todo)
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
