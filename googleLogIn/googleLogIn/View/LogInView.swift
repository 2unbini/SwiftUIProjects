//
//  LogInView.swift
//  googleLogIn
//
//  Created by 권은빈 on 2021/11/10.
//

import SwiftUI
import Firebase

struct LogInView: View {
    
    // loading and login status
    @Binding var isLoading: Bool
    @Binding var isLogged: Bool
    
    // alert when error occurs
    @State private var showAlert: Bool = false
    @State private var errorMessage: String = ""
    
    // email and password
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center) {
                
                Text("Log In")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 60)
                
                Group {
                    TextField("email", text: $email)
                    SecureField("password", text: $password)
                }
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .padding(.bottom, 10)
                
                Button("Log in") {
                    handleLogInWithEmail()
                }
                .padding(.bottom, 20)
                
                NavigationLink("Sign in", destination: EamilSignInView(isLoading: $isLoading, isLogged: $isLogged))
            }
            // alert when showAlert == true
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Log In Failed"),
                      message: Text("\(errorMessage)\nDismiss to retry"),
                      dismissButton: .default(Text("Dismiss")))
            }
        }
    }
    
    
    // handling log in... with Email
    func handleLogInWithEmail() {
        
        // loading status on
        isLoading = true
        
        // sign in with email and pw using firebase
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            
            email = ""
            password = ""
            
            if let error = error {
                isLoading = false
                showAlert = true
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
            
            guard let user = result?.user else {
                return
            }
            
            withAnimation{
                isLoading = false
                isLogged = true
            }

            print(user)
        }
    }
}

