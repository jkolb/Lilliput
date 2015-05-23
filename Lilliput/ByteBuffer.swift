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

public class ByteBuffer {
    public var order: ByteOrder
    var data: UnsafeMutablePointer<UInt8>
    private let freeOnDeinit: Bool
    public let capacity: Int
    private let bits = UnsafeMutablePointer<UInt8>.alloc(sizeof(UIntMax))
    private var privatePosition = 0
    private var privateLimit = 0
    private var privateMark = -1
    
    public init(order: ByteOrder, data: UnsafeMutablePointer<UInt8>, capacity: Int, freeOnDeinit: Bool) {
        assert(capacity >= 0)
        self.order = order
        self.data = data
        self.capacity = capacity
        self.freeOnDeinit = freeOnDeinit
        self.limit = capacity
    }
    
    public convenience init(order: ByteOrder, capacity: Int) {
        self.init(order: order, data: UnsafeMutablePointer<UInt8>.alloc(capacity), capacity: capacity, freeOnDeinit: true)
    }
    
    deinit {
        bits.dealloc(sizeof(UIntMax))
        if freeOnDeinit { data.dealloc(capacity) }
    }
    
    public var limit: Int {
        get {
            return privateLimit
        }
        set {
            if (newValue < 0 || newValue > capacity) {
                fatalError("Illegal limit")
            }
            privateLimit = newValue
            
            if (privatePosition > privateLimit) {
                privatePosition = privateLimit
            }
            
            if (privateMark > privateLimit) {
                privateMark = -1
            }
        }
    }
    
    public var position: Int {
        get {
            return privatePosition
        }
        set {
            if (newValue < 0 || newValue > limit) {
                fatalError("Illegal position")
            }
            privatePosition = newValue
            
            if (privateMark > privatePosition) {
                privateMark = -1
            }
        }
    }
    
    public var hasRemaining: Bool {
        return remaining > 0
    }
    
    public var remaining: Int {
        return limit - position
    }
    
    public func mark() {
        privateMark = position
    }
    
    public func reset() {
        if (privateMark == -1) {
            fatalError("Invalid mark")
        }
        position = privateMark
    }
    
    public func rewind() {
        position = 0
        privateMark = -1
    }
    
    public func clear() {
        rewind()
        limit = capacity
    }
    
    public func flip() {
        privateLimit = privatePosition
        privatePosition = 0
        privateMark = -1
    }
    
    public func compact() {
        data.moveInitializeFrom(data+position, count: remaining)
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
        return data[position++]
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
    
    public func decodeCodeUnits<C : UnicodeCodecType>(codeUnits: Array<C.CodeUnit>, var codec: C) -> String {
        var generator = codeUnits.generate()
        var characters = Array<Character>()
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
        
        var string = String()
        string.reserveCapacity(characters.count)
        string.extend(characters)
        
        return string
    }
    
    public func getInt8(count: Int) -> Array<Int8> {
        return getArray(count, defaultValue: 0) { self.getInt8() }
    }
    
    public func getInt16(count: Int) -> Array<Int16> {
        return getArray(count, defaultValue: 0) { self.getInt16() }
    }
    
    public func getInt32(count: Int) -> Array<Int32> {
        return getArray(count, defaultValue: 0) { self.getInt32() }
    }
    
    public func getInt64(count: Int) -> Array<Int64> {
        return getArray(count, defaultValue: 0) { self.getInt64() }
    }
    
    public func getUInt8(count: Int) -> Array<UInt8> {
        return getArray(count, defaultValue: 0) { self.getUInt8() }
    }
    
    public func getUInt16(count: Int) -> Array<UInt16> {
        return getArray(count, defaultValue: 0) { self.getUInt16() }
    }
    
    public func getUInt32(count: Int) -> Array<UInt32> {
        return getArray(count, defaultValue: 0) { self.getUInt32() }
    }
    
    public func getUInt64(count: Int) -> Array<UInt64> {
        return getArray(count, defaultValue: 0) { self.getUInt64() }
    }
    
    public func getFloat32(count: Int) -> Array<Float32> {
        return getArray(count, defaultValue: 0.0) { self.getFloat32() }
    }
    
    public func getFloat64(count: Int) -> Array<Float64> {
        return getArray(count, defaultValue: 0.0) { self.getFloat64() }
    }
    
    public func getArray<T>(count: Int, defaultValue: T, getter: () -> T) -> Array<T> {
        var array = Array<T>(count: count, repeatedValue: defaultValue)
        for index in 0..<count { array[index] = getter() }
        return array
    }
    
    public func getArray<T>(count: Int, getter: () -> T) -> Array<T> {
        var array = Array<T>()
        array.reserveCapacity(count)
        for index in 0..<count { array.append(getter()) }
        return array
    }
    
    public func getTerminatedUInt8(terminator: UInt8) -> Array<UInt8> {
        return getArray(terminator) { self.getUInt8() }
    }
    
    public func getArray<T : Equatable>(terminator: T, getter: () -> T) -> Array<T> {
        var array = Array<T>()
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
    
    public func getBits<T>() -> T {
        for index in 0..<sizeof(T) {
            bits[index] = data[position++]
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
        data[position++] = value
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
    
    public func putInt8(values: Array<Int8>) {
        putArray(values) { self.putInt8($0) }
    }
    
    public func putInt16(values: Array<Int16>) {
        putArray(values) { self.putInt16($0) }
    }
    
    public func putInt32(values: Array<Int32>) {
        putArray(values) { self.putInt32($0) }
    }
    
    public func putInt64(values: Array<Int64>) {
        putArray(values) { self.putInt64($0) }
    }
    
    public func putUInt8(source: Array<UInt8>) {
        putUInt8(source, offset: 0, length: source.count)
    }
    
    public func putUInt8(source: Array<UInt8>, offset: Int, length: Int) {
        if (length > remaining) {
            fatalError("Buffer overflow")
        }
        
        let destination = data + position
        destination.initializeFrom(source[offset..<offset+length])
        position += length
    }
    
    public func putUInt16(values: Array<UInt16>) {
        putArray(values) { self.putUInt16($0) }
    }
    
    public func putUInt32(values: Array<UInt32>) {
        putArray(values) { self.putUInt32($0) }
    }
    
    public func putUInt64(values: Array<UInt64>) {
        putArray(values) { self.putUInt64($0) }
    }
    
    public func putFloat32(values: Array<Float32>) {
        putArray(values) { self.putFloat32($0) }
    }
    
    public func putFloat64(values: Array<Float64>) {
        putArray(values) { self.putFloat64($0) }
    }
    
    public func putTerminatedUTF8(value: String, terminator: UInt8 = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    public func putArray<S : SequenceType>(values: S, putter: (S.Generator.Element) -> ()) {
        for value in values {
            putter(value)
        }
    }
    
    public func putBits<T>(value: T) {
        UnsafeMutablePointer<T>(bits).memory = value
        
        for index in 0..<sizeof(T) {
            data[position++] = bits[index]
        }
    }
    
    public subscript(subRange: Range<Int>) -> ByteBuffer {
        let length = subRange.endIndex - subRange.startIndex
        return ByteBuffer(order: order, data: data + subRange.startIndex, capacity: length, freeOnDeinit: false)
    }
    
    public func putBuffer(buffer: ByteBuffer) {
        let count = buffer.remaining
        let offset = data + position
        offset.initializeFrom(buffer.data + buffer.position, count: count)
        position += count
        buffer.position += count
    }
}
