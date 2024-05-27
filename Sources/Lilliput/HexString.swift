public extension BinaryInteger {
    var hex: String {
        return hex(uppercase: true)
    }
    
    func hex(uppercase: Bool) -> String {
        var hexDigits = String(self, radix: 16, uppercase: uppercase)
        while hexDigits.count < MemoryLayout<Self>.size * 2 {
            hexDigits = "0" + hexDigits
        }
        return "0x\(hexDigits)"
    }
}
