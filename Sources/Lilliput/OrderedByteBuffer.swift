/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

public final class OrderedByteBuffer<Order : ByteOrder> {
    public let buffer: ByteBuffer
    public var remainingBytes: UnsafeMutableRawPointer {
        return buffer.bytes.advanced(by: position)
    }
    public var count: Int {
        return buffer.count
    }
    public var position: Int {
        willSet {
            precondition(newValue >= 0)
        }
    }
    
    public init(buffer: ByteBuffer) {
        self.buffer = buffer
        self.position = 0
    }
    
    public convenience init(count: Int) {
        self.init(buffer: ByteBuffer(count: count))
    }
    
    public func convert<T : ByteOrder>(to order: T.Type) -> OrderedByteBuffer<T> {
        let converted = OrderedByteBuffer<T>(buffer: buffer)
        converted.position = position
        return converted
    }
    
    public var hasRemaining: Bool {
        return remainingCount > 0
    }
    
    public var remainingCount: Int {
        return count - position
    }
    
    public func copy<T>(from source: OrderedByteBuffer<T>) {
        let count = min(remainingCount, source.remainingCount)
        
        if count == 0 {
            return
        }
        
        remainingBytes.copyBytes(from: source.remainingBytes, count: count)
        source.position += count
        position += count
    }
    
    public func copy<T>(to destination: OrderedByteBuffer<T>) {
        let count = min(remainingCount, destination.remainingCount)
        
        if count == 0 {
            return
        }
        
        destination.remainingBytes.copyBytes(from: remainingBytes, count: count)
        destination.position += count
        position += count
    }
    
    public func copy(from source: ByteBuffer) {
        let count = min(remainingCount, source.count)
        
        if count == 0 {
            return
        }
        
        remainingBytes.copyBytes(from: source.bytes, count: count)
        position += count
    }
    
    public func copy(to destination: ByteBuffer) {
        let count = min(remainingCount, destination.count)
        
        if count == 0 {
            return
        }
        
        destination.bytes.copyBytes(from: remainingBytes, count: count)
        position += count
    }
    
    public func getRaw16Bits() -> (UInt8, UInt8) {
        return (getUInt8(), getUInt8())
    }
    
    public func getRaw24Bits() -> (UInt8, UInt8, UInt8) {
        return (getUInt8(), getUInt8(), getUInt8())
    }
    
    public func getRaw32Bits() -> (UInt8, UInt8, UInt8, UInt8) {
        return (getUInt8(), getUInt8(), getUInt8(), getUInt8())
    }
    
