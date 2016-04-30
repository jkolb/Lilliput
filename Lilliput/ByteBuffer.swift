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
    private let buffer: Buffer
    public var data: UnsafeMutablePointer<Void> {
        return buffer.data
    }
    public var size: Int {
        return buffer.size
    }
    public var capacity: Int {
        return buffer.size
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
            precondition(newValue <= capacity)
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
        self.limit = buffer.size
        self.markedPosition = -1
    }
    
    public var hasRemaining: Bool {
        // Tells whether there are any elements between the current position and the limit.
        return remaining > 0
    }
    
    public var remainingData: UnsafeMutablePointer<Void> {
        return buffer.data.advancedBy(position)
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
        limit = capacity
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
        let bytes = UnsafeMutablePointer<UInt8>(buffer.data)
        bytes.moveInitializeFrom(bytes.advancedBy(position), count: remaining)
        position = remaining
        limit = capacity
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
        let bytes = UnsafePointer<UInt8>(buffer.data)
        let value = bytes[position]
        position += sizeof(UInt8)
        return value
    }
    
    public func getUInt16() -> UInt16 {
        let bytes = UnsafePointer<UInt16>(buffer.data)
        let value = bytes[position]
        position += sizeof(UInt16)
        return Order.swapUInt16(value)
    }
    
    public func getUInt32() -> UInt32 {
        let bytes = UnsafePointer<UInt32>(buffer.data)
        let value = bytes[position]
        position += sizeof(UInt32)
        return Order.swapUInt32(value)
    }
    
    public func getUInt64() -> UInt64 {
        let bytes = UnsafePointer<UInt64>(buffer.data)
        let value = bytes[position]
        position += sizeof(UInt64)
        return Order.swapUInt64(value)
    }
    
    public func getFloat32() -> Float32 {
        return unsafeBitCast(getUInt32(), Float32.self)
    }
    
    public func getFloat64() -> Float64 {
        return unsafeBitCast(getUInt64(), Float64.self)
    }
    
    public func getInt8(count: Int) -> [Int8] {
        var array = [Int8](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getInt8() }
        return array
    }
    
    public func getInt16(count: Int) -> [Int16] {
        var array = [Int16](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getInt16() }
        return array
    }
    
    public func getInt32(count: Int) -> [Int32] {
        var array = [Int32](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getInt32() }
        return array
    }
    
    public func getInt64(count: Int) -> [Int64] {
        var array = [Int64](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getInt64() }
        return array
    }
    
    public func getUInt8(count: Int) -> [UInt8] {
        var array = [UInt8](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getUInt8() }
        return array
    }
    
    public func getUInt16(count: Int) -> [UInt16] {
        var array = [UInt16](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getUInt16() }
        return array
    }
    
    public func getUInt32(count: Int) -> [UInt32] {
        var array = [UInt32](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getUInt32() }
        return array
    }
    
    public func getUInt64(count: Int) -> [UInt64] {
        var array = [UInt64](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getUInt64() }
        return array
    }
    
    public func getFloat32(count: Int) -> [Float32] {
        var array = [Float32](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getFloat32() }
        return array
    }
    
    public func getFloat64(count: Int) -> [Float64] {
        var array = [Float64](count: count, repeatedValue: 0)
        for index in 0..<count { array[index] = getFloat64() }
        return array
    }
    
    public func getUTF8(length: Int) -> String {
        return decodeCodeUnits(getUInt8(length), codec: UTF8())
    }
    
    public func getUTF8(terminator: UTF8.CodeUnit = 0) -> String {
        return decodeCodeUnits(getUTF8(terminator), codec: UTF8())
    }
    
    public func getUTF16(length: Int) -> String {
        return decodeCodeUnits(getUInt16(length), codec: UTF16())
    }
    
    public func decodeCodeUnits<C : UnicodeCodecType>(codeUnits: [C.CodeUnit], codec: C) -> String {
        var decodeCodec = codec
        var generator = codeUnits.generate()
        var characters = [Character]()
        characters.reserveCapacity(codeUnits.count)
        var done = false
        
        while (!done) {
            switch decodeCodec.decode(&generator) {
            case .Result(let scalar):
                characters.append(Character(scalar))
                
            case .EmptyInput:
                done = true
                
            case .Error:
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
    
    public func putInt8(value: Int8) {
        putUInt8(UInt8(bitPattern: value))
    }
    
    public func putInt16(value: Int16) {
        putUInt16(UInt16(bitPattern: value))
    }
    
    public func putInt32(value: Int32) {
        putUInt32(UInt32(bitPattern: value))
    }
    
    public func putInt64(value: Int64) {
        putUInt64(UInt64(bitPattern: value))
    }
    
    public func putUInt8(value: UInt8) {
        let bytes = UnsafeMutablePointer<UInt8>(buffer.data)
        bytes[position] = value
        position += sizeof(UInt8)
    }
    
    public func putUInt16(value: UInt16) {
        let bytes = UnsafeMutablePointer<UInt16>(buffer.data)
        bytes[position] = Order.swapUInt16(value)
        position += sizeof(UInt16)
    }
    
    public func putUInt32(value: UInt32) {
        let bytes = UnsafeMutablePointer<UInt32>(buffer.data)
        bytes[position] = Order.swapUInt32(value)
        position += sizeof(UInt32)
    }
    
    public func putUInt64(value: UInt64) {
        let bytes = UnsafeMutablePointer<UInt64>(buffer.data)
        bytes[position] = Order.swapUInt64(value)
        position += sizeof(UInt64)
    }
    
    public func putFloat32(value: Float32) {
        putUInt32(unsafeBitCast(value, UInt32.self))
    }
    
    public func putFloat64(value: Float64) {
        putUInt64(unsafeBitCast(value, UInt64.self))
    }
    
    public func putUInt8(source: [UInt8]) {
        putUInt8(source, offset: 0, length: source.count)
    }
    
    public func putUInt8(source: [UInt8], offset: Int, length: Int) {
        precondition(length <= remaining)
        let destination = UnsafeMutablePointer<UInt8>(remainingData)
        position += length
        destination.initializeFrom(source[offset..<offset+length])
    }
    
    public func putUTF8(value: String) {
        value.utf8.forEach({ putUInt8($0) })
    }
    
    public func putUTF8(value: String, terminator: UTF8.CodeUnit = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    public func putBuffer(source: ByteBuffer<Order>) {
        precondition(source.remaining <= remaining)
        let count = source.remaining
        
        let sourceBytes = UnsafeMutablePointer<UInt8>(source.remainingData)
        source.position += count
        
        let destinationBytes = UnsafeMutablePointer<UInt8>(remainingData)
        position += count
        
        destinationBytes.initializeFrom(sourceBytes, count: count)
    }
}
