//
//  HomeView.swift
//  phonch
//
//  Created by 김형석 on 8/10/24.
//

import SwiftUI

struct HomeView: View {
    @State private var rank_type = "Today's";
    
    func rank(place: Int, name: String, record: Int, backgroundColor: Color = Color("GRAY 800")) -> some View { HStack(spacing: 12) {
        Text(String(place)+".")
            .font(.custom("SUIT-Bold", size: 16))
            .foregroundColor(Color("BRAND WHITE"))
            .frame(width: 20, alignment: .trailing)
        
        Text(name)
            .font(.custom("SUIT-SemiBold", size: 16))
            .foregroundColor(Color("BRAND WHITE"))
                 Spacer()
        
        HStack(spacing: 8) {
            Image("rank")
                .frame(width: 20, height: 20)
            
            Text(String(record))
                .font(.custom("SUIT-SemiBold", size: 16))
                .foregroundColor(Color("BRAND WHITE"))
            
        }.padding([.top, .leading, .bottom], 4)
            .padding([.trailing], 8)
            .background(Color("BRAND BLACK"))
            .cornerRadius(8)
        
    }.padding(8)
        .background(backgroundColor)
        .cornerRadius(12)
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 24) {
                    HStack {
                        Button(action: {
                            if (rank_type == "Today's") { rank_type = "Total" }
                            else { rank_type = "Today's" }
                        }, label: {
                            Image("autorenew")
                                .frame(width: 28, height: 28)
                        })
                        
                        Spacer()
                        
                        Text("\(rank_type) Ranking")
                            .font(.custom("SUIT-ExtraBold", size: 24))
                            .foregroundColor(Color("BRAND WHITE"))
                        
                        Spacer()
                        
                        NavigationLink(
                            destination: UserView(),
                            label: {
                                Image("account_circle")
                                    .frame(width: 28, height: 28)
                            }
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12, content: {
                        if (rank_type == "Today's") {
                            rank(place: 6, name: "sang._.7 (KR)", record: 14, backgroundColor: Color("GREEN"))
                        } else {
                            rank(place: 9, name: "sang._.7 (KR)", record: 25, backgroundColor: Color("GREEN"))
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("BRAND WHITE"))
                            .padding([.horizontal], 6)
                        
                        ScrollView() {
                            VStack(alignment: .leading, spacing: 12) {
                                if (rank_type == "Today's") {
                                    rank(place: 1, name: "hayward_kim (KR)", record: 999)
                                    rank(place: 2, name: "sspzoa (KR)", record: 180)
                                    rank(place: 3, name: "luke0422 (KR)", record: 150)
                                    rank(place: 4, name: "__junhuihong (KR)", record: 144)
                                    rank(place: 5, name: "cksgurlee (KR)", record: 124)
                                        .padding(.bottom, 150)
                                    
                                } else {
                                    rank(place: 1, name: "hayward_kim (KR)", record: 999)
                                    rank(place: 2, name: "luke0422 (KR)", record: 401)
                                    rank(place: 3, name: "__junhuihong (KR)", record: 203)
                                    rank(place: 4, name: "cksgurlee (KR)", record: 201)
                                    rank(place: 5, name: "sspzoa (KR)", record: 189)
                                    rank(place: 6, name: "dev._ho (KR)", record: 177)
                                    rank(place: 7, name: "exon001 (KR)", record: 162)
                                    rank(place: 8, name: "wxdnxd_07 (KR)", record: 160)
                                        .padding(.bottom, 150)
                                }
                            }}
                        .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                        
                        
                    })
                    
                    .mask(
                        LinearGradient(gradient: Gradient(stops: [
                            .init(color: .black, location: 0.5),
                            .init(color: .clear, location: 1.0)]),
                                       
                        startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all))}
                
                .padding([.horizontal, .top], 24)
                    .frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                
                HStack(spacing: 24) {
                    NavigationLink(destination: ChallengeView(), label: {
                        VStack(alignment: .center, spacing: 12) {
                            Image("challenge")
                                .frame(width: 128, height: 128)
                            
                            Text("Challenge")
                                .font(.custom("SUIT-SemiBold", size: 24))
                                .foregroundColor(Color.white)
                            
                        }.padding(.top, 12)
                            .padding(.bottom, 24)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color("GRAY 900"))
                        .cornerRadius(12)})
                    
                    NavigationLink(destination: SandBoxView(), label: {
                        VStack(alignment: .center, spacing: 12) {
                            Image("sandbox")
                                .frame(width: 128, height: 128)
                            
                            Text("SandBox")
                                .font(.custom("SUIT-SemiBold", size: 24))
                                .foregroundColor(Color.white)
                            
                        }.padding(.top, 12)
                            .padding(.bottom, 24)
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                            .background(Color("GRAY 900"))
                            .cornerRadius(12)
                    })
                }.padding([.horizontal, .bottom], 24).padding(.top, 12)
            }.background(Color("BRAND BLACK"))
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
