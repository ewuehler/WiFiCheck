//
//  Utils.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/14/21.
//

import Foundation
import Dispatch
import SwiftUI

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
    
    func moreRecentThan(_ date: Date) -> Bool {
        return self > date
    }
}

class Utils {
    static func dateToString(_ d: Date?) -> String? {
        if d == nil {
            return nil
        }
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return df.string(from: d!)
    }
    
    static func getTime(_ d: Date?) -> String {
        if d == nil {
            return ""
        }
        let df: DateFormatter = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        
        return df.string(from: d!)
    }
    
    static func getDay(_ d: Date?) -> Int {
        if d == nil {
            return 0
        }
        let cal = Calendar.current
        return cal.component(.day, from: d!)
    }
    
    static func getMonthShort(_ d: Date?) -> String {
        if d == nil {
            return "???"
        }
        let df = DateFormatter()
        df.dateFormat = "MMM"
        return df.string(from: d!)
    }
    
    static func getDayString(_ d: Date?) -> String {
        let day = getDay(d)
        var dayStr = ""
        if day == 0 {
            dayStr = "??"
        }
        
        if (day < 10) {
            dayStr = "0\(day)"
        } else {
            dayStr = "\(day)"
        }
        
        return dayStr
    }
    
    static func getYear(_ d: Date?) -> Int {
        if d == nil {
            return 0
        }
        let cal = Calendar.current
        return cal.component(.year, from: d!)
    }
    
    static func getSecurityColor(_ wifidata: WiFiData) -> Color {
        let stype = wifidata.securityType()
        var securityColor: Color = Color.gray
        switch stype {
        case .wpa3:
            securityColor = Color.green
        case .wpa2:
            securityColor = Color(NSColor.systemTeal)
        case .wpa:
            securityColor = Color(NSColor.systemTeal)
        case .wep:
            securityColor = Color.yellow
        case .open:
            securityColor = Color.red
        case .unknown:
            securityColor = Color.gray
        }
        return securityColor
    }
    
    static func getDateBoxColor(_ wifidata: WiFiData, _ d: Date?) -> Color {
        if d == nil {
            return Color.gray
        } else {
            return getSecurityColor(wifidata)
        }
    }
    
    
    static func getPreferredNetworkOrder() -> Dictionary<String,Int> {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/networksetup")
        task.arguments = ["-listpreferredwirelessnetworks", "en0"]
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        
        do {
            try task.run()
        } catch {
            return Dictionary<String,Int>()
        }
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = String(decoding: outputData, as: UTF8.self)
        let error = String(decoding: errorData, as: UTF8.self)
        
        print("Output: \(output)")
        print("Error: \(error)")

        var prefWiFi: Dictionary<String,Int> = [:]
        
        if output.isEmpty {
            print("Unable to find preferred networks") // need to throw an exception here
        } else {
            let networks = output.components(separatedBy: .newlines).dropFirst()
            var i = 100
            for network in networks {
                let n = network.trimmingCharacters(in: .whitespacesAndNewlines)
                prefWiFi[n] = i
                i = i+100
            }
        }
        
        return prefWiFi
    }
    
}
