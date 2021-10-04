//
//  WiFiDataDetail.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import SwiftUI

struct WiFiDataDetail: View {
    var wifidata: WiFiData
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(wifidata.ssidString())
                    .font(.title)
                    .foregroundColor(.primary)
                HStack {
                    Text("Added by: "+wifidata.AddReason)
                    Spacer()
                    Text("alskjf")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                Text("about").font(.title2)
                Text("description")
            }
            .padding()
            
            Spacer()
        }
    }
}


struct WiFiDataDetail_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDataDetail(wifidata: wifidatalist[0])
    }
}
