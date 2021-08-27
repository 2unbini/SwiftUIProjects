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
                return
            }
            
            guard let response = respose as? HTTPURLResponse, (200..<299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                return
            }
            
            do {
                
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                    print("Error: Cannot convert data to JSON object")
                    return
                }
                
                guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                    print("Error: Cannot convert JSON object to Pretty JSON data")
                    return
                }
                
                guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8)
                else {
                    print("Error: Couldn't print JSON in String")
                    return
                }
                    
                print(prettyPrintedJson)
                
            } catch {
                
                print("Error: Trying to convert JSON data to string")
                return
                
            }
            
        }.resume()
        
    }
    
    func appendToDoList() {
        // Get New Todo array and switch to the new thang ...
        
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
            }
            
            /*
            print("=========")
            print(output)
            print("=========")
            */
            
        }.resume()
        
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView()
    }
}
