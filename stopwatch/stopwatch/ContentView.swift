//
//  ContentView.swift
//  stopwatch
//
//  Created by 권은빈 on 2021/07/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var leftBtnText = "랩"
    @State var rightBtnText = "시작"
    @State var timerState = "init"
    @State var laps = [String]()
    @State var mainTimer: Timer?
    @State var timeCount = 0
    @State var timeNow = "00:00.00"
    
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
