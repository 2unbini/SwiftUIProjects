//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct ToDoListView: View {
    let sys = GetSysName()
    @EnvironmentObject var toDoList: ToDoLists
    
    var body: some View {
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
    }
    
    struct GetSysName {
        let names = ["square", "checkmark.square", "trash"]
        let notChecked = 0
        let checked = 1
        let delete = 2
    }
    
    func checkBtnAction(_ i: Int) {
        if toDoList.list[i].checked {
            toDoList.list[i].checked = false
        } else {
            toDoList.list[i].checked = true
        }
    }
    
    func deleteList(_ i: Int) {
        toDoList.list.remove(at: i)
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
