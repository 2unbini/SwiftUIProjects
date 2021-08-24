//
//  GetUserNameView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct GetUserNameView: View {
    @State private var name = ""
    @State private var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        Spacer()
        Text("What's your name?")
        HStack {
            Spacer()
            Image(systemName: "person")
                .frame(width: 30, height: 30, alignment: .leading)
            Spacer()
            TextField("write username", text: $name)
            Spacer()
            Button(action: { setNameAndReload() }, label: { Image(systemName: "chevron.right.square") })
            Spacer()
        }
        .frame(width: 300, height: 100, alignment: .center)
        Spacer()
    }
    
    func setNameAndReload() {
        username = name
        UserDefaults.standard.set(self.username, forKey: "name")
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: ContentView())
            window.makeKeyAndVisible()
        }
    }
}

struct GetUserNameView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserNameView()
    }
}
