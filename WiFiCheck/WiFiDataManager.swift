//
//  WiFiDataManager.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/3/21.
//

import Foundation


fileprivate let systemConfigurationFolder: String = "/Library/Preferences"
fileprivate let wifiKnownNetworksFile: String = "com.apple.wifi.known-networks.plist"
//fileprivate let ncprefs: String = "/Users/ewuehler/Library/Preferences/com.apple.ncprefs.plist"
fileprivate let airportCommand: String = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"


var wifidatalist: Array<WiFiData> = sortByPreferredOrder(load(systemConfigurationFolder+"/"+wifiKnownNetworksFile))

// Known PLIST Keys

let AddReason = "AddReason"
let AddedAt = "AddedAt"

let CaptiveProfile = "CaptiveProfile"
let CaptiveNetwork = "CaptiveNetwork"
let CaptiveWebSheetLoginDate = "CaptiveWebSheetLoginDate"
let Hidden = "Hidden"

let JoinedBySystemAt = "JoinedBySystemAt"
let JoinedByUserAt = "JoinedByUserAt"

let SSID = "SSID"
let SupportedSecurityTypes = "SupportedSecurityTypes"
let WEPSubtype = "WEPSubtype"
let SystemMode = "SystemMode"
let UpdatedAt = "UpdatedAt"

let __OSSpecific__ = "__OSSpecific__"
let BSSIDList = "BSSIDList"
let LEAKY_AP_BSSID = "LEAKY_AP_BSSID"
let LEAKY_AP_LEARNED_DATA = "LEAKY_AP_LEARNED_DATA"

let ChannelHistory = "ChannelHistory"
let Channel = "Channel"
let Timestamp = "Timestamp"

let CollocatedGroup = "CollocatedGroup"

let RoamingProfileType = "RoamingProfileType"
let TemporarilyDisabled = "TemporarilyDisabled"
let UserPreferredOrderTimestamp = "UserPreferredOrderTimestamp"
let WasHiddenBefore = "WasHiddenBefore"


fileprivate func findBool(_ value: AnyObject?) -> Bool {
    if value == nil {
        return false
    } else {
        return value as! Bool
    }
}

fileprivate func findInt(_ value: AnyObject?) -> Int {
    if value == nil {
        return -1
    } else {
        return value as! Int
    }
}

fileprivate func findString(_ value: AnyObject?) -> String {
    if value == nil {
        return ""
    } else {
        return value as! String
    }
}

fileprivate func findDate(_ value: AnyObject?) -> Date? {
    if value == nil {
        return nil
    } else {
        return (value as! Date)
    }
}

fileprivate func findData(_ value: AnyObject?) -> Data? {
    if value == nil {
        return nil
    } else {
        return (value as! Data)
    }
}


fileprivate func findCaptiveProfile(_ value: AnyObject?) -> Array<WiFiData.CaptiveProfileData> {
    var cpList = Array<WiFiData.CaptiveProfileData>()
    if (value == nil) {
        return cpList
    } else {
        let dict: Dictionary = value as! Dictionary<String,AnyObject>
        var cp = WiFiData.CaptiveProfileData()
        cp.CaptiveNetwork = findInt(dict[CaptiveNetwork])
        cp.CaptiveWebSheetLoginDate = findDate(dict[CaptiveWebSheetLoginDate]) ?? nil
        cpList.append(cp)
    }
    return cpList
}

fileprivate func findBSSIDList(_ value: AnyObject?) -> Array<WiFiData.BSSIDData> {
    var bssidList = Array<WiFiData.BSSIDData>()
    if (value == nil) {
        return bssidList
    } else {
        let arr: Array = value as! Array<Dictionary<String,AnyObject>>
        for dict in arr {
            var bssid = WiFiData.BSSIDData()
            bssid.LEAKY_AP_BSSID = findString(dict[LEAKY_AP_BSSID])
            bssid.LEAKY_AP_LEARNED_DATA = findData(dict[LEAKY_AP_LEARNED_DATA])!
            // Now find the Manufacturer
            bssid.Manufacturer = "" //TODO: self.macAddress.orgName(by: bssid.mac()) ?? ""
            bssidList.append(bssid)
        }
    }
    return bssidList
}

fileprivate func findChannelHistory(_ value: AnyObject?) -> Array<WiFiData.ChannelData> {
    
    var channelHistory = Array<WiFiData.ChannelData>()
    if value == nil {
        return channelHistory
    } else {
        let arr: Array = value as! Array<Dictionary<String,AnyObject>>
        for dict in arr {
            var chan = WiFiData.ChannelData()
            chan.Channel = findInt(dict[Channel])
            chan.Timestamp = findDate(dict[Timestamp])
            
            channelHistory.append(chan)
        }
    }
    return channelHistory
    
}

fileprivate func findCollocatedGroup(_ value: AnyObject?) -> Array<WiFiData.CollocatedGroupData> {
    var collocatedGroup = Array<WiFiData.CollocatedGroupData>()
    if (value == nil) {
        return collocatedGroup
    } else {
        let arr: Array = value as! Array<String>
        for str in arr {
            var cg = WiFiData.CollocatedGroupData()
            cg.ssid = parseWiFiSSID(str)
            collocatedGroup.append(cg)
        }
    }
    
    return collocatedGroup
}

