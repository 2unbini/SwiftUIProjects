//
//  LogOutView.swift
//  googleLogIn
//
//  Created by 권은빈 on 2021/11/10.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LogOutView: View {
    
    @Binding var isLogged: Bool
    
    var body: some View {
        VStack {
            Text("Successfully Logged In")
            
            Button(action: {
                handleLogOut()
            }, label: {
                Text("Log Out")
            })
        }
    }
    
    func handleLogOut() {
        GIDSignIn.sharedInstance.signOut()
        try? Auth.auth().signOut()
        
        withAnimation{
            isLogged = false
        }
    }
}

