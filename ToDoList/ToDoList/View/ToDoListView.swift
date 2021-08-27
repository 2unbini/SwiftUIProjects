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
    
    //@State var toDoLists = [ToDo]()
    @EnvironmentObject var appToDo: AppToDo
    @EnvironmentObject var sharedToDo: ShareToDo
    
    var body: some View {
        
        List{
            ForEach(0..<appToDo.list.count, id: \.self) { i in
                HStack {
                    Button(action: { checkBtnAction(i) }, label: {
                        Image(systemName: appToDo.list[i].checked == true
                                ? sys.names[sys.checked]
                                : sys.names[sys.notChecked])
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    
                    Text(appToDo.list[i].title)
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
            
            //Text(toDoLists.isEmpty ? "No Todo List" : "")
            Text(sharedToDo.list.isEmpty ? "No Todo List" : "")
            
        )
    }
    
    struct GetSysName {
        let names = ["square", "checkmark.square", "trash"]
        let notChecked = 0
        let checked = 1
        let delete = 2
    }
    
    func checkBtnAction(_ i: Int) {
        //toDoLists = appToDo.list
        //toDoLists[i].checked.toggle()
        //toggleToDoList(toDoLists[i].checked, toDoLists[i].title, toDoLists[i].id)
        
        sharedToDo.list[i].checked.toggle()
        appToDo.list[i].checked.toggle()
        toggleToDoList(sharedToDo.list[i].checked, sharedToDo.list[i].title, sharedToDo.list[i].id)
    }
    
    func getUserTodo() {
        
        print(name ?? "")
        
        guard let url = URL(string: "http://34.64.87.191:8080/api/todos/\(name!)") else {
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
                print(error?.localizedDescription)
                print("Error: JSON Data Parsing failed")
                return
            }
            
            DispatchQueue.main.async {
                appToDo.list = output
                sharedToDo.list = output
                //toDoLists = output
            }
            
            print("=========")
            print(type(of: output))
            print(output)
            print("=========")
            
        }.resume()

    }
    
    func toggleToDoList(_ check: Bool, _ toDoString: String, _ id: Int64) {
        let sendList = ToggleToDo(id: id, checked: check, title: toDoString)
        
        let name = name
        if name == nil {
            print("Cannot get user name")
            return
        }
        
        guard let url = URL(string: "http://34.64.87.191:8080/api/todos/\(name!)") else {
            print("Error: cannot create URL")
            return
        }
        
        guard let sendData = try? JSONEncoder().encode(sendList) else {
            print("Error: cannot convert struct to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = sendData
        
        URLSession.shared.dataTask(with: request) { data, respose, error in
            
            guard error == nil else {
                print("Error: Error calling POST")
                print(error!)
                return
            }
            
            guard let data = data else {
                print("Error: Did not recieve Data")
                print(error!)
                return
            }
            
            guard let response = respose as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print(error!)
                return
            }
            
            do {
                
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    print(error!)
                    return
                }
                
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    print(error!)
                    return
                }
                
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8)
                else {
                    print("Error: Couldn't print JSON in String")
                    print(error!)
                    return
                }
                    
                print(prettyPrintedJson)
                
            } catch {
                
                print("Error: Trying to convert JSON data to string")
                print(error)
                return
                
            }
            
        }.resume()
        
    }
    
    func deleteList(_ i: Int) {
        //toDoLists = appToDo.list
        //let id = String(toDoLists[i].id)
        print(i)
        print(sharedToDo.list[i])
        print(appToDo.list[i])
        let id = String(appToDo.list[i].id)
        print(id)
        
        guard let url = URL(string: "http://34.64.87.191:8080/api/todos/\(id)") else {
            print("Error: Cannot create URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
                guard error == nil else {
                    print("Error: error calling DELETE")
                    print(error)
                    return
                }
        
                guard let data = data else {
                    print("Error: Did not receive data")
                    print(error)
                    return
                }
        
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    print(error)
                    return
                }
            
            }.resume()
        
        appToDo.list.remove(at: i)
        sharedToDo.list.remove(at: i)
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
