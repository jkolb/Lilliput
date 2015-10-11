//
// ByteBuffer.swift
// Lilliput
//
// Copyright (c) 2015 Justin Kolb - https://github.com/jkolb/Lilliput
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

public final class ByteBuffer {
    private static let undefinedMark = -1
    public var order: ByteOrder
    private var bytes: UnsafeMutablePointer<UInt8>
    public var contents: UnsafeMutablePointer<Void> {
        return UnsafeMutablePointer<Void>(bytes)
    }
    private let freeOnDeinit: Bool
    public let capacity: Int
    private let bits = UnsafeMutablePointer<UInt8>.alloc(strideof(UIntMax))
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
        markedPosition = ByteBuffer.undefinedMark
    }
    
    public init(order: ByteOrder, data: UnsafeMutablePointer<Void>, capacity: Int, freeOnDeinit: Bool) {
        // The new buffer's position will be zero, its limit will be its capacity, its mark will be undefined.
        precondition(capacity >= 0)
        self.order = order
        self.bytes = UnsafeMutablePointer<UInt8>(data)
        self.capacity = capacity
        self.freeOnDeinit = freeOnDeinit
        self.position = 0
        self.limit = capacity
        self.markedPosition = ByteBuffer.undefinedMark
    }
    
    public convenience init(order: ByteOrder, capacity: Int) {
        self.init(order: order, data: UnsafeMutablePointer<UInt8>.alloc(capacity), capacity: capacity, freeOnDeinit: true)
    }
    
    deinit {
        bits.dealloc(strideof(UIntMax))
        if freeOnDeinit { bytes.dealloc(capacity) }
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
        precondition(markedPosition != ByteBuffer.undefinedMark)
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
        bytes.moveInitializeFrom(bytes+position, count: remaining)
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
        return bytes[position++]
    }
    
    public func getUInt16() -> UInt16 {
        return order.toNative(getBits())
    }
    
    public func getUInt32() -> UInt32 {
        return order.toNative(getBits())
    }
    
    public func getUInt64() -> UInt64 {
        return order.toNative(getBits())
    }
    
    public func getFloat32() -> Float32 {
        UnsafeMutablePointer<UInt32>(bits).memory = getUInt32()
        return UnsafePointer<Float32>(bits).memory
    }
    
    public func getFloat64() -> Float64 {
        UnsafeMutablePointer<UInt64>(bits).memory = getUInt64()
        return UnsafePointer<Float64>(bits).memory
    }
    
    public func getUTF8(length: Int) -> String {
        return decodeCodeUnits(getUInt8(length), codec: UTF8())
    }
    
    public func getTerminatedUTF8(terminator: UInt8 = 0) -> String {
        return decodeCodeUnits(getTerminatedUInt8(terminator), codec: UTF8())
    }
    
    public func decodeCodeUnits<C : UnicodeCodecType>(codeUnits: [C.CodeUnit], var codec: C) -> String {
        var generator = codeUnits.generate()
        var characters = [Character]()
        characters.reserveCapacity(codeUnits.count)
        var done = false
        
        while (!done) {
            switch codec.decode(&generator) {
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
    
    public func getInt8(count: Int) -> [Int8] {
        return getArray(count, defaultValue: 0) { self.getInt8() }
    }
    
    public func getInt16(count: Int) -> [Int16] {
        return getArray(count, defaultValue: 0) { self.getInt16() }
    }
    
    public func getInt32(count: Int) -> [Int32] {
        return getArray(count, defaultValue: 0) { self.getInt32() }
    }
    
    public func getInt64(count: Int) -> [Int64] {
        return getArray(count, defaultValue: 0) { self.getInt64() }
    }
    
    public func getUInt8(count: Int) -> [UInt8] {
        return getArray(count, defaultValue: 0) { self.getUInt8() }
    }
    
    public func getUInt16(count: Int) -> [UInt16] {
        return getArray(count, defaultValue: 0) { self.getUInt16() }
    }
    
    public func getUInt32(count: Int) -> [UInt32] {
        return getArray(count, defaultValue: 0) { self.getUInt32() }
    }
    
    public func getUInt64(count: Int) -> [UInt64] {
        return getArray(count, defaultValue: 0) { self.getUInt64() }
    }
    
    public func getFloat32(count: Int) -> [Float32] {
        return getArray(count, defaultValue: 0.0) { self.getFloat32() }
    }
    
    public func getFloat64(count: Int) -> [Float64] {
        return getArray(count, defaultValue: 0.0) { self.getFloat64() }
    }
    
    public func getArray<T>(count: Int, defaultValue: T, getter: () -> T) -> [T] {
        var array = [T](count: count, repeatedValue: defaultValue)
        for index in 0..<count { array[index] = getter() }
        return array
    }
    
    public func getArray<T>(count: Int, getter: () -> T) -> [T] {
        var array = [T]()
        array.reserveCapacity(count)
        for _ in 0..<count { array.append(getter()) }
        return array
    }
    
    public func getTerminatedUInt8(terminator: UInt8) -> [UInt8] {
        return getArray(terminator) { self.getUInt8() }
    }
    
    public func getArray<T : Equatable>(terminator: T, @noescape getter: () -> T) -> [T] {
        var array = [T]()
        var done = true
        
        while (!done) {
            let value = getter()
            
            if (value == terminator) {
                done = true
            } else {
                array.append(value)
            }
        }
        
        return array
    }
    
    public func getBits<T : Bufferable>() -> T {
        for index in 0..<strideof(T) {
            bits[index] = bytes[position++]
        }
        
        return UnsafePointer<T>(bits).memory
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
        bytes[position++] = value
    }
    
    public func putUInt16(value: UInt16) {
        putBits(order.fromNative(value))
    }
    
    public func putUInt32(value: UInt32) {
        putBits(order.fromNative(value))
    }
    
    public func putUInt64(value: UInt64) {
        putBits(order.fromNative(value))
    }
    
    public func putFloat32(value: Float32) {
        UnsafeMutablePointer<Float32>(bits).memory = value
        putUInt32(UnsafePointer<UInt32>(bits).memory)
    }
    
    public func putFloat64(value: Float64) {
        UnsafeMutablePointer<Float64>(bits).memory = value
        putUInt64(UnsafePointer<UInt64>(bits).memory)
    }
    
    public func putUTF8(value: String) {
        putArray(value.utf8) { self.putUInt8($0) }
    }
    
    public func putInt8(values: [Int8]) {
        putArray(values) { self.putInt8($0) }
    }
    
    public func putInt16(values: [Int16]) {
        putArray(values) { self.putInt16($0) }
    }
    
    public func putInt32(values: [Int32]) {
        putArray(values) { self.putInt32($0) }
    }
    
    public func putInt64(values: [Int64]) {
        putArray(values) { self.putInt64($0) }
    }
    
    public func putUInt8(source: [UInt8]) {
        putUInt8(source, offset: 0, length: source.count)
    }
    
    public func putUInt8(source: [UInt8], offset: Int, length: Int) {
        if (length > remaining) {
            fatalError("Buffer overflow")
        }
        
        let destination = bytes + position
        destination.initializeFrom(source[offset..<offset+length])
        position += length
    }
    
    public func putUInt16(values: [UInt16]) {
        putArray(values) { self.putUInt16($0) }
    }
    
    public func putUInt32(values: [UInt32]) {
        putArray(values) { self.putUInt32($0) }
    }
    
    public func putUInt64(values: [UInt64]) {
        putArray(values) { self.putUInt64($0) }
    }
    
    public func putFloat32(values: [Float32]) {
        putArray(values) { self.putFloat32($0) }
    }
    
    public func putFloat64(values: [Float64]) {
        putArray(values) { self.putFloat64($0) }
    }
    
    public func putTerminatedUTF8(value: String, terminator: UInt8 = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    public func putArray<S : SequenceType>(values: S, @noescape putter: (S.Generator.Element) -> ()) {
        for value in values {
            putter(value)
        }
    }
    
    public func putBits<T : Bufferable>(value: T) {
        UnsafeMutablePointer<T>(bits).memory = value
        
        for index in 0..<strideof(T) {
            bytes[position++] = bits[index]
        }
    }
    
    public subscript(subRange: Range<Int>) -> ByteBuffer {
        let length = subRange.endIndex - subRange.startIndex
        return ByteBuffer(order: order, data: bytes + subRange.startIndex, capacity: length, freeOnDeinit: false)
    }
    
    public func putBuffer(buffer: ByteBuffer) {
        let count = buffer.remaining
        let offset = bytes + position
        offset.initializeFrom(buffer.bytes + buffer.position, count: count)
        position += count
        buffer.position += count
    }
}

public protocol Bufferable { }

extension Float32 : Bufferable { }
extension Float64 : Bufferable { }
extension Int8 : Bufferable { }
extension Int16 : Bufferable { }
extension Int32 : Bufferable { }
extension Int64 : Bufferable { }
extension UInt8 : Bufferable { }
extension UInt16 : Bufferable { }
extension UInt32 : Bufferable { }
extension UInt64 : Bufferable { }
