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
            DetailPane()
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                }).padding(0)
            }
        }
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}

struct ListPane: View {
    @State private var selectedSort = SortableMenu.preferredOrder
    @State private var wifidataArray = wifidatalist
    @State private var sortString = "Preferred"
    var body: some View {
        VStack {
            List {
                Section(header: Text("WiFi Networks: \(sortString)")) {
                    ForEach(wifidataArray) { wifidata in
                        NavigationLink(destination: WiFiDataDetail(wifidata: wifidata)){
                            WiFiDataRow(wifidata: wifidata)
                        }
                    }
                }
            }
            Picker("Sort by: ", selection: $selectedSort) {
                ForEach(SortableMenu.allCases) { sm in
                    HStack() {
                        Image(systemName: sm.image)
                        Text(sm.title)
                    }.tag(sm)
                }
            }
            .onChange(of: selectedSort) { sm in
                sortString = sm.title
                if sm == .preferredOrder {
                    wifidataArray = sortByPreferredOrder(wifidatalist)
                } else if sm == .recent {
                    wifidataArray = sortByRecent(wifidatalist)
                } else {
                    // Alphabetical
                    wifidataArray = sortByAlphabetical(wifidatalist)
                }
            }
            Spacer()
        }
        .pickerStyle(MenuPickerStyle())
    }
}

struct DetailPane: View {
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: "arrow.left.circle.fill").font(.system(.title))
                Text("Select WiFi Network").font(.title)
            }
        }.frame(minWidth: 400)
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
