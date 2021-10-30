//
//  KeychainAccess.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 10/29/21.
//

import Foundation


class KeychainAccess {
    
    enum KeychainError: Error {
        // Attempted read for an item that does not exist.
        case itemNotFound
        
        // Attempted save to override an existing item.
        // Use update instead of save to update existing items
        case duplicateItem
        
        // A read of an item in any format other than Data
        case invalidItemFormat
        
        // Any operation result status than errSecSuccess
        case unexpectedStatus(OSStatus)
    }

    static func save(password: Data, service: String, account: String) throws {

        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to save in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            // kSecValueData is the item value to save
            kSecValueData as String: password as AnyObject
        ]
        
        // SecItemAdd attempts to add the item identified by
        // the query to keychain
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )

        // errSecDuplicateItem is a special case where the
        // item identified by the query already exists. Throw
        // duplicateItem so the client can determine whether
        // or not to handle this as an error
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        // Any status other than errSecSuccess indicates the
        // save operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
//    static func findPassword(_ name: String) throws -> String {
//
//           // clean up anything lingering
//        var myErr: OSStatus
//        var serviceName: String = name
//        var passPtr: UnsafeMutableRawPointer?
//        var passLength:UInt32 = 0
//        var myKeychainItem: SecKeychainItem?
//
//           myErr = SecKeychainFindGenericPassword(nil, UInt32(serviceName.count), serviceName, UInt32(name.count), name, &passLength, &passPtr, &myKeychainItem)
//
//           if myErr == OSStatus(errSecSuccess) {
//               let password = NSString(bytes: passPtr!, length: Int(passLength), encoding: String.Encoding.utf8.rawValue)
//               return password! as String
//           } else {
//               // now check for all lowercase password just in case
//
//               if name == name.lowercased() {
//                   // already lowercase, no need to check again
//
//                   throw KeychainError.itemNotFound
//               }
//
//               myErr = SecKeychainFindGenericPassword(nil, UInt32(serviceName.count), serviceName, UInt32(name.lowercased().count), name.lowercased(), &passLength, &passPtr, &myKeychainItem)
//
//               if myErr == OSStatus(errSecSuccess) {
//                   let password = NSString(bytes: passPtr!, length: Int(passLength), encoding: String.Encoding.utf8.rawValue)
//                   return password! as String
//               } else {
//
//                   // now to look for /anything/ that might match
//
//                   var searchReturn: AnyObject? = nil
//
//                   let attrs = [
//                       kSecClass : kSecClassGenericPassword,
//                       kSecAttrService : serviceName,
//                       kSecReturnRef : true,
//                       kSecReturnAttributes : true,
//                       kSecMatchLimit : kSecMatchLimitAll,
//                       ] as [CFString : Any]
//
//                   myErr = SecItemCopyMatching(attrs as CFDictionary, &searchReturn)
//
//                   if myErr != 0 || searchReturn == nil {
//                       // no results throw
//                       throw KeychainError.itemNotFound
//                   }
//
//                   let returnDict = searchReturn as! CFArray as Array
//                   for item in returnDict {
//                       if ((item["acct"] as? String ?? "").lowercased() == name.lowercased()) {
//                           // got a match now let's lookup the password
//
//                           myErr = SecKeychainFindGenericPassword(nil, UInt32(serviceName.count), serviceName, UInt32((item["acct"] as? String ?? "").count), (item["acct"] as? String ?? ""), &passLength, &passPtr, &myKeychainItem)
//
//                           if myErr == OSStatus(errSecSuccess) {
//                               let password = NSString(bytes: passPtr!, length: Int(passLength), encoding: String.Encoding.utf8.rawValue)
//                               return password! as String
//                           } else {
//                               throw KeychainError.itemNotFound
//                           }
//                       }
//                   }
//                   throw KeychainError.itemNotFound
//               }
//           }
//
//    }
    
    static func readPassword(service: String, account: String) throws -> Data {
        let query: [String: AnyObject] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to read in Keychain
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            // kSecMatchLimitOne indicates keychain should read
            // only the most recent item matching this query
            kSecMatchLimit as String: kSecMatchLimitOne,

            // kSecReturnData is set to kCFBooleanTrue in order
            // to retrieve the data for the item
            kSecReturnData as String: kCFBooleanTrue
        ]

        // SecItemCopyMatching will attempt to copy the item
        // identified by query to the reference itemCopy
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )

        // errSecItemNotFound is a special status indicating the
        // read item does not exist. Throw itemNotFound so the
        // client can determine whether or not to handle
        // this case
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        // Any status other than errSecSuccess indicates the
        // read operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        // This implementation of KeychainInterface requires all
        // items to be saved and read as Data. Otherwise,
        // invalidItemFormat is thrown
        guard let password = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }

        return password
    }

    static func getWiFiPassword(forNetwork wifiname: String) -> (Bool, String) {
        do {
            let pwd = try KeychainAccess.readPassword(service: "AirPort", account: wifiname)
            return (true, String(decoding: pwd, as: UTF8.self))
        } catch {
            return (false, "Unable to get password: \(error)")
        }
    }

}
