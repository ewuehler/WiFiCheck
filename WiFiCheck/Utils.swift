//
//  Utils.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/14/21.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
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
}
