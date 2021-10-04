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
            Text("Known Networks")
            List(0..<wifidatalist.count, id: \.self) { i in
                NavigationLink(destination: WiFiDataDetail(wifidata: wifidatalist[i])) {                WiFiDataRow(wifidata: wifidatalist[i])
                }            }
            .listStyle(SidebarListStyle())
            Spacer()
        }
        .frame(minWidth: 100, idealWidth: 250, maxWidth: 350, minHeight: 400, idealHeight: .infinity, maxHeight: .infinity)
    }
}

struct DetailPane: View {
    var body: some View {
        WiFiDataDetail(wifidata: wifidatalist[0])
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
