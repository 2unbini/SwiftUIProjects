//
//  GoogleLogInView.swift
//  googleLogIn
//
//  Created by 권은빈 on 2021/11/10.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleLogInView: View {
    
    // Environment value to dismiss view
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Loading and Login status
    @Binding var isLoading: Bool
    @Binding var isLogged: Bool
    
    var body: some View {
        
        Button(action: {
            handleLogIn()
        }, label: {
            Text("Sign With Google")
        })
    }
    
    
    // Handling log in with... Google
    func handleLogIn() {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        isLoading = true
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: getRootViewController()) { [self] user, error in
            
            if let error = error {
                isLoading = false
                print(error.localizedDescription)
                return
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                isLoading = false
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { result, error in
                
                isLoading = false
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    return
                }
                
                print(user.displayName ?? "Success")
                
                withAnimation{
                    isLogged = true
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            
        }
    }
}


// To use Google login framework, you need UIViewController
extension View {
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}


