//
//  SandBoxView.swift
//  phonch
//
//  Created by 김형석 on 8/10/24.
//

import SwiftUI
import CoreMotion
import AVKit
import AVFoundation

struct SandBoxView: View {
    
    let queue = OperationQueue()
    let motionManager = CMMotionManager()
    let generator = UINotificationFeedbackGenerator()
    
    @State private var x = Double.zero;
    @State private var y = Double.zero;
    @State private var color = Color("BRAND BLACK");
    
    @State private var isStraight = false;
    @State private var isHook = false;
    @State private var isUpperCut = false;
    
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
        ZStack() {
            VStack(alignment: .center){
                Circle()
                    .frame(width: 96, height: 96)
                    .foregroundColor(Color("BRAND WHITE"))
                    .offset(CGSize(width: x * -100, height: (y + 1) * -100))
                
            }
            VStack {
                Spacer()
                
                HStack {
                    if(!isHook && !isUpperCut) {
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
                    
                    Spacer()
                    
                    if(!isUpperCut && !isStraight) {
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
                    }
                    
                    Spacer()
                    
                    if(!isStraight && !isHook) {
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
                    }
                    
                }.padding(24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .onAppear {
            var t = TimeInterval();
            
            self.motionManager.startDeviceMotionUpdates();
            self.motionManager.startAccelerometerUpdates(to: self.queue) {
                data, _ in
                
                self.x = data!.acceleration.x;
                self.y = data!.acceleration.y;
                
                if(data!.timestamp.distance(to: t) > -0.3) { return; }
                
                let geo = self.motionManager.deviceMotion?.attitude;
                let e = 0.25;

                if (!self.isHook &&
                    self.x < -1.5 &&
                    geo!.pitch > 1.5 - e &&
                    geo!.pitch < 1.5 + e) {
                    
                    generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning);
                    
                    self.isHook = true;
                    self.color = Color.red;
                    t = data!.timestamp;
                    self.selectedSound = "hook";
                    self.playSound();
                    
                    return;
                    
                } else if(!self.isUpperCut &&
                          self.x < -1.5 &&
                          geo!.roll < 1 + e &&
                          geo!.roll > 1 - e ) {
                    
                    generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning);
                    
                    self.isUpperCut = true;
                    self.color = Color.yellow;
                    t = data!.timestamp;
                    self.selectedSound = "upper_cut";
                    self.playSound();
                    
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
                    self.selectedSound = "straight";
                    self.playSound();
                    
                    return;
                    
                }
                
                self.isStraight = false;
                self.isHook = false;
                self.isUpperCut = false;
                if (self.color != Color("BRAND BLACK")) {
                    self.color = Color("BRAND BLACK");
                }
            }
        }.onDisappear {
            self.motionManager.stopDeviceMotionUpdates();
            self.motionManager.stopAccelerometerUpdates();
        }
    }
}

#Preview {
    NavigationStack {
        SandBoxView()
    }
}
