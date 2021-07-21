//
//  ContentView.swift
//  war_challengeApp
//
//  Created by 권은빈 on 2021/07/20.
//

import SwiftUI

struct ContentView: View {
    
    // @State -> allow us to update value
    // -> data changes automatically update the preview
    @State var playerCard = "card4"
    @State var cpuCard = "card9"
    @State var playerScore = 0
    @State var cpuScore = 0
    
    var body: some View {
        VStack() {
            Spacer()
            Image("logo")
            Spacer()
            HStack() {
                Spacer()
                Image(playerCard)
                Spacer()
                Image(cpuCard)
                Spacer()
            }
            Spacer()
            Button(action: {
                
                // Generate random number between 2 and 14
                let playerRand = Int.random(in: 2...14)
                let cpuRand = Int.random(in: 2...14)
                
                // Update the cards
                playerCard = "card" + String(playerRand)
                cpuCard = "card" + String(cpuRand)
                
                
                // Update the score
                if playerRand > cpuRand {
                    playerScore += 1
                } else if cpuRand > playerRand {
                    cpuScore += 1
                } else {
                    playerScore += 1
                    cpuScore += 1
                }
                
                
            }, label: {
                
                Image("dealbutton")
                
            })
            Spacer()
            HStack() {
                Spacer()
                VStack() {
                    Text("Player").font(.headline).foregroundColor(Color.white).padding(.bottom)
                    Text(String(playerScore)).font(.largeTitle).foregroundColor(Color.white)
                }
                Spacer()
                VStack() {
                    Text("CPU").font(.headline).foregroundColor(Color.white).padding(.bottom)
                    Text(String(cpuScore)).font(.largeTitle).foregroundColor(Color.white)
                }
                Spacer()
            }
            Spacer()

        }.background(Image("background").ignoresSafeArea(.keyboard, edges: .bottom))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
