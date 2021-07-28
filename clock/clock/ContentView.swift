//
//  ContentView.swift
//  clock
//
//  Created by 권은빈 on 2021/07/28.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            StopWatchView()
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("스톱워치")
                }
            TimerView()
                .tabItem{
                    Image(systemName: "timer")
                    Text("타이머")
                }
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct StopWatchView: View {
    @State private var leftBtnText = "랩"
    @State private var rightBtnText = "시작"
    @State var timerState = "init"
    @State var laps = [String]()
    @State private var mainTimer: Timer?
    @State private var timeCount = 0
    @State private var timeNow = "00:00.00"
    
    var body: some View {
        VStack {
            Spacer()
            Text(timeNow)
                .font(.custom("Verdana", size: 70))
                .position(x: 185, y: 160)
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    switch timerState {
                    case "ongoing":
                        lap()
                    case "stop":
                        reset()
                        timerState = "init"
                    default:
                        break
                    }
                }, label: {
                    Text(leftBtnText).font(.custom("AppleSDGothicNeo", size: 20)).fontWeight(.bold).frame(width: 80, height: 80).cornerRadius(100).foregroundColor(.white).background(Color.gray).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                })
                Spacer()
                Button(action: {
                    switch timerState {
                    case "init":
                        start()
                        timerState = "ongoing"
                    case "ongoing":
                        stop()
                        timerState = "stop"
                    case "stop":
                        start()
                        timerState = "ongoing"
                    default:
                        break
                    }
                }, label: {
                    Text(rightBtnText).font(.custom("AppleSDGothicNeo-Regular", size: 20)).fontWeight(.bold).frame(width: 80, height: 80).cornerRadius(100).foregroundColor(.blue).background(Color.black).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                })
                Spacer()
            }.padding(.bottom, 20)
            Divider()
            ScrollViewReader { scrollProxy in
                ScrollView {
                    ForEach(0..<laps.count, id: \.self) { i in
                        HStack {
                            Text("랩 \(laps.count - i)").padding(.leading, 20).padding(.vertical, 5).font(.custom("ArialMT", size: 20))
                            Spacer()
                            Text(laps[laps.count - (i + 1)])
                                .padding(.trailing, 20).padding(.vertical, 5).font(.custom("ArialMT", size: 20))
                        }
                        Divider()
                    }
                }
            }
        }
    }
    
    func makeTimeLabel(count: Int) -> String {
        let msec = count % 100
        let sec = (count / 100) % 60
        let min = (count / 100) / 60
        
        let msec_string = "\(msec)".count == 1 ? "0\(msec)" : "\(msec)"
        let sec_string = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        
        return "\(min_string):\(sec_string).\(msec_string)"
    }
    
    func start() {
        // start the main timer
        mainTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
            timeCount += 1
            
            DispatchQueue.main.async {
                timeNow = makeTimeLabel(count: timeCount)
            }
        })
        RunLoop.current.add(mainTimer!, forMode: .common)
        
        // start -> stop
        leftBtnText = "랩"
        rightBtnText = "중단"
    }
    
    func stop() {
        // stop the main timer
        mainTimer?.invalidate()
        
        // lap -> reset
        // stop -> start
        leftBtnText = "재설정"
        rightBtnText = "시작"
    }
    
    func lap() {
        // save the moment to the list
        self.laps.append(timeNow)
    }
    
    func reset() {
        // reset timer
        timeNow = "00:00.00"
        timeCount = 0
        
        // reset list
        laps.removeAll()
        
        // reset -> lap
        leftBtnText = "랩"
    }
}

struct TimerView: View {
    @State var countingDown = false
    @State var timerEnds = false
    @State var btnState = "select"
    @State private var leftBtnText = "취소"
    @State private var rightBtnText = "시작"
    @State private var mainTimer: Timer?
    @State var leftTime = 60
    @State var timeNow = "00:00:00"
    @State var hoursIndex = 0
    @State var minutesIndex = 0
    @State var secondsIndex = 0
    
    var body: some View {
        VStack {
            Spacer()
            if countingDown {
                Text(timeNow).font(.custom("Verdana", size: 70)).frame(height: 200)
            } else {
                //SelectTimeView()
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
                }).disabled(countingDown == false)
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
    
    func getLeftTime() -> Int {
        let hour = hoursIndex
        let minuite = minutesIndex
        let second = secondsIndex
        
        return (hour * 60 * 60) + (minuite * 60) + second
    }
    
    func makeTimeLabel() -> String {
        /*
        if leftTime < 0 {
            mainTimer?.invalidate()
            leftTime = 0
            countingDown = false
            return "00:00:00"
        }
 */
        print(leftTime)
        
        let sec = (leftTime % 60)
        let min = (leftTime / 60) % 60
        let hour = (leftTime / 60) / 60
        
        let sec_string = "\(sec)".count == 1 ? "0\(sec)" : "\(sec)"
        let min_string = "\(min)".count == 1 ? "0\(min)" : "\(min)"
        let hour_string = "\(hour)".count == 1 ? "0\(hour)" : "\(hour)"

        print("\(hour_string):\(min_string):\(sec_string)")
        
        return "\(hour_string):\(min_string):\(sec_string)"
    }
    
    func startTimer() {
        // starting and continueing timer
        if btnState != "paused" {
            leftTime = getLeftTime()
            if leftTime == 0 {
                leftTime = -1
                return
            }
        }
        timeNow = makeTimeLabel()
        countingDown = true
        timerEnds = false
        
        mainTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            leftTime -= 1
            if (leftTime <= 0) {
                mainTimer?.invalidate()
                leftTime = -1
                countingDown = false
                timerEnds = true
                rightBtnText = "시작"
                btnState = "select"
                return
            }
            DispatchQueue.main.async {
                timeNow = makeTimeLabel()
            }
        })
        // leftBtn : inactive -> active
        rightBtnText = "일시 정지"
        btnState = "countingDown"
    }
    
    func pauseTimer() {
        // pausing timer
        mainTimer?.invalidate()
        
        rightBtnText = "재개"
        btnState = "paused"
        // countdown pauses
    }
    
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
        countingDown = false
    }
}

