//
//  GetUserNameView.swift
//  ToDoList
//
//  Created by 권은빈 on 2021/08/24.
//

import SwiftUI

struct GetUserNameView: View {
   
    @State var hasUsername = false
    
    var body: some View {
        if hasUsername == true {
            MainToDoView()
        }
        else {
            UserNameFieldView(hasUsername: $hasUsername)
        }
    }
}

struct GetUserNameView_Previews: PreviewProvider {
    static var previews: some View {
        GetUserNameView()
    }
}
