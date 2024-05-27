public extension Int {
    func offset(alignment powerOfTwo: Int) -> Int {
        precondition(self >= 0)
        precondition((0...8).lazy.map({ 1 << $0}).contains(powerOfTwo)) // 1, 2, 4, 8, 16, 32, 64, 128, 256
        let byteCount = (powerOfTwo &- (self % powerOfTwo))
        guard byteCount < powerOfTwo else {
            return 0
        }
        return byteCount
    }
}
