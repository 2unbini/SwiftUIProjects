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
    //@EnvironmentObject var toDoList: ToDoLists
    
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
        
        /*
        List {
            ForEach(0..<toDoList.list.count, id: \.self) { i in
                HStack {
                    Button(action: { checkBtnAction(i) }, label: {
                        Image(systemName: toDoList.list[i].checked == true
                                ? sys.names[sys.checked]
                                : sys.names[sys.notChecked])
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Text(toDoList.list[i].toDo)
                    Spacer()
                    
                    Button(action: { deleteList(i) }, label: {
                        Image(systemName: sys.names[sys.delete])
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
         */
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
    
    /*
    func checkBtnAction(_ i: Int) {
        toDoList.list[i].checked.toggle()
    }
    
    func deleteList(_ i: Int) {
        toDoList.list.remove(at: i)
    }
    */
    
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
