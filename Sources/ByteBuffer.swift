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

public final class ByteBuffer<Order : ByteOrder> : Buffer {
    private var buffer: Buffer
    
    public var count: Int {
        return buffer.count
    }
    
    public func withUnsafeBytes<ResultType, ContentType>(_ body: (UnsafePointer<ContentType>) throws -> ResultType) rethrows -> ResultType {
        return try buffer.withUnsafeBytes(body)
    }
    
    public func withUnsafeMutableBytes<ResultType, ContentType>(_ body: (UnsafeMutablePointer<ContentType>) throws -> ResultType) rethrows -> ResultType {
        return try buffer.withUnsafeMutableBytes(body)
    }
    
    public var position: Int {
        willSet {
            // The new position value; must be non-negative and no larger than the current limit
            precondition(newValue >= 0)
            precondition(newValue <= limit)
        }
        didSet {
            // If the mark is defined and larger than the new position then it is discarded.
            if markedPosition > position {
                discardMark()
            }
        }
    }
    public var limit: Int {
        willSet {
            // The new limit value; must be non-negative and no larger than this buffer's capacity
            precondition(newValue >= 0)
            precondition(newValue <= count)
        }
        didSet {
            // If the position is larger than the new limit then it is set to the new limit.
            if position > limit {
                position = limit
            }
            
            // If the mark is defined and larger than the new limit then it is discarded.
            if markedPosition > limit {
                discardMark()
            }
        }
    }
    private var markedPosition: Int
    private func discardMark() {
        markedPosition = -1
    }
    
    public init(buffer: Buffer) {
        // The new buffer's position will be zero, its limit will be its capacity, its mark will be undefined.
        self.buffer = buffer
        self.position = 0
        self.limit = buffer.count
        self.markedPosition = -1
    }
    
    public var hasRemaining: Bool {
        // Tells whether there are any elements between the current position and the limit.
        return remaining > 0
    }
    
    public var remaining: Int {
        // Returns the number of elements between the current position and the limit.
        return limit - position
    }
    
    public func mark() {
        // Sets this buffer's mark at its position.
        markedPosition = position
    }
    
    public func reset() {
        precondition(markedPosition != -1)
        // Resets this buffer's position to the previously-marked position.
        // Invoking this method neither changes nor discards the mark's value.
        position = markedPosition
    }
    
    public func clear() {
        // Clears this buffer. The position is set to zero, the limit is set to the capacity, and the mark is discarded.
        position = 0
        limit = count
        discardMark()
    }
    
    public func flip() {
        // Flips this buffer. The limit is set to the current position and then the position is set to zero. If the mark is defined then it is discarded.
        limit = position
        position = 0
        discardMark()
    }
    
    public func rewind() {
        // Rewinds this buffer. The position is set to zero and the mark is discarded.
        position = 0
        discardMark()
    }
    
