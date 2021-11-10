//
//  ContentView.swift
//  googleLogIn
//
//  Created by 권은빈 on 2021/11/10.
//

import SwiftUI

struct ContentView: View {
    
    // Loading status
    @State var isLoading: Bool = false
    
    // Log In Status
    @State var isLogged: Bool = false
    
    var body: some View {
        
        VStack {
            if isLogged {
                LogOutView(isLogged: $isLogged)
            }
            else {
                LogInView(isLoading: $isLoading, isLogged: $isLogged)
            }
        }
        // ProgressView
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(
            ZStack {
                if isLoading {
                    Color.black
                        .opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView()
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        )
    }
}
