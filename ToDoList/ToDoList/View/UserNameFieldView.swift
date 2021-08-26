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
    @State private var username = UserDefaults.standard.string(forKey: "name")
    
    var body: some View {
        VStack {
            Spacer()
            Text("What's your name?")
            HStack {
                Spacer()
                Image(systemName: "person")
                    .frame(width: 30, height: 30, alignment: .leading)
                Spacer()
                TextField("write username", text: $name)
                Spacer()
                Button(action: { setName() }, label: { Image(systemName: "chevron.right.square") })
                Spacer()
            }
            .frame(width: 300, height: 100, alignment: .center)
            Spacer()
        }
    }
    
    func setName() {
        username = name
        hasUsername = true
        UserDefaults.standard.set(self.username, forKey: "name")
    }
}

struct UserNameFieldView_Previews: PreviewProvider {
    static var previews: some View {
        UserNameFieldView(hasUsername: .constant(true))
    }
}
