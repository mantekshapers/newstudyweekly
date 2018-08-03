//
// Based on https://gist.github.com/finder39/f6d71f03661f7147547d
// NOTE: There's no CommonCrypto module for Swift. To make the import CommonCrypto line work do something like what's described in http://stackoverflow.com/a/29189873/257577
//
//import CommonCrypto
//
//extension String {
//    /**
//        Get the MD5 hash of this String
//
//        - returns: MD5 hash of this String
//     */
//    func md5() -> String! {
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
//
//        CC_MD5(str!, strLen, result)
//
//        let hash = NSMutableString()
//
//        for i in 0..<digestLength {
//            hash.appendFormat("%02x", result[i])
//        }
//
//        result.deinitialize()
//
//        return String(format: hash as String)
//    }
//}

