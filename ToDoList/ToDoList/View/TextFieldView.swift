//
//  TextFieldView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct TextFieldView: View {
    
    @State var toDoString = ""
    var name = UserDefaults.standard.string(forKey: "name")
    
    //@State var toDoLists = [ToDo]()
    @EnvironmentObject var appToDo: AppToDo
    @EnvironmentObject var sharedToDo: ShareToDo
    
    var body: some View {
        HStack {
            Image(systemName: "square.and.pencil")
            TextField("your task", text: $toDoString,
                      onCommit: {
                        postList(false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            appendToDoList()
                        })
                      })
        }
        .textFieldStyle(DefaultTextFieldStyle())
        .frame(width: 300, height: 50, alignment: .center)
    }
    
    func postList(_ check: Bool) {
        let sendList = SendToDo(checked: check, title: toDoString)
        toDoString = ""
        
        guard let url = getToDoUrl(name) else {
            print("Error: cannot create URL")
            return
        }
        
        guard let sendData = try? JSONEncoder().encode(sendList) else {
            print("Error: cannot convert struct to JSON data")
            return
        }
        
        postMethod(url, sendData)
        
    }
    
    func appendToDoList() {
        // Get New Todo array and switch to the new thang ...
        
        guard let url = getToDoUrl(name) else {
            print("Error: Cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print("Error: error calling DELETE")
                print(error!)
                return
            }
    
            guard let data = data else {
                print("Error: Did not receive data")
                return
            }
    
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            let decoder = JSONDecoder()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            guard let output = try? decoder.decode([ToDo].self, from: data) else {
                print(error!.localizedDescription)
                print("Error: JSON Data Parsing failed")
                return
            }
            
            DispatchQueue.main.async {
                appToDo.list = output
                sharedToDo.list = output
            }
            
        }.resume()
        
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
