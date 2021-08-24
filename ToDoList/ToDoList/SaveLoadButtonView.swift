//
//  SaveLoadButtonView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct SaveLoadButtonView: View {
    @EnvironmentObject var toDoList: ToDoLists
    
    var body: some View {
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
            toDoList.list = parseToArray(jsonString)
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
        let jsonData: Data = try! encoder.encode(toDoList.list)
        
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

struct SaveLoadButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SaveLoadButtonView()
    }
}
