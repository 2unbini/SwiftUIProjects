//
//  TextFieldView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct TextFieldView: View {
    @State var toDoString = ""
    @EnvironmentObject var toDoList: ToDoLists
    
    var body: some View {
        HStack {
            Image(systemName: "square.and.pencil")
            TextField("your task", text: $toDoString, onCommit: { appendList() })
        }
        .textFieldStyle(DefaultTextFieldStyle())
        .frame(width: 300, height: 50, alignment: .center)
    }
    
    func appendList() {
        let inputList = ToDo(toDo: toDoString, checked: false)
        toDoList.list.append(inputList)
        toDoString = ""
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
