/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Justin Kolb
 
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

public final class UnsafeOrderedBuffer<Order : ByteOrder> {
    public let buffer: UnsafeBuffer
    public var remainingBytes: UnsafeMutableRawPointer {
        return buffer.bytes.advanced(by: position)
    }
    public var count: Int {
        return buffer.count
    }
    public var position: Int
    
    public init(buffer: UnsafeBuffer) {
        self.buffer = buffer
        self.position = 0
    }
    
    public var hasRemaining: Bool {
        return remainingCount > 0
    }
    
    public var remainingCount: Int {
        return count - position
    }
    
    public func copyFromBuffer<T>(_ source: UnsafeOrderedBuffer<T>) {
        let count = min(remainingCount, source.remainingCount)
        
        if count == 0 {
            return
        }
        
        remainingBytes.copyBytes(from: source.remainingBytes, count: count)
        source.position += count
        position += count
    }
    
    public func copyToBuffer<T>(_ destination: UnsafeOrderedBuffer<T>) {
        let count = min(remainingCount, destination.remainingCount)
        
        if count == 0 {
            return
        }
        
        destination.remainingBytes.copyBytes(from: remainingBytes, count: count)
        destination.position += count
        position += count
    }
    
    public func copyFromBuffer(_ source: UnsafeBuffer) {
        let count = min(remainingCount, source.count)
        
        if count == 0 {
            return
        }
        
        remainingBytes.copyBytes(from: source.bytes, count: count)
        position += count
    }

    public func copyToBuffer(_ destination: UnsafeBuffer) {
        let count = min(remainingCount, destination.count)
        
        if count == 0 {
            return
        }
        
        destination.bytes.copyBytes(from: remainingBytes, count: count)
        position += count
    }
    
    @inline(__always) fileprivate func getValue<T>() -> T {
        let value: T = getValueAt(position)
        position += MemoryLayout<T>.size
        return value
    }
    
    @inline(__always) fileprivate func putValue<T>(_ value: T) {
        putValue(value, at: position)
        position += MemoryLayout<T>.size
    }
    
    @inline(__always) fileprivate func getValueAt<T>(_ position: Int) -> T {
        return buffer.bytes.advanced(by: position).bindMemory(to: T.self, capacity: 1).pointee
    }
    
