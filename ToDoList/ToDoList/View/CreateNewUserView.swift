//
//  CreateNewUserView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/29.
//

import SwiftUI

struct CreateNewUserView: View {
    
    @State var newUser = SendUser(name: "", email: "", password: "")
    @State var done = false
    @State var error = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Text("Create New User")
                    .font(.title2)
                    .padding([.bottom], 30)
                
                VStack {
                    TextField("Name", text: $newUser.name)
                    .frame(width: 300, height: 40, alignment: .center)
                    .overlay(VStack {
                        Divider().offset(x: 0, y: 20)
                    })
                    TextField("Email", text: $newUser.email)
                        .frame(width: 300, height: 40, alignment: .center)
                        .overlay(VStack {
                            Divider().offset(x: 0, y: 20)
                        })
                    SecureField("Password", text: $newUser.password)
                        .frame(width: 300, height: 40, alignment: .center)
                        .overlay(VStack {
                            Divider().offset(x: 0, y: 20)
                        })
                    
                }
                .padding([.top, .bottom], 40)
                
                Button(action: {
                    postUserInfo()
                }, label: {
                    Text("Submit")
                })
                
                Spacer()
            }
            .alert(isPresented: $done, content: {
                Alert(title: Text("New User Created"),
                      message: Text("Go back and write User Name"),
                      dismissButton: .default(Text("Go back")))
            })
            .alert(isPresented: $error, content: {
                Alert(title: Text("Cannot Create User"),
                      message: Text("Please Try Again"),
                      dismissButton: .default(Text("Ok")))
            })
        }
    }
    
    func postUserInfo() {

        guard let url = getUserUrl() else {
            print("Error: Cannot create url")
            error = true
            return
        }
        
        guard let sendData = try? JSONEncoder().encode(newUser) else {
            print("Error: Cannot make JSON Data")
            error = true
            return
        }
        
        checkJsonPretty(sendData)
        postMethod(url, sendData)
        done = true
    }
}

struct CreateNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewUserView()
    }
}
