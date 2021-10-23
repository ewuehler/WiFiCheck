//
//  WiFiData.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import Foundation
import SwiftUI

struct WiFiData: Hashable, Codable, Identifiable {

    var id: Self { self }
    
    var WiFiID: String = "InvalidID"
    var AddReason: String = ""
    var AddedAt: Date? = nil
    var CaptiveProfile: Array<CaptiveProfileData> = []
    
    var PasswordSharingDisabled: Bool = true //something new?
    var Hidden: Bool = false
    
    var JoinedBySystemAt: Date? = nil
    var JoinedByUserAt: Date? = nil
    
    var SSID: Data? = nil // Base64 Encoded SSID String
    var SupportedSecurityTypes: String = ""
    var WEPSubtype: String = ""
    var SystemMode: Bool = false
    var UpdatedAt: Date? = nil
    
//    var __OSSpecific__: Dictionary
    var BSSIDList: Array<BSSIDData> = []
    var ChannelHistory: Array<ChannelData> = []
    var CollocatedGroup: Array<CollocatedGroupData> = []
    var RoamingProfileType: String = ""
    var TemporarilyDisabled: Bool = false
    var UserPreferredOrderTimestamp: Date? = nil
    var WasHiddenBefore: Date? = nil
    
    enum SecurityType {
        case unknown, open, wep, wpa, wpa2, wpa3
    }

    struct CaptiveProfileData: Hashable, Codable, Identifiable {
        var id: Self { self }
        var CaptiveNetwork: Int = 0
        var CaptiveWebSheetLoginDate: Date? = nil
    }

    struct ChannelData: Hashable, Codable, Identifiable {
        var id: Self { self }
        var Channel: Int = -1
        var Timestamp: Date? = nil
        
        func joinedTime() -> String {
            return Utils.dateToString(Timestamp) ?? "Unknown"
        }
    }

    struct BSSIDData: Hashable, Codable, Identifiable {
        var id: Self { self }
        var LEAKY_AP_BSSID: String = ""
        var LEAKY_AP_LEARNED_DATA: Data = Data() // No clue what this means yet
        var Manufacturer: String = ""
        var normalizedMAC: String? = nil
        var normalizedOUI: String? = nil
        var SSID: String = ""
    }

    struct CollocatedGroupData: Hashable, Codable, Identifiable {
        var id: Self { self }
        var ssid: String = ""
    }


    func ssidString() -> String {
        if let ssid = self.SSID {
            return String(data: ssid, encoding: .utf8)!
        } else {
            return "Unknown"
        }
    }
    
    func securityType() -> SecurityType {
        if SupportedSecurityTypes.contains("WPA3") {
            return .wpa3
        } else if (SupportedSecurityTypes.contains("WPA2") && !SupportedSecurityTypes.contains("WPA3")) {
            return .wpa2
        } else if (SupportedSecurityTypes.contains("WPA")) {
            return .wpa
        } else if (SupportedSecurityTypes.contains("WEP")) {
            return .wep
        } else if (SupportedSecurityTypes.contains("Open")) {
            return .open
        } else {
            return .unknown
        }
    }
    
    func joinedByUserAt() -> String {
        return Utils.dateToString(JoinedByUserAt) ?? "Never from this Device"
    }
    
    func joinedBySystemAt() -> String {
        return Utils.dateToString(JoinedBySystemAt) ?? "Never from this Device"
    }
    
    func userPreferredOrderTimestamp() -> String {
        return Utils.dateToString(UserPreferredOrderTimestamp) ?? "Never from this Device"
    }
    
    func userPreferredOrder() -> Int64 {
        if AddedAt == nil {
            return 0
        } else {
            return AddedAt!.currentTimeMillis()
        }
    }
    
    func isCaptive() -> Bool {
        if CaptiveProfile.count == 0 {
            return false
        }
        let cpd: CaptiveProfileData? = CaptiveProfile[0]
        if cpd != nil {
            return !(cpd!.CaptiveNetwork == 0)
        }
        return false
    }
    
    func captiveLogin() -> String {
        if CaptiveProfile.count == 0 {
            return "No Login Date"
        }
        let cpd: CaptiveProfileData? = CaptiveProfile[0]
        if cpd != nil {
            return Utils.dateToString(cpd!.CaptiveWebSheetLoginDate) ?? "Unknown"
        }
        return "No Login Date"
    }
    
    func addedAt() -> String {
        return Utils.dateToString(AddedAt) ?? "Unknown"
    }
   

}
