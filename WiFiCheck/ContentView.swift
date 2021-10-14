//
//  ContentView.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 9/10/21.
//

import SwiftUI

enum SortableMenu: String, CaseIterable, Identifiable {
    var id: String {
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
    @State private var selectedSort = SortableMenu.preferredOrder
    @State private var wifidataArray = wifidatalist
    var body: some View {
        VStack {
            Text("WiFi Networks").bold()
            Picker("Sort by: ", selection: $selectedSort) {
                ForEach(SortableMenu.allCases) { sm in
                    HStack() {
                        Image(systemName: sm.image)
                        Text(sm.title)
                    }.tag(sm)
                }
            }
            .onChange(of: selectedSort) { sm in
                if sm == .preferredOrder {
                    wifidataArray = sortByPreferredOrder(wifidatalist)
                } else if sm == .recent {
                    wifidataArray = sortByRecent(wifidatalist)
                } else {
                    // Alphabetical
                    wifidataArray = sortByAlphabetical(wifidatalist)
                }
            }
            List(wifidataArray) { wifidata in
                NavigationLink(destination: WiFiDataDetail(wifidata: wifidata)){
                    WiFiDataRow(wifidata: wifidata)
                }
            }
        }
        .pickerStyle(MenuPickerStyle())
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
