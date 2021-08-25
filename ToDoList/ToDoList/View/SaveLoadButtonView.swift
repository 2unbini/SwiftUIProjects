//
//  SaveLoadButtonView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct SaveLoadButtonView: View {
    @EnvironmentObject var toDoList: ToDoLists
    @State var saveLoadPath = UserDefaults.standard.url(forKey: "path")
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: { saveData() }, label: { Text("save") })
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(action: { loadData() }, label: { Text("load") })
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
    
    func saveData() {
        let jsonString = saveToJsonFile()
        let path = getDocumentDirectory()
        let resourcePath = Bundle.main.url(forResource: "todolist", withExtension: "json")
    
        if path == nil || resourcePath == nil {
            print("invalid path - save Data")
            return
        }
        
        UserDefaults.standard.set(path, forKey: "path")
        print("ios save path")
        print(path)
        print(resourcePath)
        print("------")
        
        do {
            try jsonString.write(to: path!, atomically: true, encoding: .utf8)
            try jsonString.write(to: resourcePath!, atomically: true, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadData() {
        let path = getDocumentDirectory()

        if path == nil {
            print("invalid path - load Data")
            return
        }
        
        UserDefaults.standard.set(path, forKey: "path")
        print("ios load path")
        print(path)
        print("------")
        
        do {
            let jsonString = try String(contentsOf: path!)
            toDoList.list = parseToArray(jsonString)
        } catch {
            print(error.localizedDescription)
        }
    }

    func getDocumentDirectory() -> URL? {
        return FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("todolist.json")
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
