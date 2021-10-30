//
//  WiFiListView.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 9/10/21.
//

import SwiftUI

enum SortableMenu: String, CaseIterable, Identifiable {
    var id: String {
        return self.rawValue
    }
    
    case preferredOrder, recentUser, recentSystem, alphabetical
    
    var title: String {
        switch self {
        case .preferredOrder: return "Preferred"
        case .recentUser: return "Recent User"
        case .recentSystem: return "Recent System"
        case .alphabetical: return "Alphabetical"
        }
    }
    
    var image: String {
        switch self {
        case .preferredOrder: return "star.fill"
        case .recentUser: return "person.circle.fill"
        case .recentSystem: return "desktopcomputer"
        case .alphabetical: return "arrow.up.arrow.down.square.fill"
        }
    }
}



struct WiFiListView: View {
    var body: some View {
        NavigationView {
            WiFiListPane()
            WiFiDetailPane()
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

struct WiFiListPane: View {
    @State private var selectedSort = SortableMenu.preferredOrder
    @State private var wifidataArray = WiFiDataManager.shared.getWiFiDataList()
    @State private var sortString = "Preferred"
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Sort:").padding(.leading, 3).foregroundColor(.secondary)
                Picker("", selection: $selectedSort) {
                    ForEach(SortableMenu.allCases) { sm in
                        HStack() {
                            Image(systemName: sm.image).renderingMode(.template)
                            Text(sm.title)
                        }.tag(sm)
                    }
                }
                .onChange(of: selectedSort) { sm in
                    sortString = sm.title
                    if sm == .preferredOrder {
                        wifidataArray = WiFiDataManager.shared.sortByPreferredOrder()
                    } else if sm == .recentUser {
                        wifidataArray = WiFiDataManager.shared.sortByRecentUser()
                    } else if sm == .recentSystem {
                        wifidataArray = WiFiDataManager.shared.sortByRecentSystem()
                    } else {
                        // Alphabetical
                        wifidataArray = WiFiDataManager.shared.sortByAlphabetical()
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            Divider()
            List {
//                Section(header: Text("WiFi Networks: \(sortString)")) {
                    ForEach(wifidataArray) { wifidata in
                        NavigationLink(destination: WiFiDataDetail(wifidata: wifidata)){
                            WiFiDataRow(wifidata: wifidata)
                        }
                    }
//                }
            }.listStyle(SidebarListStyle())
        }
        Divider()
        VStack {
            Button(action:{
                
            }) {
                HStack {
                    Image(systemName: "trash")
                    Text("Delete WiFi")
                }
            }
            .buttonStyle(WiFiButtonStyle(delete: true))
        }
    }
}

struct WiFiDetailPane: View {
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: "arrow.left.circle.fill").font(.system(.title))
                Text("Select WiFi Network").font(.title)
            }
        }.frame(minWidth: 400)
        
    }
}


struct WiFiListView_Previews: PreviewProvider {
    static var previews: some View {
        WiFiListView()
    }
}
