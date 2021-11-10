//
//  UserNameFieldView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/25.
//

import SwiftUI

struct UserNameFieldView: View {
    
    @Binding var hasUsername: Bool
    
    @State private var name = ""
    @State private var showAlert = false
    @State private var isSuccessful = false
    @State var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "person")
                    .frame(width: 30, height: 30, alignment: .leading)
                Spacer()
                TextField("What's your name?", text: $name)
                Spacer()
                Button(action: { setUserInfo() }, label: { Image(systemName: "chevron.right.square") })
                Spacer()
            }
            .frame(width: 280, height: 100, alignment: .center)
        }
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("No user found"),
                  message: Text("create user first"),
                  dismissButton: .default(Text("Got it")))
        })
    }
    
    func setUserInfo() {
        
        checkValidUser(name)
        name = ""
        
        if isSuccessful == false {
            hasUsername = false
            showAlert = true
        }
        else {
            username = name
            UserDefaults.standard.set(self.username, forKey: "name")
            hasUsername = true
            showAlert = false
        }

    }
    
    func checkValidUser(_ name: String) {
        
        guard let url = getUserNameUrl(name) else {
            print("Error: Cannot create URL")
            isSuccessful = false
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
            
            if response.statusCode == 204 {
                print("no Content")
                return
            }
            else {
                isSuccessful = true
            }
            
        }.resume()

        return
    }
}

struct UserNameFieldView_Previews: PreviewProvider {
    static var previews: some View {
        UserNameFieldView(hasUsername: .constant(true))
    }
}
