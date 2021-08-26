//
//  TextFieldView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//


import SwiftUI

struct TextFieldView: View {
    
    @State var toDoString = ""
    
    // Getting context from environment...
    @Environment(\.managedObjectContext) var context
    
    // Presentation..
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        HStack {
            Image(systemName: "square.and.pencil")
            TextField("your task", text: $toDoString, onCommit: { addList() })
        }
        .textFieldStyle(DefaultTextFieldStyle())
        .frame(width: 300, height: 50, alignment: .center)

    }
    
    func addList() {
        let todo = Todo(context: context)
        
        todo.content = toDoString
        todo.checked = false
        todo.date = Date()
        
        toDoString = ""
        
        do {
            try context.save()
            
            // if success -> closing view
            presentation.wrappedValue.dismiss()
        }
        catch {
            print(error.localizedDescription)
        }
    }

}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
