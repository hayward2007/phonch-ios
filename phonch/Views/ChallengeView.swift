//
//  BoxView.swift
//  phonch
//
//  Created by 김형석 on 8/10/24.
//

import SwiftUI
import CoreMotion

struct ChallengeView: View {
    
    let queue = OperationQueue()
    let motionManager = CMMotionManager()
    let generator = UINotificationFeedbackGenerator()
    
    @State private var x = Double.zero;
    @State private var y = Double.zero;
    @State private var color = Color("BRAND BLACK");
    
    @State private var isStraight = false;
    @State private var isHook = false;
    @State private var isBody = false;
    
    
    var body: some View {
        VStack(alignment: .center){
            Circle()
                .frame(width: 96, height: 96)
                .foregroundColor(Color("BRAND"))
                .offset(CGSize(width: x * -100, height: (y + 1) * -100))
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(color)
        .onAppear {
            var t = TimeInterval();
            
            self.motionManager.startDeviceMotionUpdates();
            self.motionManager.startAccelerometerUpdates(to: self.queue) {
                data, _ in
                
                self.x = data!.acceleration.x;
                self.y = data!.acceleration.y;
                
                let geo = self.motionManager.deviceMotion?.attitude;
                let e = 0.25;
                
                if(data!.timestamp.distance(to: t) > -0.3) { return; }

                if (!self.isHook &&
                    self.x < -2 &&
                    geo!.pitch > 1.5 - e &&
                    geo!.pitch < 1.5 + e) {
                    generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning);
                    self.isHook = true;
                    self.color = Color.red;
                    t = data!.timestamp;
                    return;
                    
                } else if(!self.isBody &&
                          self.x < -1.5 &&
                          geo!.roll < 1 + e &&
                          geo!.roll > 1 - e ) {
                    generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning);
                    self.isBody = true;
                    self.color = Color.yellow;
                    t = data!.timestamp;
                    return;
                    
                } else if(!self.isStraight &&
                          self.x < -3.5 &&
                          geo!.pitch > -0.4 &&
                          geo!.pitch < 0.4 &&
                          geo!.roll < 2.5 &&
                          geo!.roll < -2.5 ) {
                    generator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.warning)
                    self.isStraight = true;
                    self.color = Color.blue;
                    t = data!.timestamp;
                    return;
                    
                }
                
                self.isStraight = false;
                self.isHook = false;
                self.isBody = false;
                if (self.color != Color("BRAND BLACK")) {
                    self.color = Color("BRAND BLACK");
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChallengeView()
    }
}
