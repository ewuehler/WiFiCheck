//
//  ContentView.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 9/10/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ListPane()
            DetailPane()
        }
    }
}

struct ListPane: View {
    var body: some View {
        VStack {
            Text("Items")
            List(0..<wifidatalist.count, id: \.self) { i in
                WiFiDataRow(wifidata: wifidatalist[i])
            }
            .listStyle(SidebarListStyle())
            Spacer()
        }
        .frame(minWidth: 100, idealWidth: 250, maxWidth: 350, minHeight: 400, idealHeight: .infinity, maxHeight: .infinity)
    }
}

struct DetailPane: View {
    var body: some View {
        Text("Details").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
