//
//  ContentView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

class ToDoLists: ObservableObject {
    @Published var list = [ToDo]()
}

struct ContentView: View {
    @StateObject var toDoList = ToDoLists()
    
    var body: some View {
        VStack {
            Spacer()
            Text("What to do Today?")
                .font(.title.bold())
                .frame(width: 500, height: 80, alignment: .center)
            TextFieldView().environmentObject(toDoList)
            Spacer()
            Spacer()
            ToDoListView().environmentObject(toDoList)
            SaveLoadButtonView().environmentObject(toDoList)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
