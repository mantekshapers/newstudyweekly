//
//  StorageSizeClass.swift
//  StudiesWeekly
//
//  Created by Man Singh on 10/5/18.
//  Copyright © 2018 TekShapers. All rights reserved.
//

import Foundation

class StorageSizeClass {
    
   static func deviceRemainingFreeSpaceInBytes() -> Int64? {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        guard
            let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
            let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
            else {
                // something failed
                return nil
             }
        return freeSize.int64Value
    }
    
  static func getStorageSpace()->Double {
        if let bytes = deviceRemainingFreeSpaceInBytes() {
            print("free space: \(bytes)")
            //return Int(exactly: bytes)!
           // ConvertSize.init(bytes: bytes)
            let gb = ConvertSize(bytes: bytes).gigabytes
            
            
             print("free space in gb : \(gb)")
            return gb
           
        } else {
            print("failed")
        }
    return 0.0
    }
    
    public struct ConvertSize {
        
        public let bytes: Int64
        
        public var kilobytes: Double {
            return Double(bytes) / 1_024
        }
        
        public var megabytes: Double {
            return kilobytes / 1_024
        }
        
        public var gigabytes: Double {
            return megabytes / 1_024
        }
        
        public init(bytes: Int64) {
            self.bytes = bytes
        }
    }
    
}
