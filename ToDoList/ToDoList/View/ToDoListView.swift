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
    
    func toggleToDoList(_ check: Bool, _ toDoString: String, _ id: Int64) {
        let sendList = ToggleToDo(id: id, checked: check, title: toDoString)
        
        guard let url = getToDoUrl(name) else {
            print("Error: Cannot create url")
            return
        }
        
        guard let sendData = try? JSONEncoder().encode(sendList) else {
            print("Error: cannot convert struct to JSON data")
            return
        }
        
        postMethod(url, sendData)
    }
    
    func deleteList(_ i: Int) {
        //toDoLists = appToDo.list
        //let id = String(toDoLists[i].id)

        let id = String(appToDo.list[i].id)
        print("elem ID to delete: " + id)
        
        guard let url = getToDoUrl(id) else {
            print("Error: Cannot create URL")
            return
        }
        
        deleteMethod(url)
        
        appToDo.list.remove(at: i)
        sharedToDo.list.remove(at: i)
    }
    
    func getUserTodo() {
        
        guard let url = getToDoUrl(name) else {
            print("Error: Cannot make url")
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
                //toDoLists = output
            }
            
        }.resume()

    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}
