//
//  WiFiData.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import Foundation
import SwiftUI

struct WiFiData: Hashable, Codable {

    var WiFiID: String = "InvalidID"
    var AddReason: String = ""
    var AddedAt: Date? = nil
    var CaptiveProfile: Array<CaptiveProfileData>? = nil
    
    var Hidden: Bool = false
    
    var JoinedBySystemAt: Date? = nil
    var JoinedByUserAt: Date? = nil
    
    var SSID: Data? = nil // Base64 Encoded SSID String
    var SupportedSecurityTypes: String = ""
    var WEPSubtype: String = ""
    var SystemMode: Bool = false
    var UpdatedAt: Date? = nil
    
//    var __OSSpecific__: Dictionary
    var BSSIDList: Array<BSSIDData>? = nil
    var ChannelHistory: Array<ChannelData>? = nil
    var CollocatedGroup: Array<CollocatedGroupData>? = nil
    var RoamingProfileType: String = ""
    var TemporarilyDisabled: Bool = false
    var UserPreferredOrderTimestamp: Date? = nil
    var WasHiddenBefore: Date? = nil
    
    struct CaptiveProfileData: Hashable, Codable {
        var CaptiveNetwork: Bool = false
        var CaptiveWebSheetLoginDate: Date? = nil
    }
    
    struct ChannelData: Hashable, Codable {
        var Channel: Int = -1
        var Timestamp: Date? = nil
    }
    
    struct BSSIDData: Hashable, Codable {
        var LEAKY_AP_BSSID: String = ""
        var LEAKY_AP_LEARNED_DATA: Data = Data() // No clue what this means yet
        var Manufacturer: String = ""
        var normalizedMAC: String? = nil
        var normalizedOUI: String? = nil
        var SSID: String = ""
    }
    
    struct CollocatedGroupData: Hashable, Codable {
        var id: String = ""
        var ssid: String = ""
    }
    
    func ssidString() -> String {
        if let ssid = self.SSID {
            return String(data: ssid, encoding: .utf8)!
        } else {
            return "Unknown"
        }
    }
    
    func joinedByUserAt() -> String {
        return dateToString(JoinedByUserAt) ?? "Never from this Device"
    }
    
    func joinedBySystemAt() -> String {
        return dateToString(JoinedBySystemAt) ?? "Never from this Device"
    }
    
    fileprivate func dateToString(_ d: Date?) -> String? {
        if d == nil {
            return nil
        }
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return df.string(from: d!)
    }



}