    @inline(__always) fileprivate func putValue<T>(_ value: T, at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: T.self, capacity: 1).pointee = value
    }

    fileprivate func getArray<T>(repeating: T, count: Int, getter: () -> T) -> [T] {
        precondition(count <= remainingCount)
        var array = [T](repeating: repeating, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<T>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getter(), toByteOffset: byteOffset, as: T.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    fileprivate func putArray<T>(_ array: [T], putter: (T) -> Void) {
        for value in array { putter(value) }
    }

    @inline(__always) public func getRaw16Bits() -> (UInt8, UInt8) {
        return getValue()
    }
    
    @inline(__always) public func getRaw24Bits() -> (UInt8, UInt8, UInt8) {
        return getValue()
    }
    
    @inline(__always) public func getRaw32Bits() -> (UInt8, UInt8, UInt8, UInt8) {
        return getValue()
    }
    
    @inline(__always) public func getRaw64Bits() -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        return getValue()
    }
    
    @inline(__always) public func getInt8() -> Int8 {
        return Int8(bitPattern: getUInt8())
    }
    
    @inline(__always) public func getInt16() -> Int16 {
        return Int16(bitPattern: getUInt16())
    }
    
    @inline(__always) public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }
    
    @inline(__always) public func getInt64() -> Int64 {
        return Int64(bitPattern: getUInt64())
    }
    
    @inline(__always) public func getUInt8() -> UInt8 {
        return getValue()
    }
    
    @inline(__always) public func getUInt16() -> UInt16 {
        return Order.swapUInt16(getValue())
    }
    
    @inline(__always) public func getUInt32() -> UInt32 {
        return Order.swapUInt32(getValue())
    }
    
    @inline(__always) public func getUInt64() -> UInt64 {
        return Order.swapUInt64(getValue())
    }
    
    @inline(__always) public func getFloat32() -> Float32 {
        return unsafeBitCast(getUInt32(), to: Float32.self)
    }
    
    @inline(__always) public func getFloat64() -> Float64 {
        return unsafeBitCast(getUInt64(), to: Float64.self)
    }
    
    public func getInt8(count: Int) -> [Int8] {
        precondition(count <= remainingCount)
        var array = [Int8](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (pointer) -> Void in
            pointer.baseAddress!.copyBytes(from: remainingBytes, count: count)
        }
        position += count
        return array
    }
    
    public func getInt16(count: Int) -> [Int16] {
        return getArray(repeating: 0, count: count, getter: getInt16)
    }
    
    public func getInt32(count: Int) -> [Int32] {
        return getArray(repeating: 0, count: count, getter: getInt32)
    }
    
    public func getInt64(count: Int) -> [Int64] {
        return getArray(repeating: 0, count: count, getter: getInt64)
    }
    
    public func getUInt8(count: Int) -> [UInt8] {
        precondition(count <= remainingCount)
        var array = [UInt8](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (pointer) -> Void in
            pointer.baseAddress!.copyBytes(from: remainingBytes, count: count)
        }
        position += count
        return array
    }
    
    public func getUInt16(count: Int) -> [UInt16] {
        return getArray(repeating: 0, count: count, getter: getUInt16)
    }
    
    public func getUInt32(count: Int) -> [UInt32] {
        return getArray(repeating: 0, count: count, getter: getUInt32)
    }
    
    public func getUInt64(count: Int) -> [UInt64] {
        return getArray(repeating: 0, count: count, getter: getUInt64)
    }
    
    public func getFloat32(count: Int) -> [Float32] {
        return getArray(repeating: 0, count: count, getter: getFloat32)
    }
    
    public func getFloat64(count: Int) -> [Float64] {
        return getArray(repeating: 0, count: count, getter: getFloat64)
    }
    
    @inline(__always) public func getInt8At(_ position: Int) -> Int8 {
        return Int8(bitPattern: getUInt8At(position))
    }
    
    @inline(__always) public func getInt16At(_ position: Int) -> Int16 {
        return Int16(bitPattern: getUInt16At(position))
    }
    
    @inline(__always) public func getInt32At(_ position: Int) -> Int32 {
        return Int32(bitPattern: getUInt32At(position))
    }
    
    @inline(__always) public func getInt64At(_ position: Int) -> Int64 {
        return Int64(bitPattern: getUInt64At(position))
    }

    @inline(__always) public func getUInt8At(_ position: Int) -> UInt8 {
        return getValueAt(position)
    }
    
    @inline(__always) public func getUInt16At(_ position: Int) -> UInt16 {
        return Order.swapUInt16(getValueAt(position))
    }
    
    @inline(__always) public func getUInt32At(_ position: Int) -> UInt32 {
        return Order.swapUInt32(getValueAt(position))
    }
    
    @inline(__always) public func getUInt64At(_ position: Int) -> UInt64 {
        return Order.swapUInt64(getValueAt(position))
    }
    
    @inline(__always) public func getFloat32At(_ position: Int) -> Float32 {
        return unsafeBitCast(getUInt32At(position), to: Float32.self)
    }
    
    @inline(__always) public func getFloat64At(_ position: Int) -> Float64 {
        return unsafeBitCast(getUInt64At(position), to: Float64.self)
    }
    
    public func getUTF8(length: Int) -> String {
        return decodeCodeUnits(getUInt8(count: length), codec: UTF8())
    }
    
    public func getTerminatedUTF8(terminator: UInt8 = 0) -> String {
        return decodeCodeUnits(getTerminatedUInt8(terminator: terminator), codec: UTF8())
    }
    
    public func getUTF16(length: Int) -> String {
        return decodeCodeUnits(getUInt16(count: length), codec: UTF16())
    }
    
    fileprivate func decodeCodeUnits<C : UnicodeCodec>(_ codeUnits: [C.CodeUnit], codec: C) -> String {
        var decodeCodec = codec
        var generator = codeUnits.makeIterator()
        var characters = [Character]()
        characters.reserveCapacity(codeUnits.count)
        var done = false
        
        while (!done) {
            switch decodeCodec.decode(&generator) {
            case .scalarValue(let scalar):
                characters.append(Character(scalar))
                
            case .emptyInput:
                done = true
                
            case .error:
                done = true
            }
        }
        
        return String(characters)
    }
    
    public func getTerminatedUInt8(terminator: UInt8 = 0) -> [UInt8] {
        var array = [UInt8]()
        var done = true
        
        while (!done) {
            let value = getUInt8()
            
            if (value == terminator) {
                done = true
            } else {
                array.append(value)
            }
        }
        
        return array
    }
    
    @inline(__always) public func putRaw16Bits(_ value: (UInt8, UInt8)) {
        putValue(value)
    }
    
    @inline(__always) public func putRaw24Bits(_ value: (UInt8, UInt8, UInt8)) {
        putValue(value)
    }
    
    @inline(__always) public func putRaw32Bits(_ value: (UInt8, UInt8, UInt8, UInt8)) {
        putValue(value)
    }
    
    @inline(__always) public func putRaw64Bits(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)) {
        putValue(value)
    }

    @inline(__always) public func putInt8(_ value: Int8) {
        putUInt8(UInt8(bitPattern: value))
    }
    
    @inline(__always) public func putInt16(_ value: Int16) {
        putUInt16(UInt16(bitPattern: value))
    }
    
    @inline(__always) public func putInt32(_ value: Int32) {
        putUInt32(UInt32(bitPattern: value))
    }
    
    @inline(__always) public func putInt64(_ value: Int64) {
        putUInt64(UInt64(bitPattern: value))
    }
    
    @inline(__always) public func putUInt8(_ value: UInt8) {
        putValue(value)
    }
    
    @inline(__always) public func putUInt16(_ value: UInt16) {
        putValue(Order.swapUInt16(value))
    }
    
    @inline(__always) public func putUInt32(_ value: UInt32) {
        putValue(Order.swapUInt32(value))
    }
    
    @inline(__always) public func putUInt64(_ value: UInt64) {
        putValue(Order.swapUInt64(value))
    }
    
    @inline(__always) public func putFloat32(_ value: Float32) {
        putUInt32(unsafeBitCast(value, to: UInt32.self))
    }
    
    @inline(__always) public func putFloat64(_ value: Float64) {
        putUInt64(unsafeBitCast(value, to: UInt64.self))
    }
    
    public func putInt8(_ array: [Int8]) {
        putArray(array, putter: putInt8)
    }
    
    public func putInt16(_ array: [Int16]) {
        putArray(array, putter: putInt16)
    }
    
    public func putInt32(_ array: [Int32]) {
        putArray(array, putter: putInt32)
    }
    
    public func putInt64(_ array: [Int64]) {
        putArray(array, putter: putInt64)
    }
    
    public func putUInt8(_ array: [UInt8]) {
        putArray(array, putter: putUInt8)
    }
    
    public func putUInt16(_ array: [UInt16]) {
        putArray(array, putter: putUInt16)
    }
    
    public func putUInt32(_ array: [UInt32]) {
        putArray(array, putter: putUInt32)
    }
    
    public func putUInt64(_ array: [UInt64]) {
        putArray(array, putter: putUInt64)
    }
    
    public func putFloat32(_ array: [Float32]) {
        putArray(array, putter: putFloat32)
    }
    
    public func putFloat64(_ array: [Float64]) {
        putArray(array, putter: putFloat64)
    }
    
    @inline(__always) public func putInt8(_ value: Int8, at position: Int) {
        putUInt8(UInt8(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putInt16(_ value: Int16, at position: Int) {
        putUInt16(UInt16(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putInt32(_ value: Int32, at position: Int) {
        putUInt32(UInt32(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putInt64(_ value: Int64, at position: Int) {
        putUInt64(UInt64(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putUInt8(_ value: UInt8, at position: Int) {
    }
    
    @inline(__always) public func putUInt16(_ value: UInt16, at position: Int) {
        putValue(Order.swapUInt16(value), at: position)
    }
    
    @inline(__always) public func putUInt32(_ value: UInt32, at position: Int) {
        putValue(Order.swapUInt32(value), at: position)
    }
    
    @inline(__always) public func putUInt64(_ value: UInt64, at position: Int) {
        putValue(Order.swapUInt64(value), at: position)
    }
    
    @inline(__always) public func putFloat32(_ value: Float32, at position: Int) {
        putUInt32(unsafeBitCast(value, to: UInt32.self), at: position)
    }
    
    @inline(__always) public func putFloat64(_ value: Float64, at position: Int) {
        putUInt64(unsafeBitCast(value, to: UInt64.self), at: position)
    }
    
    public func putUTF8(_ value: String) {
        value.utf8.forEach { putUInt8($0) }
    }
    
    public func putTerminatedUTF8(_ value: String, terminator: UTF8.CodeUnit = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    public func align(_ byteCount: Int) {
        position += (byteCount - (position % byteCount)) % byteCount
    }
}
