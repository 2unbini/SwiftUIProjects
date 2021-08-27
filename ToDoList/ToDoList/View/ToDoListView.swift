//
//  ToDoListView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct ToDoListView: View {
    let sys = GetSysName()
    var name = UserDefaults.standard.string(forKey: "name")
    @State var toDoLists = [ToDo]()
    //@EnvironmentObject var toDoList: ToDoLists
    
    var body: some View {
        
        List{
            ForEach(0..<toDoLists.count, id: \.self) { i in
                HStack {
                    Button(action: { checkBtnAction(i) }, label: {
                        Image(systemName: toDoLists[i].checked == true
                                ? sys.names[sys.checked]
                                : sys.names[sys.notChecked])
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Text(toDoLists[i].title)
                    Spacer()
                    
                    Button(action: { deleteList(i) }, label: {
                        Image(systemName: sys.names[sys.delete])
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .onAppear(perform: { getUserTodo() })
        .overlay(
            
            Text(toDoLists.isEmpty ? "No Todo List" : "")
        
        )
    }
    
    struct GetSysName {
        let names = ["square", "checkmark.square", "trash"]
        let notChecked = 0
        let checked = 1
        let delete = 2
    }
    
    func checkBtnAction(_ i: Int) {
        toDoLists[i].checked.toggle()
    }
    
    func deleteList(_ i: Int) {
        let id = String(toDoLists[i].id)
        guard let url = URL(string: "http://34.64.87.191:8080/api/todos/\(id)") else {
            print("Error: Cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
            
                    do {
                        
                        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            print("Error: Cannot convert data to JSON")
                            return
                        }
                        
                        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                            print("Error: Cannot convert JSON object to Pretty JSON data")
                            return
                        }
                        
                        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                            print("Error: Could print JSON in String")
                            return
                        }
                        
                        print(prettyPrintedJson)
                        
                    } catch {
                        
                        print("Error: Trying to convert JSON data to string")
                        return
                        
                    }
                }.resume()
    }
    
    func getUserTodo() {
        guard let url = URL(string: "http://34.64.87.191:8080/api/todos/ekwon") else {
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
            
            guard let output = try? JSONDecoder().decode([ToDo].self, from: data) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            print("output : ")
            print(output)
            print("=========")
            
        }.resume()
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
