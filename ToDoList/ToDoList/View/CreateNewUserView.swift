//
//  CreateNewUserView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/29.
//

import SwiftUI

struct CreateNewUserView: View {
    
    @State var newUser = SendUser(name: "", email: "", password: "")
    @State var showAlert = ShowAlert(bool: false, id: .done, message: "")
    
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
                    cleanTextField()
                    
                }, label: {
                    Text("Submit")
                })
                
                Spacer()
            }
            .alert(isPresented: $showAlert.bool, content: {
                switch showAlert.id {
                case .done:
                    return Alert(title: Text(showAlert.message),
                                 message: Text("Please Go Back to Main Page"),
                                 dismissButton: .default(Text("Go back")))
                case .error:
                    return Alert(title: Text(showAlert.message),
                                 message: Text("Please Try Again"),
                                 dismissButton: .default(Text("Ok")))
                }
            })
        }
    }
    
    struct ShowAlert {
        var bool: Bool
        var id: selection
        var message: String
        
        enum selection {
            case done, error
        }
    }
    
    func cleanTextField() {
        newUser.name = ""
        newUser.email = ""
        newUser.password = ""
    }
    
    func postUserInfo() {
        
        if newUser.name == "" {
            
            print("Invalid name")
            showAlert.bool = true
            showAlert.id = .error
            showAlert.message = "Invalid user name"
            return
        }
        else if newUser.email == ""
            || newUser.email.contains("@") == false
            || newUser.email.contains(".") == false {
        
            print("Invalid email")
            showAlert.bool = true
            showAlert.id = .error
            showAlert.message = "Invalid email"
            return
        }
        else if  newUser.password == "" {
            
            print("Invalid password")
            showAlert.bool = true
            showAlert.id = .error
            showAlert.message = "Invalid password"
            return
        }

        guard let url = getUserUrl() else {
            print("Error: Cannot create url")
            showAlert.bool = true
            showAlert.id = .error
            showAlert.message = "User Creation Failed"
            return
        }
        
        guard let sendData = try? JSONEncoder().encode(newUser) else {
            print("Error: Cannot make JSON Data")
            showAlert.bool = true
            showAlert.id = .error
            showAlert.message = "User Creation Failed"
            return
        }
        
        checkJsonPretty(sendData)
        //postMethod(url, sendData)
        
        showAlert.bool = true
        showAlert.id = .done
        showAlert.message = "New user created!"
    }
}

struct CreateNewUserView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNewUserView()
    }
}
