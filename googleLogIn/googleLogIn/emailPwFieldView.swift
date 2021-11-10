//
//  emailPwFieldView.swift
//  googleLogIn
//
//  Created by 권은빈 on 2021/11/10.
//

import SwiftUI

struct emailPwFieldView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            TextField("email", text: $email)
            SecureField("password", text: $password)
            Button("Sign in") {
                handleSignInWithEmail()
            }
        }
    }
}

struct emailPwFieldView_Previews: PreviewProvider {
    static var previews: some View {
        emailPwFieldView()
    }
}
