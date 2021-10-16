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
                VStack(alignment: .leading) {
                    Text("Security: "+wifidata.SupportedSecurityTypes).font(.title2)
                    Text("Roaming Profile Type: "+wifidata.RoamingProfileType)
                    Text("User Preferred Order: \(wifidata.userPreferredOrderTimestamp())")
                }
                VStack(alignment: .leading) {
                    let captiveStr: String = (wifidata.isCaptive() == true) ? "Yes":"No"
                    Text("Is Captive: "+captiveStr)
                    if (wifidata.isCaptive()) {
                        Text("Captive Login Date: "+wifidata.captiveLogin())
                    }
                    Text("Hidden: "+String(wifidata.Hidden))
                    Text("System Mode: "+String(wifidata.SystemMode))
                    Text("Disabled: "+String(wifidata.TemporarilyDisabled))
                }
                Divider()
                CollocatedGroupView(collocatedGroup: wifidata.CollocatedGroup)

            }
            .padding()
            
            Spacer()
        }
    }
}

struct CollocatedGroupView: View {
    var collocatedGroup: Array<WiFiData.CollocatedGroupData> = []
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Collocated Group").bold()
//            for cgd in collocatedGroup {
//                Text("Channel: \(String(cgd.Channel))")
//            }
        }
    }
}

struct WiFiDataDetail_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDataDetail(wifidata: wifidatalist[0])
    }
}
