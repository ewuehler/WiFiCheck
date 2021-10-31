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
    @State private var wifidataArray = Array<WiFiData>()
    @State private var sortString = "Preferred"
    @State private var listSelection: WiFiData? = nil
    @State private var showingAlert = false
    @State private var reloadView = false
    
    func loadWiFiData() {
        wifidataArray = WiFiDataManager.shared.getWiFiDataList()
    }
    
    var body: some View {
        if wifidataArray.count == 0 && WiFiDataManager.shared.needsPassword() {
            VStack {
                Text("Apple has changed the default access in newer versions of macOS to the WiFi Known Networks file.  As such, you need to enter your password to be able to view this file.  Any modifications to the Known Networks file will reset file access and you'll need to enter the password again.").padding()
                Button(action:{
                    WiFiDataManager.shared.reloadData()
                    loadWiFiData()
                    reloadView.toggle()
                }) {
                    HStack {
                        Image(systemName: "lock.rotation.open")
                        Text("Open File")
                    }
                }
                .buttonStyle(WiFiButtonStyle())
            }
        } else {
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
                List(selection: $listSelection) {
    //                Section(header: Text("WiFi Networks: \(sortString)")) {
                        ForEach(wifidataArray) { wifidata in
                            NavigationLink(destination: WiFiDataDetail(wifidata: wifidata)){
                                WiFiDataRow(wifidata: wifidata)
                            }
                        }
    //                }
                }
                .listStyle(SidebarListStyle())
            }.onAppear {
                loadWiFiData()
            }
            Divider()
            VStack {
                Button(action:{
                    showingAlert = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Remove WiFi")
                    }
                }
                .disabled(listSelection == nil)
                .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Are you sure you want to remove \"\(listSelection!.ssidString())\"?"),
                        message: Text("This will remove \"\(listSelection!.ssidString())\" from your list of known WiFi Networks.  You can always rejoin this WiFi Network in the future."),
                        primaryButton: .destructive(Text("Delete")) {
                            _ = NetworkSetup.shared.deleteNetwork(listSelection!.ssidString())
                            let idx = wifidataArray.firstIndex(of: listSelection!)
                            if idx != nil {
                                wifidataArray.remove(at: idx!)
                                listSelection = nil
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                .buttonStyle(WiFiButtonStyle(delete: true, disabled: (listSelection == nil)))
            }
            Spacer()
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
