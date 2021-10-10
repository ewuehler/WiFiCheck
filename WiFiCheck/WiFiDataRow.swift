//
//  WiFiDataRow.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import SwiftUI

struct WiFiDataRow: View {
   
    var wifidata: WiFiData
    
    var body: some View {
        if wifidata.SupportedSecurityTypes.contains("WPA3") {
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.green)
        } else if (wifidata.SupportedSecurityTypes.contains("WPA") && !wifidata.SupportedSecurityTypes.contains("WPA3")) {
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(Color(NSColor.systemTeal))
        } else if wifidata.SupportedSecurityTypes.contains("WEP") {
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.yellow)
        } else if wifidata.SupportedSecurityTypes.contains("Open") {
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.red)
        } else {
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.gray)
        }
    }
}

struct WiFiDataRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WiFiDataRow(wifidata: wifidatalist[0])
            WiFiDataRow(wifidata: wifidatalist[1])
            WiFiDataRow(wifidata: wifidatalist[2])
        }
        .previewLayout(.fixed(width:250, height: 70))
    }
}
