//
//  ContentView.swift
//  timer
//
//  Created by 권은빈 on 2021/07/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TimerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct TimerView: View {
    // timerRunning : to check if the timer is running
    // timerEnds : to check if the timer ends
    // btnState : to check the state to change the text of the button
    // leftTime : the whole time of the timer. If leftTime equals zero, do nothing.
    // timeNow : the label that appears how much time left.
    // (hours, minutes, seconds)Index : get the picker value
    
    @State var timerRunning = false
    @State var timerEnds = false
    @State var btnState = "select"
    @State private var leftBtnText = "취소"
    @State private var rightBtnText = "시작"
    @State private var mainTimer: Timer?
    @State var leftTime = -1
    @State var timeNow = "00:00:00"
    @State var hoursIndex = 0
    @State var minutesIndex = 0
    @State var secondsIndex = 0
    
    var body: some View {
        VStack {
            Spacer()
            if timerRunning {
                Text(timeNow).font(.custom("Verdana", size: 70)).frame(height: 200)
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 5).frame(width: UIScreen.main.bounds.size.width-130, height: 32).foregroundColor(.gray)
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Picker("", selection: self.$hoursIndex) {
                            ForEach(0..<24, id: \.self) {
                                Text(String($0)).fontWeight(.bold).tag($0)
                            }
                        }
                        .labelsHidden()
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(width: 40, height: 160)
                        .clipped()
                        Text("시간").fontWeight(.semibold).padding(.trailing, 13)
                        
                        Picker("", selection: self.$minutesIndex) {
                            ForEach(0..<60, id: \.self) {
                                Text(String($0)).fontWeight(.bold).tag($0)
                            }
                        }
                        .labelsHidden()
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(width: 40, height: 160)
                        .clipped()
                        Text("분").fontWeight(.semibold).padding(.trailing, 23)
                        
                        Picker("", selection: self.$secondsIndex) {
                            ForEach(0..<60, id: \.self) {
                                Text(String($0)).fontWeight(.bold).tag($0)
                            }
                        }
                        .labelsHidden()
                        .fixedSize(horizontal: true, vertical: true)
                        .frame(width: 40, height: 160)
                        .clipped()
                        Text("초").fontWeight(.semibold).padding(.trailing, 10)
                        
                        Spacer()
                    }
                    .frame(height: 200)
                    .mask(Rectangle())
                }
            }
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    leftBtnAction()
                }, label: {
                    Text(leftBtnText).font(.custom("AppleSDGothicNeo", size: 20)).fontWeight(.bold).frame(width: 80, height: 80).cornerRadius(100).foregroundColor(.white).background(Color.gray).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }).disabled(timerRunning == false)
                Spacer()
                Button(action: {
                    rightBtnAction()
                }, label: {
                    Text(rightBtnText).font(.custom("AppleSDGothicNeo-Regular", size: 20)).fontWeight(.bold).frame(width: 80, height: 80).cornerRadius(100).foregroundColor(.blue).background(Color.black).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                })
                Spacer()
            }
            Spacer()
        }
        .alert(isPresented: $timerEnds) {
            Alert(title: Text("타이머 종료"),
                  dismissButton: .default(Text("끄기")))
        }
    }
    
    func leftBtnAction() {
        
        switch btnState {
        case "select":
            print("left btn inactive")
        case "paused", "countingDown":
            resetTimer()
        default:
            print("left btn inactive")
        }
    }
    
    func rightBtnAction() {
        
        switch btnState {
        case "select", "paused":
            if leftTime != 0 {
                startTimer()
            }
        case "countingDown":
            pauseTimer()
        default:
            print("right btn active")
        }
    }
    
    // get whole time of the timer
    func getLeftTime() -> Int {
        let hour = hoursIndex
        let minuite = minutesIndex
        let second = secondsIndex
        
        return (hour * 60 * 60) + (minuite * 60) + second
    }
    
    // make time label to appear the time left
    func makeTimeLabel() -> String {
        let sec = (leftTime % 60)
        let min = (leftTime / 60) % 60
        let hour = (leftTime / 60) / 60
        
        let sec_string = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        let hour_string = "\(hour)".count == 1 ? "0\(hour)" : "\(hour)"
        
        return "\(hour_string):\(min_string):\(sec_string)"
    }
    
    // start the timer
    func startTimer() {
        
        // if the state is "paused" => no need to get the time again
        // if calculated leftTime equals zero, make leftTime = -1 and return to do nothing
        if btnState != "paused" {
            leftTime = getLeftTime()
            if leftTime == 0 {
                leftTime = -1
                return
            }
        }
        
        // make time label(String) and update the state
        // do this before the timer starts because of the first one sec
        timeNow = makeTimeLabel()
        timerRunning = true
        timerEnds = false
        
        // loop timer with one sec interval
        // if the leftTime goes below to zero(which means It's time to end the timer),
        // stop the timer and reset whole settings
        mainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            
            leftTime -= 1
            
            if (leftTime <= 0) {
                
                mainTimer?.invalidate()
                leftTime = -1
                timerRunning = false
                timerEnds = true
                rightBtnText = "시작"
                btnState = "select"
                return
            }
            
            DispatchQueue.main.async {
                timeNow = makeTimeLabel()
            }
        })
        
        // change the button text and state
        rightBtnText = "일시 정지"
        btnState = "countingDown"
    }
    
    // if the timer paused, timer should be invalidated.
    func pauseTimer() {
        
        // pausing timer
        mainTimer?.invalidate()
        
        // change the button text and state
        rightBtnText = "재개"
        btnState = "paused"
    }
    
    // reset whole settings
    func resetTimer() {
        // reset timer
        mainTimer?.invalidate()
        leftTime = -1
        hoursIndex = 0
        minutesIndex = 0
        secondsIndex = 0
        
        // leftBtn : active -> inactive
        // reset time, and countingDown = false
        rightBtnText = "시작"
        btnState = "select"
        timerRunning = false
    }
}