    public func getRaw64Bits() -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        return (getUInt8(), getUInt8(), getUInt8(), getUInt8(), getUInt8(), getUInt8(), getUInt8(), getUInt8())
    }
    
    public func getInt8() -> Int8 {
        return Int8(bitPattern: getFixedWidthInteger())
    }
    
    public func getInt16() -> Int16 {
        return Int16(bitPattern: getFixedWidthInteger())
    }
    
    public func getInt24() -> Int32 {
        return makeInt24(getRaw24Bits())
    }
    
    public func getInt32() -> Int32 {
        return Int32(bitPattern: getFixedWidthInteger())
    }
    
    public func getInt64() -> Int64 {
        return Int64(bitPattern: getFixedWidthInteger())
    }
    
    public func getUInt8() -> UInt8 {
        return getFixedWidthInteger()
    }
    
    public func getUInt16() -> UInt16 {
        return getFixedWidthInteger()
    }
    
    public func getUInt32() -> UInt32 {
        return getFixedWidthInteger()
    }
    
    public func getUInt24() -> UInt32 {
        return makeUInt24(getRaw24Bits())
    }
    
    public func getUInt64() -> UInt64 {
        return getFixedWidthInteger()
    }
    
    public func getFloat32() -> Float32 {
        return Float32(bitPattern: getFixedWidthInteger())
    }
    
    public func getFloat64() -> Float64 {
        return Float64(bitPattern: getFixedWidthInteger())
    }
    
    private func getFixedWidthInteger<T : FixedWidthInteger>() -> T {
        var value: T = 0
        readNextBytes(into: &value)
        return Order.swapOrder(value)
    }
    
    private func readNextBytes<T>(into valuePointer: UnsafeMutablePointer<T>) {
        readBytes(at: position, into: valuePointer)
        position += MemoryLayout<T>.size
    }
    
    private func makeInt24(_ octets: (UInt8, UInt8, UInt8)) -> Int32 {
        let octet0 = octets.0 & 0x80 == 0x80 ? UInt32(0xFF000000) : UInt32(0x00000000)
        let octet1 = UInt32(octets.0) << 16
        let octet2 = UInt32(octets.1) << 8
        let octet3 = UInt32(octets.2) << 0
        return Int32(bitPattern: octet0 | octet1 | octet2 | octet3)
    }

    private func makeUInt24(_ octets: (UInt8, UInt8, UInt8)) -> UInt32 {
        let octet0 = UInt32(0x00000000)
        let octet1 = UInt32(octets.0) << 16
        let octet2 = UInt32(octets.1) << 8
        let octet3 = UInt32(octets.2) << 0
        return UInt32(octet0 | octet1 | octet2 | octet3)
    }
    
    public func getInt8(count: Int) -> [Int8] {
        return getFixedWidthInteger(count: count).map({ Int8(bitPattern: $0) })
    }
    
    public func getInt16(count: Int) -> [Int16] {
        return getFixedWidthInteger(count: count).map({ Int16(bitPattern: $0) })
    }
    
    public func getInt32(count: Int) -> [Int32] {
        return getFixedWidthInteger(count: count).map({ Int32(bitPattern: $0) })
    }
    
    public func getInt64(count: Int) -> [Int64] {
        return getFixedWidthInteger(count: count).map({ Int64(bitPattern: $0) })
    }
    
    public func getUInt8(count: Int) -> [UInt8] {
        return getFixedWidthInteger(count: count)
    }
    
    public func getUInt16(count: Int) -> [UInt16] {
        return getFixedWidthInteger(count: count)
    }
    
    public func getUInt32(count: Int) -> [UInt32] {
        return getFixedWidthInteger(count: count)
    }
    
    public func getUInt64(count: Int) -> [UInt64] {
        return getFixedWidthInteger(count: count)
    }
    
    public func getFloat32(count: Int) -> [Float32] {
        return getFixedWidthInteger(count: count).map({ Float32(bitPattern: $0) })
    }
    
    public func getFloat64(count: Int) -> [Float64] {
        return getFixedWidthInteger(count: count).map({ Float64(bitPattern: $0) })
    }
    
    private func getFixedWidthInteger<T : FixedWidthInteger>(count: Int) -> [T] {
        precondition(count <= remainingCount * MemoryLayout<T>.size)
        var array = [T](repeating: 0, count: count)
        
        for index in 0..<count {
            array[index] = getFixedWidthInteger()
        }
        
        return array
    }

    public func getInt8(at position: Int) -> Int8 {
        return Int8(bitPattern: getFixedWidthInteger(at: position))
    }
    
    public func getInt16(at position: Int) -> Int16 {
        return Int16(bitPattern: getFixedWidthInteger(at: position))
    }
    
    public func getInt32(at position: Int) -> Int32 {
        return Int32(bitPattern: getFixedWidthInteger(at: position))
    }
    
    public func getInt64(at position: Int) -> Int64 {
        return Int64(bitPattern: getFixedWidthInteger(at: position))
    }
    
    public func getUInt8(at position: Int) -> UInt8 {
        return getFixedWidthInteger(at: position)
    }
    
    public func getUInt16(at position: Int) -> UInt16 {
        return getFixedWidthInteger(at: position)
    }
    
    public func getUInt32(at position: Int) -> UInt32 {
        return getFixedWidthInteger(at: position)
    }
    
    public func getUInt64(at position: Int) -> UInt64 {
        return getFixedWidthInteger(at: position)
    }
    
    public func getFloat32(at position: Int) -> Float32 {
        return Float32(bitPattern: getFixedWidthInteger(at: position))
    }
    
    public func getFloat64(at position: Int) -> Float64 {
        return Float64(bitPattern: getFixedWidthInteger(at: position))
    }
    
    private func getFixedWidthInteger<T : FixedWidthInteger>(at position: Int) -> T {
        var value: T = 0
        readBytes(at: position, into: &value)
        return Order.swapOrder(value)
    }
    
    private func readBytes<T>(at position: Int, into valuePointer: UnsafeMutablePointer<T>) {
        precondition(position >= 0)
        let numberOfBytes = MemoryLayout<T>.size
        precondition(count - position >= numberOfBytes)
        let sourcePointer = buffer.bytes.advanced(by: position)
        valuePointer.withMemoryRebound(to: UInt8.self, capacity: numberOfBytes) {
            $0.assign(from: sourcePointer.assumingMemoryBound(to: UInt8.self), count: numberOfBytes)
        }
    }
    
    public func putRaw16Bits(_ value: (UInt8, UInt8)) {
        putUInt8(value.0)
        putUInt8(value.1)
    }
    
    public func putRaw24Bits(_ value: (UInt8, UInt8, UInt8)) {
        putUInt8(value.0)
        putUInt8(value.1)
        putUInt8(value.2)
    }
    
    public func putRaw32Bits(_ value: (UInt8, UInt8, UInt8, UInt8)) {
        putUInt8(value.0)
        putUInt8(value.1)
        putUInt8(value.2)
        putUInt8(value.3)
    }
    
    public func putRaw64Bits(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)) {
        putUInt8(value.0)
        putUInt8(value.1)
        putUInt8(value.2)
        putUInt8(value.3)
        putUInt8(value.4)
        putUInt8(value.5)
        putUInt8(value.6)
        putUInt8(value.7)
    }
    
    public func putInt8(_ value: Int8) {
        putFixedWidthInteger(UInt8(bitPattern: value))
    }
    
    public func putInt16(_ value: Int16) {
        putFixedWidthInteger(UInt16(bitPattern: value))
    }
    
    public func putInt24(_ value: Int32) {
        putRaw24Bits(makeRaw24Bits(value))
    }
    
    public func putInt32(_ value: Int32) {
        putFixedWidthInteger(UInt32(bitPattern: value))
    }
    
    public func putInt64(_ value: Int64) {
        putFixedWidthInteger(UInt64(bitPattern: value))
    }
    
    public func putUInt8(_ value: UInt8) {
        putFixedWidthInteger(value)
    }
    
    public func putUInt16(_ value: UInt16) {
        putFixedWidthInteger(value)
    }
    
    public func putUInt24(_ value: UInt32) {
        putRaw24Bits(makeRaw24Bits(value))
    }

    public func putUInt32(_ value: UInt32) {
        putFixedWidthInteger(value)
    }
    
    public func putUInt64(_ value: UInt64) {
        putFixedWidthInteger(value)
    }
    
    public func putFloat32(_ value: Float32) {
        putFixedWidthInteger(value.bitPattern)
    }
    
    public func putFloat64(_ value: Float64) {
        putFixedWidthInteger(value.bitPattern)
    }
    
    private func putFixedWidthInteger<T : FixedWidthInteger>(_ value: T) {
        var swappedValue = Order.swapOrder(value)
        writeNextBytes(from: &swappedValue)
    }
    
    private func writeNextBytes<T>(from valuePointer: UnsafeMutablePointer<T>) {
        writeBytes(at: position, from: valuePointer)
        position += MemoryLayout<T>.size
    }

    private func makeRaw24Bits(_ value: UInt32) -> (UInt8, UInt8, UInt8) {
        precondition(value <= 16777215)
        return (
            UInt8((value & 0x00FF0000) >> 16),
            UInt8((value & 0x0000FF00) >> 8),
            UInt8((value & 0x000000FF) >> 0)
        )
    }
    
    private func makeRaw24Bits(_ value: Int32) -> (UInt8, UInt8, UInt8) {
        precondition(value >= -8388608 && value <= 8388607)
        return (
            UInt8((value & 0x00FF0000) >> 16),
            UInt8((value & 0x0000FF00) >> 8),
            UInt8((value & 0x000000FF) >> 0)
        )
    }

    public func putInt8(_ array: [Int8]) {
        for value in array { putInt8(value) }
    }
    
    public func putInt16(_ array: [Int16]) {
        for value in array { putInt16(value) }
    }
    
    public func putInt32(_ array: [Int32]) {
        for value in array { putInt32(value) }
    }
    
    public func putInt64(_ array: [Int64]) {
        for value in array { putInt64(value) }
    }
    
    public func putUInt8(_ array: [UInt8]) {
        for value in array { putUInt8(value) }
    }
    
    public func putUInt16(_ array: [UInt16]) {
        for value in array { putUInt16(value) }
    }
    
    public func putUInt32(_ array: [UInt32]) {
        for value in array { putUInt32(value) }
    }
    
    public func putUInt64(_ array: [UInt64]) {
        for value in array { putUInt64(value) }
    }
    
    public func putFloat32(_ array: [Float32]) {
        for value in array { putFloat32(value) }
    }
    
    public func putFloat64(_ array: [Float64]) {
        for value in array { putFloat64(value) }
    }
    
    public func putRaw16Bits(_ array: [(UInt8, UInt8)]) {
        for value in array { putRaw16Bits(value) }
    }
    
    public func putRaw24Bits(_ array: [(UInt8, UInt8, UInt8)]) {
        for value in array { putRaw24Bits(value) }
    }
    
    public func putRaw32Bits(_ array: [(UInt8, UInt8, UInt8, UInt8)]) {
        for value in array { putRaw32Bits(value) }
    }
    
    public func putRaw64Bits(_ array: [(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)]) {
        for value in array { putRaw64Bits(value) }
    }
    
    public func putRaw16Bits(_ value: (UInt8, UInt8), at position: Int) {
        putUInt8(value.0, at: position + 0)
        putUInt8(value.1, at: position + 1)
    }
    
    public func putRaw24Bits(_ value: (UInt8, UInt8, UInt8), at position: Int) {
        putUInt8(value.0, at: position + 0)
        putUInt8(value.1, at: position + 1)
        putUInt8(value.2, at: position + 2)
    }
    
    public func putRaw32Bits(_ value: (UInt8, UInt8, UInt8, UInt8), at position: Int) {
        putUInt8(value.0, at: position + 0)
        putUInt8(value.1, at: position + 1)
        putUInt8(value.2, at: position + 2)
        putUInt8(value.3, at: position + 3)
    }
    
    public func putRaw64Bits(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), at position: Int) {
        putUInt8(value.0, at: position + 0)
        putUInt8(value.1, at: position + 1)
        putUInt8(value.2, at: position + 2)
        putUInt8(value.3, at: position + 3)
        putUInt8(value.4, at: position + 4)
        putUInt8(value.5, at: position + 5)
        putUInt8(value.6, at: position + 6)
        putUInt8(value.7, at: position + 7)
    }
    
    public func putInt8(_ value: Int8, at position: Int) {
        putFixedWidthInteger(UInt8(bitPattern: value), at: position)
    }
    
    public func putInt16(_ value: Int16, at position: Int) {
        putFixedWidthInteger(UInt16(bitPattern: value), at: position)
    }
    
    public func putInt32(_ value: Int32, at position: Int) {
        putFixedWidthInteger(UInt32(bitPattern: value), at: position)
    }
    
    public func putInt64(_ value: Int64, at position: Int) {
        putFixedWidthInteger(UInt64(bitPattern: value), at: position)
    }
    
    public func putUInt8(_ value: UInt8, at position: Int) {
        putFixedWidthInteger(value, at: position)
    }
    
    public func putUInt16(_ value: UInt16, at position: Int) {
        putFixedWidthInteger(value, at: position)
    }
    
    public func putUInt32(_ value: UInt32, at position: Int) {
        putFixedWidthInteger(value, at: position)
    }
    
    public func putUInt64(_ value: UInt64, at position: Int) {
        putFixedWidthInteger(value, at: position)
    }
    
    public func putFloat32(_ value: Float32, at position: Int) {
        putFixedWidthInteger(value.bitPattern, at: position)
    }
    
    public func putFloat64(_ value: Float64, at position: Int) {
        putFixedWidthInteger(value.bitPattern, at: position)
    }
    
    private func putFixedWidthInteger<T : FixedWidthInteger>(_ value: T, at position: Int) {
        var swappedValue = Order.swapOrder(value)
        writeBytes(at: position, from: &swappedValue)
    }
    
    private func writeBytes<T>(at position: Int, from valuePointer: UnsafeMutablePointer<T>) {
        precondition(position >= 0)
        let numberOfBytes = MemoryLayout<T>.size
        precondition(count - position >= numberOfBytes)
        let destinationPointer = buffer.bytes.advanced(by: position).bindMemory(to: UInt8.self, capacity: numberOfBytes)
        valuePointer.withMemoryRebound(to: UInt8.self, capacity: numberOfBytes) {
            destinationPointer.assign(from: $0, count: numberOfBytes)
        }
    }
    
    public func align(_ byteCount: Int) {
        position += (byteCount - (position % byteCount)) % byteCount
    }
}
