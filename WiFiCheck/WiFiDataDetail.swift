//
//  WiFiDataDetail.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import SwiftUI

struct WiFiDataDetail: View {
    var wifidata: WiFiData
    
    var circleSize: CGFloat = 26.0
    var circleColor: Color = Color(white:0.4, opacity: 0.2)

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                HStack() {
                    Text("Network:").font(.title).foregroundColor(.secondary)
                    Label {
                        Text(wifidata.ssidString())
                            .font(.title)
                            .foregroundColor(.primary)
                    } icon: {
                        Image(systemName: "wifi").renderingMode(.template).foregroundColor(Utils.getSecurityColor(wifidata))
                            .font(.system(.title))
                    }
                    .help(wifidata.SupportedSecurityTypes)
                }
                Spacer()
                Spacer()
                HStack {
                    VStack(alignment: .center) {
                        Text("Last Joined").font(.system(size: 18))
                        
                        HStack {
                            VStack{
                                WiFiDateBox(date: wifidata.JoinedByUserAt, color: Utils.getDateBoxColor(wifidata, wifidata.JoinedByUserAt))
                                Text("By User").foregroundColor(.gray)
                            }
                            VStack {
                                WiFiDateBox(date: wifidata.JoinedBySystemAt, color: Utils.getDateBoxColor(wifidata, wifidata.JoinedBySystemAt))
                                Text("By System").foregroundColor(.gray)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Added by: "+wifidata.AddReason)
                        Text("Added at: "+wifidata.addedAtString())
                    }
                }
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
                if (wifidata.CollocatedGroup.count > 0) {
                    Divider()
                    CollocatedGroupView(collocatedGroups: wifidata.CollocatedGroup)
                }
                if (wifidata.ChannelHistory.count > 0) {
                    Divider()
                    ChannelHistoryView(channelData: wifidata.ChannelHistory)
                }
                if (wifidata.BSSIDList.count > 0) {
                    Divider()
                    BSSIDListView(bssidData: wifidata.BSSIDList)
                }
            }
            .padding()
            
            Spacer()
        }
    }
}


struct CollocatedGroupView: View {
    var collocatedGroups: [WiFiData.CollocatedGroupData]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Collocated Group").bold()
        }
        ForEach(collocatedGroups) { cgd in
            Text("\(String(cgd.ssid))")
        }
    }
}

struct ChannelHistoryView: View {
    var channelData: [WiFiData.ChannelData]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Channel History").bold()
            ForEach(channelData) { cd in
                HStack() {
                    Text("\(cd.Channel)")
                    Text("\(cd.joinedTime())")
                }
            }
        }
    }
}

struct BSSIDListView: View {
    var bssidData: [WiFiData.BSSIDData]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("BSSID").bold()
            ForEach(bssidData) { b in
                Text("\(b.LEAKY_AP_BSSID)")
            }
        }
    }
}

struct WiFiDataDetail_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDataDetail(wifidata: wifidatalist[0])
    }
}
