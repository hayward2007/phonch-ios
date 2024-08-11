//
//  BoxView.swift
//
//  Created by 김형석 on 8/10/24.
//

import SwiftUI
import CoreMotion
import AVKit

struct ChallengeView: View {
    
    let queue = OperationQueue()
    let motionManager = CMMotionManager()
    let generator = UINotificationFeedbackGenerator()
    
    let sequence = ["hook", "upper_cut", "straight"];
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var x = Double.zero;
    @State private var y = Double.zero;
    @State private var color = Color("BRAND BLACK");
    
    @State private var isStraight = false;
    @State private var isHook = false;
    @State private var isBody = false;
    @State private var started = false;
    @State private var ended = false;
    @State private var leftTime = 60;
    
    @State private var player: AVAudioPlayer?
    @State private var selectedSound: String = ""
    
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: selectedSound, withExtension: "m4a") else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print("Failed to load the sound: \(error)")
        }
        player?.play()
    }
    
    
    var body: some View {
        if(self.ended) {
            VStack(spacing: 24, content: {
                Text("Result")
                    .font(.custom("SUIT-ExtraBold", size: 24))
                    .foregroundStyle(Color("BRAND WHITE"))
                
                HStack {
                    Text("points")
                        .font(.custom("SUIT-ExtraBold", size: 16))
                        .foregroundStyle(Color("BRAND WHITE"))
                        .opacity(0)
                    
                    Text("3")
                        .font(.custom("SUIT-ExtraBold", size: 48))
                        .foregroundStyle(Color("BRAND WHITE"))
                    
                    Text("points")
                        .font(.custom("SUIT-ExtraBold", size: 16))
                        .foregroundStyle(Color("BRAND WHITE"))
                        .frame(height: 48, alignment: .bottom)
                }
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("BRAND WHITE"))
                
                HStack {
                    
                    VStack(spacing: 12) {
                        Text("Correct : 3")
                            .font(.custom("SUIT-ExtraBold", size: 18))
                            .foregroundStyle(Color("BRAND WHITE"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal], 4)
                        
                        Text("Wrong  : 0")
                            .font(.custom("SUIT-ExtraBold", size: 18))
                            .foregroundStyle(Color("BRAND WHITE"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal], 4)
                        
                        Text("Total      : 3")
                            .font(.custom("SUIT-ExtraBold", size: 18))
                            .foregroundStyle(Color("BRAND WHITE"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal], 4)
                    }
                    
                    VStack(spacing: 12) {
                        Text("Straight     : 1")
                            .font(.custom("SUIT-ExtraBold", size: 18))
                            .foregroundStyle(Color("BRAND WHITE"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal], 4)
                        
                        Text("Upper Cut : 1")
                            .font(.custom("SUIT-ExtraBold", size: 18))
                            .foregroundStyle(Color("BRAND WHITE"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal], 4)
                        
                        Text("Hook            : 1")
                            .font(.custom("SUIT-ExtraBold", size: 18))
                            .foregroundStyle(Color("BRAND WHITE"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.horizontal], 4)
                    }
                }

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("BRAND WHITE"))
                HStack(spacing: 24) {
                    VStack {
                        Text("Hook")
                            .font(.custom("SUIT-Bold", size: 20))
                            .foregroundColor(Color("BRAND WHITE"))
                        Spacer()
                        Image("hook")
                            .frame(width: 60, height: 20)
                    }.padding(.top, 14)
                        .padding(.bottom, 23)
                        .frame(width: 100, height: 100)
                        .background(Color("GRAY 900"))
                        .cornerRadius(8)
                    
                    VStack {
                        Text("UprCut")
                            .font(.custom("SUIT-Bold", size: 20))
                            .foregroundColor(Color("BRAND WHITE"))
                        Spacer()
                        Image("upper_cut")
                            .frame(width: 60, height: 20)
                    }.padding(.top, 14)
                        .padding(.bottom, 23)
                        .frame(width: 100, height: 100)
                        .background(Color("GRAY 900"))
                        .cornerRadius(8)
                    
                    VStack {
                        Text("Straight")
                            .font(.custom("SUIT-Bold", size: 20))
                            .foregroundColor(Color("BRAND WHITE"))
                        Spacer()
                        Image("straight")
                            .frame(width: 60, height: 20)
                    }.padding(.top, 14)
                        .padding(.bottom, 23)
                        .frame(width: 100, height: 100)
                        .background(Color("GRAY 900"))
                        .cornerRadius(8)
                }
            }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding([.horizontal], 24)
                .background(Color("BRAND BLACK"))
            
        } else {
            ZStack() {
                VStack(alignment: .center){
                    if (started) {
                        Circle()
                            .frame(width: 96, height: 96)
                            .foregroundColor(Color("BRAND"))
                            .offset(CGSize(width: x * -100, height: (y + 1) * -100))
                    }
                }
                
                if (started) {
                    Text(String(self.leftTime))
                        .onReceive(self.timer, perform: { _ in
                            self.leftTime -= 1;
                        })
                        .font(.custom("SUIT-ExtraBold", size: 70))
                        .foregroundColor(Color("GRAY 800"))
                        .offset(CGSize(width: 0, height:  -200))
                }
                    
                if(!started) {
                    var index = 0;
                    
                    Button(action: {
                        var t = TimeInterval();
                        let e = 0.25;
                        
                        self.selectedSound = self.sequence[index];
                        self.playSound();
                        
                        self.motionManager.startDeviceMotionUpdates();
                        self.motionManager.startAccelerometerUpdates(to: self.queue) {
                            data, _ in
                            
                            self.x = data!.acceleration.x;
                            self.y = data!.acceleration.y;
                            
                            if(data!.timestamp.distance(to: t) > -0.3) { return; }
                            
                            let geo = self.motionManager.deviceMotion?.attitude;
                            
                            
                            if (!self.isHook &&
                                self.x < -1.5 &&
                                geo!.pitch > 1.5 - e &&
                                geo!.pitch < 1.5 + e) {
                                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning);
                                self.isHook = true;
                                self.color = Color.red;
                                t = data!.timestamp;
                                
                                if(self.sequence[index] == "hook") {
                                    index += 1;
                                    if(index == self.sequence.count) {
                                        self.motionManager.stopDeviceMotionUpdates();
                                        self.motionManager.stopAccelerometerUpdates();
                                        self.ended = true;
                                        return;
                                    }
                                    self.selectedSound = self.sequence[index];
                                    self.playSound();
                                }
                                
                                return;
                                
                            } else if(!self.isBody &&
                                      self.x < -1.5 &&
                                      geo!.roll < 1 + e &&
                                      geo!.roll > 1 - e ) {
                                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning);
                                self.isBody = true;
                                self.color = Color.yellow;
                                t = data!.timestamp;
                                
                                if(self.sequence[index] == "upper_cut") {
                                    index += 1;
                                    if(index == self.sequence.count) {
                                        self.motionManager.stopDeviceMotionUpdates();
                                        self.motionManager.stopAccelerometerUpdates();
                                        self.ended = true;
                                        return;
                                    }
                                    self.selectedSound = self.sequence[index];
                                    self.playSound();
                                }
                                
                                return;
                                
                            } else if(!self.isStraight &&
                                      self.x < -3 &&
                                      geo!.pitch > -0.4 &&
                                      geo!.pitch < 0.4 &&
                                      geo!.roll < 2.5 &&
                                      geo!.roll < -2.5 ) {
                                generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning)
                                self.isStraight = true;
                                self.color = Color.blue;
                                t = data!.timestamp;
                                
                                if(self.sequence[index] == "straight") {
                                    index += 1;
                                    if(index == self.sequence.count) {
                                        self.motionManager.stopDeviceMotionUpdates();
                                        self.motionManager.stopAccelerometerUpdates();
                                        self.ended = true;
                                        return;
                                    }
                                    self.selectedSound = self.sequence[index];
                                    self.playSound();
                                }
                                
                                return;
                                
                            }
                            
                            self.isStraight = false;
                            self.isHook = false;
                            self.isBody = false;
                            if (self.color != Color("BRAND BLACK")) {
                                self.color = Color("BRAND BLACK");
                            }
                            
                            self.started = true;
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 256, height: 256)
                                .foregroundColor(Color("BRAND"))
                                .offset(CGSize(width: 0, height: -40.0))
                            
                            Text("Start")
                                .font(.custom("SUIT-Bold", size: 48))
                                .foregroundColor(Color("BRAND WHITE"))
                                .offset(CGSize(width: 0, height: -40.0))
                        }
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(color)
            .onDisappear {
                self.motionManager.stopDeviceMotionUpdates();
                self.motionManager.stopAccelerometerUpdates();
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChallengeView()
    }
}
