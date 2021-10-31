//
//  WiFiDataDetail.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import SwiftUI


struct WiFiDataDetail: View {
    var wifidata: WiFiData = WiFiDataManager.shared.getWiFiDataList().first ?? WiFiData()
    
    var circleSize: CGFloat = 26.0
    var circleColor: Color = Color(white:0.4, opacity: 0.2)

    @State private var showPassword = false
    @State private var pwdShown = false
    @State private var pwdText = "Show Password"
    @State private var pwdIcon = "lock"
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack() {
                            Label {
                                Text(wifidata.ssidString())
                                    .font(.title)
                                    .foregroundColor(.primary)
                            } icon: {
                                Image(systemName: "wifi").renderingMode(.template).foregroundColor(Utils.getSecurityColor(wifidata))
                                    .font(.title)
                            }
                        }
                        Spacer()
                        VStack(alignment: .leading) {
                            Label {
                                Text(wifidata.getSecurityName())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } icon: {
                                Image(systemName: "lock")
                                    .renderingMode(.template)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                            Label {
                                Text(wifidata.hiddenStateText())
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } icon: {
                                Image(systemName: wifidata.hiddenStateImage())
                                    .renderingMode(.template)
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        VStack(alignment: .trailing) {
                            if (showPassword) {
                                let (res, pwd) = KeychainAccess.getWiFiPassword(forNetwork: wifidata.ssidString())
                                if res {
                                    Text("\(pwd)").font(.system(.title, design: .monospaced))
                                } else {
                                    Text("**********").font(.system(.title, design: .monospaced))
                                }
                            } else {
                                Text("**********").font(.system(.title, design: .monospaced))
                            }
                            Button(action:{
                                showPassword.toggle()
                                if (showPassword) {
                                    self.pwdText = "Hide Password"
                                    self.pwdIcon = "lock.slash"
                                } else {
                                    self.pwdText = "Show Password"
                                    self.pwdIcon = "lock"
                                }
                            }) {
                                HStack {
                                    Image(systemName: pwdIcon)
                                    Text(pwdText)
                                }//.padding(EdgeInsets(top:2, leading: 10, bottom: 2, trailing: 10))
                            }
                            .buttonStyle(WiFiButtonStyle(disabled: (wifidata.securityType() == .open)))
                        }
                    }
                }
                Spacer()
                Divider()
                Spacer()
                HStack {
                    VStack(alignment: .center) {
                        Text("Last Joined from this Mac").font(.headline)
                        HStack {
                            VStack{
                                WiFiDateBox(date: wifidata.JoinedBySystemAt, color: Utils.getDateBoxColor(wifidata, wifidata.JoinedBySystemAt))
                                Text("Automatically").foregroundColor(.secondary)
                            }
                            VStack {
                                WiFiDateBox(date: wifidata.JoinedByUserAt, color: Utils.getDateBoxColor(wifidata, wifidata.JoinedByUserAt))
                                Text("Manually").foregroundColor(.secondary)
                            }
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        VStack(alignment: .center) {
                            Text("Added On").font(.headline)
//                            VStack(alignment: .trailing) {
                                WiFiDateBox(date: wifidata.AddedAt, color: Utils.getDateBoxColor(wifidata, wifidata.AddedAt))
//                            }
                            Text("\(wifidata.AddReason)").foregroundColor(.secondary)
                        }
                    }
                }
                Divider()
                HStack {
//                    VStack(alignment: .leading) {
//                        Text("Roaming Profile Type: "+wifidata.RoamingProfileType)
//                        Text("User Preferred Order: \(wifidata.userPreferredOrderTimestamp())")
//                    }
                    VStack(alignment: .leading) {
//                        Text("Details").bold()
//                        let captiveStr: String = (wifidata.isCaptive() == true) ? "Yes":"No"
//                        Text("Is Captive: "+captiveStr)
                        if (wifidata.isCaptive()) {
                            Text("Captive Portal Last Login").bold()
                            Text(wifidata.captiveLogin())
                                .bold()
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .padding(0)
                                .frame(width: 200, height: 26, alignment: .center)
                                .background(Color(NSColor.systemBrown))
                                .clipShape(Capsule())
                        }
//                        Text("Hidden: "+String(wifidata.Hidden))
//                        Text("System Mode: "+String(wifidata.SystemMode))
//                        Text("Disabled: "+String(wifidata.TemporarilyDisabled))
                        if (wifidata.CollocatedGroup.count > 0) {
                            Divider()
                            CollocatedGroupView(collocatedGroups: wifidata.CollocatedGroup)
                        }
                        if (wifidata.BSSIDList.count > 0) {
                            Divider()
                            BSSIDListView(bssidData: wifidata.BSSIDList)
                        }
                    }
                    Spacer()
                    if (wifidata.ChannelHistory.count > 0) {
                        Divider()
                    }
                    VStack(alignment: .trailing) {
                        if (wifidata.ChannelHistory.count > 0) {
                            ChannelHistoryView(channelData: wifidata.ChannelHistory)
                        }
                    }
                }
            }
            .padding()
            Spacer()
            VStack(alignment: .leading) {
                Text("ciretose")
            }
        }
    }
}


struct CollocatedGroupView: View {
    var collocatedGroups: [WiFiData.CollocatedGroupData]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Networks At Same Location").bold()
            ForEach(collocatedGroups) { cgd in
                Text("\(String(cgd.ssid))")
            }
        }
    }
}

struct ChannelHistoryView: View {
    var channelData: [WiFiData.ChannelData]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Channel History").bold()
            Spacer()
            ForEach(channelData) { cd in
                HStack() {
                    Text("\(cd.Channel)")
                        .bold()
                        .foregroundColor(.white)
                        .padding(0)
                        .frame(width: 40, height: 26, alignment: .center)
                        .background(Color.black)
                        .clipShape(Capsule())
                    Text("\(cd.joinedTime())")
                        .bold()
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(0)
                        .frame(width: 200, height: 26, alignment: .center)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .help(Text("\(cd.joinedTime(false))"))
                }
                Spacer()
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
        WiFiDataDetail(wifidata: WiFiDataManager.shared.getWiFiDataList().first ?? WiFiData())
    }
}
