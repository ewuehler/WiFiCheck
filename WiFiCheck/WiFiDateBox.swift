//
//  WiFiDateBox.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/22/21.
//

import SwiftUI


struct WiFiDateBox: View {
    var date: Date?
    var color: Color = Color.gray
    var frameSize: CGFloat = 80.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if date == nil {
                Text("NEVER").foregroundColor(Color.gray)
            } else {
                HStack(alignment: .center, spacing: 0){
                    Text(Utils.getDayString(date)).bold()
                    Text(Utils.getMonthShort(date).uppercased())
                }.font(.system(size: 18))
                Text(String(Utils.getYear(date))).bold().font(.system(size: 24))
                Text(String(Utils.getTime(date))).font(.system(size: 14))
            }
        }
        .padding(3)
        .frame(minWidth: frameSize, idealWidth: frameSize, maxWidth: frameSize, minHeight: frameSize, idealHeight: frameSize, maxHeight: frameSize, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10).stroke(color, lineWidth: 1)
        )
    }
}

struct WiFiDateBox_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiFiDateBox(date: Date())
            WiFiDateBox(date: Date())
            WiFiDateBox(date: nil)
        }
    }
}
