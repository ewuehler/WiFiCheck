//
//  WiFiDataList.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import SwiftUI

struct WiFiDataList: View {
    var body: some View {
        List(wifidatalist) { wifidata in
            WiFiDataRow(wifidata: wifidata)
        }
    }
}

struct WiFiDataList_Previews: PreviewProvider {
    static var previews: some View {
        WiFiDataList()
    }
}
