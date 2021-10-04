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
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Joined by User at: ")
                            Text(wifidata.joinedByUserAt())
                        }
                        HStack {
                            Text("Joined by System at:")
                            Text(wifidata.joinedBySystemAt())
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Added by: "+wifidata.AddReason)
                        Text("Added at: "+wifidata.addedAt())
                    }
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Divider()
                Text(wifidata.SupportedSecurityTypes).font(.title2)
                Text(wifidata.RoamingProfileType)
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
