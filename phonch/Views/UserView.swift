//
//  UserView.swift
//  phonch
//
//  Created by 김형석 on 8/11/24.
//

import SwiftUI

struct UserView: View {
    
    func history(record: Int, date: String) -> some View {
        NavigationLink(destination: HistoryView(), label: {
        HStack {
            HStack(spacing: 8) {
                Image("rank")
                    .frame(width: 20, height: 20)
                
                Text(String(record))
                    .font(.custom("SUIT-SemiBold", size: 16))
                    .foregroundColor(Color("BRAND WHITE"))
                
            }.padding([.top, .leading, .bottom], 8)
                .padding([.trailing], 16)
                .background(Color("BRAND BLACK"))
                .cornerRadius(8)
                
            Spacer()
            
            Text(String(date))
                .font(.custom("SUIT-SemiBold", size: 16))
                .foregroundColor(Color("BRAND WHITE"))
            

        }.padding([.top, .leading, .bottom], 4)
            .padding([.trailing], 12)
            .background(Color("GRAY 800"))
            .cornerRadius(12)
        })}
    
    var body: some View {
        VStack(spacing: 24) {
            Text("History")
                .font(.custom("SUIT-ExtraBold", size: 24))
                .foregroundStyle(Color("BRAND WHITE"))
            
            
            ScrollView() {
                VStack(alignment: .leading, spacing: 12) {
                    history(record: 100, date: "2024 07 26")
                    history(record: 114, date: "2024 07 25")
                    history(record: 234, date: "2024 07 24")
                    history(record: 14, date: "2024 07 23")
                    history(record: 134, date: "2024 07 22")
                    history(record: 734, date: "2024 07 21")
                    history(record: 234, date: "2024 07 19")
                    history(record: 246, date: "2024 07 17")
                    history(record: 596, date: "2024 07 16")
                    history(record: 456, date: "2024 07 15")
                    history(record: 234, date: "2024 07 14")
                }.padding([.horizontal], 24)
            }.frame(maxHeight: .infinity)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("BRAND WHITE"))
                .padding([.horizontal], 24)
                
            Text("Account")
                .font(.custom("SUIT-ExtraBold", size: 24))
                .foregroundStyle(Color("BRAND WHITE"))
            
            Button(action: {print("get out")},
               label: {
                Text("Logout")
                    .frame(maxWidth: .infinity)
                    .font(.custom("SUIT-ExtraBold", size: 20))
                    .padding([.vertical], 12)
                    .foregroundStyle(Color("BRAND WHITE"))
                    .background(Color("BRAND"))
                    .cornerRadius(12)
            }).padding([.horizontal], 24)
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .padding(.bottom, 64)
        .background(Color("BRAND BLACK"))
    }
}

#Preview {
    NavigationStack {
        UserView()
    }
}
