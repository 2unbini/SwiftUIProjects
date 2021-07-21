//
//  ContentView.swift
//  slotgame
//
//  Created by 권은빈 on 2021/07/21.
//

import SwiftUI

struct ContentView: View {
    
    var images = ["doraekwon", "nosunkim", "gtungpark"]
    @State var credits = 5000
    @State var firstImage = "doraekwon"
    @State var secondImage = "nosunkim"
    @State var thirdImage = "gtungpark"
    @State var showPopUp = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("🌈Happy?🍎 ⭐️Slots!🍒")
                .font(.title)
                .fontWeight(.bold).padding()
            Spacer()
            Text("Credits: " + String(credits))
                .fontWeight(.medium)
            Spacer()
            HStack {
                Image(firstImage).resizable().frame(width: 100, height: 100)
                Image(secondImage).resizable().frame(width: 100, height: 100)
                Image(thirdImage).resizable().frame(width: 100, height: 100)
            }
            Spacer()
            Button(action: {
                let randNumOne = Int.random(in: 0...2)
                let randNumTwo = Int.random(in: 0...2)
                let randNumThree = Int.random(in: 0...2)
                
                firstImage = images[randNumOne]
                secondImage = images[randNumTwo]
                thirdImage = images[randNumThree]
                
                if randNumOne == randNumTwo && randNumOne == randNumThree {
                    credits += 420
                } else {
                    credits -= 42
                }
                
                if credits > 5252 {
                    showPopUp = true
                }
                
            }, label: {
                Text("SPIN!").fontWeight(.bold).foregroundColor(Color.white).padding().background(Color.pink).cornerRadius(50)
            }).popover(isPresented: $showPopUp, content: {
                VStack {
                    Image("gotcha")
                    Text("5252... You got me,,").font(.headline).padding()
                }
            })
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
