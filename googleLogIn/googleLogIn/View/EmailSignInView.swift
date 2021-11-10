//
//  EmailSignInView.swift
//  googleLogIn
//
//  Created by 권은빈 on 2021/11/10.
//

import SwiftUI
import Firebase

struct EamilSignInView: View {
    
    // Environment value to dismiss view
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Loading and Login Status
    @Binding var isLoading: Bool
    @Binding var isLogged: Bool
    
    // email and password
    @State private var email: String = ""
    @State private var password: String = ""
    
    // error alert
    @State private var showAlert: Bool = false
    @State private var errorMessage = ""
    
    var body: some View {
        
        VStack {
            
            // Sign with Email
            VStack(alignment: .center) {
                
                Text("Sign with Email")
                    .font(.largeTitle)
                    .padding(.bottom, 60)
                
                Group {
                    TextField("email", text: $email)
                    SecureField("password", text: $password)
                }
                .textFieldStyle(.roundedBorder)
                .frame(width: 300)
                .padding(.bottom, 10)

                Button("Sign in") {
                    handleSignInWithEmail()
                }
            }
            .alert(isPresented: $showAlert) {
                
                Alert(title: Text("Sign in Failed!"),
                      message: Text("\(errorMessage)\nDismiss to retry"),
                      dismissButton: .default(Text("Dismiss"), action: {
                    showAlert = false
                }))
            }
            
            // Sign with Google
            GoogleLogInView(isLoading: $isLoading, isLogged: $isLogged)
        }
        
    }
    
    
    // Handling Sign with... Email
    func handleSignInWithEmail() {
        
        // Loading status on
        isLoading = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            // init email and pw and Loading status off
            self.email = ""
            self.password = ""
            isLoading = false
            
            if let error = error {
                self.showAlert = true
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
                return
            }
            
            guard let user = result?.user else {
                return
            }
            
            withAnimation{
                self.isLogged = true
            }
            print(user)
        }
    }
}
