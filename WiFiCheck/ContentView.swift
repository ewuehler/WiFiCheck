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
            Text("Select WiFi Network")
//            VStack {
//                Text("Known WiFi Networks").frame(maxWidth: .infinity, alignment: .leading)
//                List(wifidatalist) { wifidata in
//                    NavigationLink(destination: WiFiDataDetail(wifidata: wifidata)) {
//                        WiFiDataRow(wifidata: wifidata)
//                    }
//                }
//                .listStyle(SidebarListStyle())
//            }
        }
    }
}

struct ListPane: View {
    var body: some View {
        VStack {
            Text("WiFi Networks").bold()
            List(wifidatalist) { wifidata in
                NavigationLink(destination: WiFiDataDetail(wifidata: wifidata)){
                    WiFiDataRow(wifidata: wifidata)
                }
            }
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

enum SortableMenu: Int, CaseIterable, Identifiable {
    var id: Int {
        return self.rawValue
    }
    
    case preferredOrder, recent, alphabetical
    
    var title: String {
        switch self {
        case .preferredOrder: return "Preferred"
        case .recent: return "Recent"
        case .alphabetical: return "Alphabetical"
        }
    }
    
    var image: String {
        switch self {
        case .preferredOrder: return "star.fill"
        case .recent: return "clock.fill"
        case .alphabetical: return "square.stack.fill"
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
