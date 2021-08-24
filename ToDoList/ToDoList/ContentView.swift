//
//  ContentView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/23.
//

import SwiftUI

struct ToDo : Identifiable, Codable {
    var id = UUID()
    var toDo: String
    var checked: Bool
}

struct GetSysName {
    let names = ["square", "checkmark.square", "trash"]
    let notChecked = 0
    let checked = 1
    let delete = 2
}

struct ContentView: View {
    let sys = GetSysName()
    @State var toDoList = [ToDo]()
    @State var toDoString = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("What to do Today?")
                .font(.title.bold())
                .frame(width: 500, height: 80, alignment: .center)
            
            HStack {
                Image(systemName: "square.and.pencil")
                TextField("your task", text: $toDoString, onCommit: { appendList() })
            }
            .textFieldStyle(DefaultTextFieldStyle())
            .frame(width: 300, height: 50, alignment: .center)
            
            Spacer()
            Spacer()
            
            List {
                ForEach(0..<toDoList.count, id: \.self) { i in
                    HStack {
                        
                        Button(action: { checkBtnAction(i) }, label: {
                            Image(systemName: toDoList[i].checked == true
                                    ? sys.names[sys.checked]
                                    : sys.names[sys.notChecked])
                        })
                        .frame(width: 30, height: 30, alignment: .leading)
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text(toDoList[i].toDo)
                        Spacer()
                        
                        Button(action: { deleteList(i) }, label: {
                            Image(systemName: sys.names[sys.delete])
                        })
                        .frame(width: 30, height: 30, alignment: .bottom)
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            
            HStack {
                Spacer()
                Button(action: { saveData() }, label: { Text("save") })
                .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                Button(action: { loadData() }, label: { Text("load") })
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
            }
            
        }
    }
    
    func checkBtnAction(_ i: Int) {
        if toDoList[i].checked {
            toDoList[i].checked = false
        } else {
            toDoList[i].checked = true
        }
    }
    
    func appendList() {
        let inputList = ToDo(toDo: toDoString, checked: false)
        toDoList.append(inputList)
        toDoString = ""
    }
    
    func deleteList(_ i: Int) {
        toDoList.remove(at: i)
    }
    
    func saveData() {
        let path = getDocumentDirectory().appendingPathComponent("todolist.json")
        let jsonString = saveToJsonFile()
        
        print(path.absoluteString)
        
        do {
            try jsonString.write(to: path, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadData() {
        let path = getDocumentDirectory().appendingPathComponent("todolist.json")
        
        do {
            let jsonString = try String(contentsOf: path)
            toDoList = parseToArray(jsonString)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getDocumentDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func saveToJsonFile() -> String {
        let encoder: JSONEncoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData: Data = try! encoder.encode(toDoList)
        
        if let jsonString: String = String(data: jsonData, encoding: .utf8) {
            return jsonString
        }
        
        return ""
    }
    
    func parseToArray(_ jsonString: String) -> [ToDo] {
        let decoder: JSONDecoder = JSONDecoder()
        let jsonData: Data = jsonString.data(using: .utf8)!
        
        if let toDoList = try? decoder.decode([ToDo].self, from: jsonData) {
            return toDoList
        }
        
        return []
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
