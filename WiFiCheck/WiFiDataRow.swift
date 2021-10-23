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
        
        let stype = wifidata.securityType()
        switch stype {
        case .wpa3:
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.green)
        case .wpa2:
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(Color(NSColor.systemTeal))
        case .wpa:
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(Color(NSColor.systemTeal))
        case .wep:
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.yellow)
        case .open:
            Label {
                Text(wifidata.ssidString())
                    .font(.body)
                    .foregroundColor(.primary)
            } icon: {
                Image(systemName: "wifi").renderingMode(.template)
            }
            .accentColor(.red)
        case .unknown:
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