    public func compact() {
        withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<UInt8>) -> Void in
            pointer.moveInitialize(from: pointer.advanced(by: position), count: remaining)
        }
        position = remaining
        limit = count
    }
    
    private func getValueAt<T>(_ position: Int) -> T {
        precondition(position >= 0 && position <= count - MemoryLayout<T>.size)
        
        let value: T = withUnsafeBytes { (bytes: UnsafePointer<UInt8>) in
            return bytes.advanced(by: position).withMemoryRebound(to: T.self, capacity: 1, { (pointer) -> T in
                return pointer.pointee
            })
        }
        return value
    }

    public func getInt8() -> Int8 {
        return Int8(bitPattern: getUInt8())
    }
    
    public func getInt16() -> Int16 {
        return Int16(bitPattern: getUInt16())
    }
    
    public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }
    
    public func getInt64() -> Int64 {
        return Int64(bitPattern: getUInt64())
    }
    
    public func getUInt8() -> UInt8 {
        let value: UInt8 = getValueAt(position)
        position += MemoryLayout<UInt8>.size
        return value
    }
    
    public func getUInt16() -> UInt16 {
        let value: UInt16 = getValueAt(position)
        position += MemoryLayout<UInt16>.size
        return Order.swapUInt16(value)
    }
    
    public func getUInt32() -> UInt32 {
        let value: UInt32 = getValueAt(position)
        position += MemoryLayout<UInt32>.size
        return Order.swapUInt32(value)
    }
    
    public func getUInt64() -> UInt64 {
        let value: UInt64 = getValueAt(position)
        position += MemoryLayout<UInt64>.size
        return Order.swapUInt64(value)
    }
    
    public func getFloat32() -> Float32 {
        return unsafeBitCast(getUInt32(), to: Float32.self)
    }
    
    public func getFloat64() -> Float64 {
        return unsafeBitCast(getUInt64(), to: Float64.self)
    }
    
    public func getInt8(count: Int) -> [Int8] {
        var array = [Int8](repeating: 0, count: count)
        for index in 0..<count { array[index] = getInt8() }
        return array
    }
    
    public func getInt16(count: Int) -> [Int16] {
        var array = [Int16](repeating: 0, count: count)
        for index in 0..<count { array[index] = getInt16() }
        return array
    }
    
    public func getInt32(count: Int) -> [Int32] {
        var array = [Int32](repeating: 0, count: count)
        for index in 0..<count { array[index] = getInt32() }
        return array
    }
    
    public func getInt64(count: Int) -> [Int64] {
        var array = [Int64](repeating: 0, count: count)
        for index in 0..<count { array[index] = getInt64() }
        return array
    }
    
    public func getUInt8(count: Int) -> [UInt8] {
        var array = [UInt8](repeating: 0, count: count)
        for index in 0..<count { array[index] = getUInt8() }
        return array
    }
    
    public func getUInt16(count: Int) -> [UInt16] {
        var array = [UInt16](repeating: 0, count: count)
        for index in 0..<count { array[index] = getUInt16() }
        return array
    }
    
    public func getUInt32(count: Int) -> [UInt32] {
        var array = [UInt32](repeating: 0, count: count)
        for index in 0..<count { array[index] = getUInt32() }
        return array
    }
    
    public func getUInt64(count: Int) -> [UInt64] {
        var array = [UInt64](repeating: 0, count: count)
        for index in 0..<count { array[index] = getUInt64() }
        return array
    }
    
    public func getFloat32(count: Int) -> [Float32] {
        var array = [Float32](repeating: 0, count: count)
        for index in 0..<count { array[index] = getFloat32() }
        return array
    }
    
    public func getFloat64(count: Int) -> [Float64] {
        var array = [Float64](repeating: 0, count: count)
        for index in 0..<count { array[index] = getFloat64() }
        return array
    }

    public func getInt8At(_ position: Int) -> Int8 {
        return Int8(bitPattern: getUInt8At(position))
    }
    
    public func getInt16At(_ position: Int) -> Int16 {
        return Int16(bitPattern: getUInt16At(position))
    }
    
    public func getInt32At(_ position: Int) -> Int32 {
        return Int32(bitPattern: getUInt32At(position))
    }
    
    public func getInt64At(_ position: Int) -> Int64 {
        return Int64(bitPattern: getUInt64At(position))
    }
    
    public func getUInt8At(_ position: Int) -> UInt8 {
        let value: UInt8 = getValueAt(position)
        return value
    }
    
    public func getUInt16At(_ position: Int) -> UInt16 {
        let value: UInt16 = getValueAt(position)
        return Order.swapUInt16(value)
    }
    
    public func getUInt32At(_ position: Int) -> UInt32 {
        let value: UInt32 = getValueAt(position)
        return Order.swapUInt32(value)
    }
    
    public func getUInt64At(_ position: Int) -> UInt64 {
        let value: UInt64 = getValueAt(position)
        return Order.swapUInt64(value)
    }
    
    public func getFloat32At(_ position: Int) -> Float32 {
        return unsafeBitCast(getUInt32At(position), to: Float32.self)
    }
    
    public func getFloat64At(_ position: Int) -> Float64 {
        return unsafeBitCast(getUInt64At(position), to: Float64.self)
    }

    public func getUTF8(length: Int) -> String {
        return decodeCodeUnits(getUInt8(count: length), codec: UTF8())
    }
    
    public func getUTF8(terminator: UTF8.CodeUnit = 0) -> String {
        return decodeCodeUnits(getUTF8(terminator: terminator), codec: UTF8())
    }
    
    public func getUTF16(length: Int) -> String {
        return decodeCodeUnits(getUInt16(count: length), codec: UTF16())
    }
    
    public func decodeCodeUnits<C : UnicodeCodec>(_ codeUnits: [C.CodeUnit], codec: C) -> String {
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
    
    public func getUTF8(terminator: UTF8.CodeUnit) -> [UTF8.CodeUnit] {
        var array = Array<UTF8.CodeUnit>()
        var done = true
        
        while (!done) {
            let value: UTF8.CodeUnit = getUInt8()
            
            if (value == terminator) {
                done = true
            } else {
                array.append(value)
            }
        }
        
        return array
    }
    
    private func putValue<T>(_ value: T, at position: Int) {
        precondition(position >= 0 && position <= count - MemoryLayout<T>.size)
    
        withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) -> Void in
            bytes.advanced(by: position).withMemoryRebound(to: T.self, capacity: 1, { (pointer) -> Void in
                pointer.pointee = value
            })
        }
    }

    public func putInt8(_ value: Int8) {
        putUInt8(UInt8(bitPattern: value))
    }
    
    public func putInt16(_ value: Int16) {
        putUInt16(UInt16(bitPattern: value))
    }
    
    public func putInt32(_ value: Int32) {
        putUInt32(UInt32(bitPattern: value))
    }
    
    public func putInt64(_ value: Int64) {
        putUInt64(UInt64(bitPattern: value))
    }
    
    public func putUInt8(_ value: UInt8) {
        putValue(value, at: position)
        position += MemoryLayout<UInt8>.size
    }
    
    public func putUInt16(_ value: UInt16) {
        putValue(Order.swapUInt16(value), at: position)
        position += MemoryLayout<UInt16>.size
    }
    
    public func putUInt32(_ value: UInt32) {
        putValue(Order.swapUInt32(value), at: position)
        position += MemoryLayout<UInt32>.size
    }
    
    public func putUInt64(_ value: UInt64) {
        putValue(Order.swapUInt64(value), at: position)
        position += MemoryLayout<UInt64>.size
    }
    
    public func putFloat32(_ value: Float32) {
        putUInt32(unsafeBitCast(value, to: UInt32.self))
    }
    
    public func putFloat64(_ value: Float64) {
        putUInt64(unsafeBitCast(value, to: UInt64.self))
    }
    
    public func putUInt8(_ source: [UInt8]) {
        putUInt8(source, offset: 0, length: source.count)
    }
    
    public func putUInt8(_ source: [UInt8], offset: Int, length: Int) {
        precondition(offset + length <= source.count)
        precondition(length <= remaining)
        
        source.withUnsafeBufferPointer { (srcPtr) -> Void in
            withUnsafeMutableBytes { (dstPtr: UnsafeMutablePointer<UInt8>) -> Void in
                dstPtr.initialize(from: srcPtr.baseAddress!, count: length)
            }
        }
        
        position += length
    }
    
    public func putUTF8(_ value: String) {
        value.utf8.forEach({ putUInt8($0) })
    }
    
    public func putUTF8(_ value: String, terminator: UTF8.CodeUnit = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    public func putBuffer(_ source: ByteBuffer<Order>) {
        let count = min(source.remaining, remaining)
        
        if count == 0 {
            return
        }
        
        source.withUnsafeBytes { (srcPtr: UnsafePointer<UInt8>) -> Void in
            withUnsafeMutableBytes { (dstPtr: UnsafeMutablePointer<UInt8>) -> Void in
                dstPtr.advanced(by: position).initialize(from: srcPtr.advanced(by: source.position), count: count)
            }
        }
        
        source.position += count
        position += count
    }
}