// Convert the airport plist id to an SSID
func parseWiFiSSID(_ appleWiFiID: String) -> String {
    // Parse the Apple Plist Key into the SSID
    if (appleWiFiID.hasPrefix("wifi.ssid.")) {
        let index = appleWiFiID.index(appleWiFiID.startIndex, offsetBy: 10)
        let preSSID = String(appleWiFiID[index...])
        // preSSID now should look like <65776545 88776655>
        // This is now raw ascii that we'll need to convert to a string
        var parsedSSID = ""
        var intSSID = ""
        var count = 0
        for ch in preSSID {
            count = count + 1
            if (ch == "<") {
                // Starting char
                count = 0
            } else if (ch == " ") {
                // Skip
                count = 0
            } else if (ch == ">") {
                // Last char
                count = 0
            } else {
                if count == 1 {
                    intSSID = "\(ch)"
                } else if count == 2 {
                    intSSID = "\(intSSID)\(ch)"
                    count = 0
                    let asciiToChar = Character(UnicodeScalar(Int(intSSID, radix:16)!)!)
                    parsedSSID = "\(parsedSSID)\(asciiToChar)"
                }
            }
        }
        return parsedSSID
    }
    return appleWiFiID
}


//class WiFiIdentifier: Equatable {
//    let wifiKey: String
//    static func == (lhs: WiFiIdentifier, rhs: WiFiIdentifier) -> Bool { lhs.wifiKey == rhs.wifiKey }
//    init(_ wifiKey: String) { self.wifiKey = wifiKey }
//}


func sortByPreferredOrder(_ items: [WiFiData]) -> [WiFiData] {
    items.sorted { a, b in
        return a.PreferredOrder < b.PreferredOrder
    }
}

func sortByRecent(_ items: [WiFiData]) -> [WiFiData] {
    items.sorted { a, b in
        if a.joinedByUserAt() == b.joinedByUserAt() {
            if a.joinedBySystemAt() == b.joinedBySystemAt() {
                if a.addedAt() == b.addedAt() {
                    return a.ssidString() < b.ssidString()
                } else {
                    return a.addedAt().moreRecentThan(b.addedAt())
                }
            } else {
                return a.joinedBySystemAt().moreRecentThan(b.joinedBySystemAt())
            }
        } else {
            return a.joinedByUserAt().moreRecentThan(b.joinedByUserAt())
        }
    }
}

func sortByAlphabetical(_ items: [WiFiData]) -> [WiFiData] {
    items.sorted { a, b in
        var res = false
        res = a.ssidString() < b.ssidString()
        return res
    }
}


// Load data
func load(_ filename: String) -> Array<WiFiData> {
    
//    let _ncfileurl = URL(fileURLWithPath: "/Users/ewuehler/Library/Preferences/ByHost/com.apple.Bluetooth.8BF40F52-1077-56B7-B9C3-5DD4F4703A23.plist")
//    let _ncdata = try! Data(contentsOf: _ncfileurl)
//    let _ncprefs = try! PropertyListSerialization.propertyList(from: _ncdata, options: .mutableContainersAndLeaves, format: nil)
//    print("\(_ncprefs)")
    
//    print("filename: \(filename)")
//    print("exists: \(FileManager.default.fileExists(atPath: filename))")
    let _fileurl = URL(fileURLWithPath: filename)
    let _data = try! Data(contentsOf: _fileurl)
    let _rawContent = try! PropertyListSerialization.propertyList(from: _data, options: .mutableContainersAndLeaves, format: nil)
//    let _rawContent = NSDictionary(contentsOfFile: filename)
//    print("\(_rawContent)")
    
    let preferredNetworks: Dictionary<String,Int> = Utils.getPreferredNetworkOrder()

    var _knownNetworks: Array<WiFiData> = []
    let knownNetworks: Dictionary = (_rawContent as? Dictionary<String,AnyObject>)!
//    var count: Int = 0
    for (wifiKey, valueDict) in knownNetworks {
//        print("key: \(wifiKey)")
//        print("value: \(valueDict)")
        let value = valueDict as! Dictionary<String,AnyObject>
        var wifidata = WiFiData()
        wifidata.WiFiID = wifiKey
        wifidata.AddReason = findString(value[AddReason])
        wifidata.AddedAt = findDate(value[AddedAt])
        wifidata.CaptiveProfile = findCaptiveProfile(value[CaptiveProfile])
        wifidata.Hidden = findBool(value[Hidden])
        wifidata.JoinedBySystemAt = findDate(value[JoinedBySystemAt])
        wifidata.JoinedByUserAt = findDate(value[JoinedByUserAt])
        wifidata.SSID = findData(value[SSID])!
        wifidata.SupportedSecurityTypes = findString(value[SupportedSecurityTypes])
        wifidata.WEPSubtype = findString(value[WEPSubtype])
        wifidata.SystemMode = findBool(value[SystemMode])
        wifidata.UpdatedAt = findDate(value[UpdatedAt])
        
        let osvalue = value[__OSSpecific__] as! Dictionary<String,AnyObject>
        wifidata.BSSIDList = findBSSIDList(osvalue[BSSIDList])
        wifidata.ChannelHistory = findChannelHistory(osvalue[ChannelHistory])
        wifidata.CollocatedGroup = findCollocatedGroup(osvalue[CollocatedGroup])
        wifidata.RoamingProfileType = findString(osvalue[RoamingProfileType])
        wifidata.TemporarilyDisabled = findBool(osvalue[TemporarilyDisabled])
        wifidata.UserPreferredOrderTimestamp = findDate(osvalue[UserPreferredOrderTimestamp])
        wifidata.WasHiddenBefore = findDate(osvalue[WasHiddenBefore])
      
        // Set preferred order?
        wifidata.PreferredOrder = preferredNetworks[wifidata.ssidString()] ?? -1
        
        _knownNetworks.append(wifidata)
    }
    return _knownNetworks
}


func dumpPList(_ filename: String) -> Bool {
    let _fileurl = URL(fileURLWithPath: filename)
    let _data = try! Data(contentsOf: _fileurl)
    let _rawContent = try! PropertyListSerialization.propertyList(from: _data, options: .mutableContainersAndLeaves, format: nil)
    print("\(_rawContent)")
    return true
}

