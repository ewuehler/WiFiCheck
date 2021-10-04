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
        HStack {
            Text(wifidata.ssidString())
            Spacer()
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
