//
// ByteBuffer.swift
// Lilliput
//
// Copyright (c) 2014 Justin Kolb - https://github.com/jkolb/Lilliput
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

class ByteBuffer {
    let order: ByteOrder
    var data: UnsafePointer<UInt8>
    let freeOnDeinit: Bool
    let capacity: Int
    let bits = UnsafePointer<UInt8>.alloc(sizeof(UIntMax))
    var privatePosition = 0
    var privateLimit = 0
    var privateMark = -1
    
    init(order: ByteOrder, data: UnsafePointer<UInt8>, capacity: Int, freeOnDeinit: Bool) {
        assert(capacity >= 0)
        self.order = order
        self.data = data
        self.capacity = capacity
        self.freeOnDeinit = freeOnDeinit
        self.limit = capacity
    }
    
    convenience init(order: ByteOrder, capacity: Int) {
        self.init(order: order, data: UnsafePointer<UInt8>.alloc(capacity), capacity: capacity, freeOnDeinit: true)
    }

    deinit {
        bits.dealloc(sizeof(UIntMax))
        if freeOnDeinit { data.dealloc(capacity) }
    }
    
    var limit: Int {
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
    
    var position: Int {
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
    
    var hasRemaining: Bool {
    return remaining > 0
    }
    
    var remaining: Int {
    return limit - position
    }
    
    func mark() {
        privateMark = position
    }

    func reset() {
        if (privateMark == -1) {
            fatalError("Invalid mark")
        }
        position = privateMark
    }
    
    func rewind() {
        position = 0
        privateMark = -1
    }
    
    func clear() {
        rewind()
        limit = capacity
    }
    
    func flip() {
        privateLimit = privatePosition
        privatePosition = 0
        privateMark = -1
    }
    
    func compact() {
        data.moveInitializeFrom(data+position, count: remaining)
        position = remaining
        limit = capacity
    }

    func getInt8() -> Int8 {
        return getUInt8().asSigned()
    }
    
    func getInt16() -> Int16 {
        return getUInt16().asSigned()
    }
    
    func getInt32() -> Int32 {
        return getUInt32().asSigned()
    }
    
    func getInt64() -> Int64 {
        return getUInt64().asSigned()
    }
    
    func getUInt8() -> UInt8 {
        return data[position++]
    }

    func getUInt16() -> UInt16 {
        return order.toNative(getBits())
    }
    
    func getUInt32() -> UInt32 {
        return order.toNative(getBits())
    }
    
    func getUInt64() -> UInt64 {
        return order.toNative(getBits())
    }
    
    func getFloat32() -> Float32 {
        UnsafePointer<UInt32>(bits).memory = getUInt32()
        return UnsafePointer<Float32>(bits).memory
    }
    
    func getFloat64() -> Float64 {
        UnsafePointer<UInt64>(bits).memory = getUInt64()
        return UnsafePointer<Float64>(bits).memory
    }
    
    func getUTF8(length: Int) -> String {
        return decodeCodeUnits(getUInt8(length), codec: UTF8())
    }
    
    func getTerminatedUTF8(terminator: UInt8 = 0) -> String {
        return decodeCodeUnits(getTerminatedUInt8(terminator), codec: UTF8())
    }

    func decodeCodeUnits<C : UnicodeCodec>(codeUnits: Array<C.CodeUnit>, var codec: C) -> String {
        var generator = codeUnits.generate()
        var characters = Array<Character>()
        characters.reserveCapacity(codeUnits.count)
        var done = false
        
        while (!done) {
            switch codec.decode(&generator) {
            case .Result(let scalar):
                characters += Character(scalar)
                
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
    
    func getInt8(count: Int) -> Array<Int8> {
        return getArray(count, defaultValue: 0) { self.getInt8() }
    }
    
    func getInt16(count: Int) -> Array<Int16> {
        return getArray(count, defaultValue: 0) { self.getInt16() }
    }
    
    func getInt32(count: Int) -> Array<Int32> {
        return getArray(count, defaultValue: 0) { self.getInt32() }
    }
    
    func getInt64(count: Int) -> Array<Int64> {
        return getArray(count, defaultValue: 0) { self.getInt64() }
    }
    
    func getUInt8(count: Int) -> Array<UInt8> {
        return getArray(count, defaultValue: 0) { self.getUInt8() }
    }
    
    func getUInt16(count: Int) -> Array<UInt16> {
        return getArray(count, defaultValue: 0) { self.getUInt16() }
    }
    
    func getUInt32(count: Int) -> Array<UInt32> {
        return getArray(count, defaultValue: 0) { self.getUInt32() }
    }
    
    func getUInt64(count: Int) -> Array<UInt64> {
        return getArray(count, defaultValue: 0) { self.getUInt64() }
    }
    
    func getFloat32(count: Int) -> Array<Float32> {
        return getArray(count, defaultValue: 0.0) { self.getFloat32() }
    }
    
    func getFloat64(count: Int) -> Array<Float64> {
        return getArray(count, defaultValue: 0.0) { self.getFloat64() }
    }
    
    func getArray<T>(count: Int, defaultValue: T, getter: () -> T) -> Array<T> {
        var array = Array<T>(count: count, repeatedValue: defaultValue)
        
        for index in 0..<count {
            array[index] = getter()
        }
        
        return array
    }
    
    func getTerminatedUInt8(terminator: UInt8) -> Array<UInt8> {
        return getArray(terminator) { self.getUInt8() }
    }
    
    func getArray<T : Equatable>(terminator: T, getter: () -> T) -> Array<T> {
        var array = Array<T>()
        var done = true
        
        while (!done) {
            let value = getter()
            
            if (value == terminator) {
                done = true
            } else {
                array += value
            }
        }
        
        return array
    }

    func getBits<T>() -> T {
        for index in 0..<sizeof(T) {
            bits[index] = data[position++]
        }
        
        return UnsafePointer<T>(bits).memory
    }
    
    func putInt8(value: Int8) {
        putUInt8(value.asUnsigned())
    }
    
    func putInt16(value: Int16) {
        putUInt16(value.asUnsigned())
    }
    
    func putInt32(value: Int32) {
        putUInt32(value.asUnsigned())
    }
    
    func putInt64(value: Int64) {
        putUInt64(value.asUnsigned())
    }
    
    func putUInt8(value: UInt8) {
        data[position++] = value
    }
    
    func putUInt16(value: UInt16) {
        putBits(order.fromNative(value))
    }
    
    func putUInt32(value: UInt32) {
        putBits(order.fromNative(value))
    }
    
    func putUInt64(value: UInt64) {
        putBits(order.fromNative(value))
    }
    
    func putFloat32(value: Float32) {
        UnsafePointer<Float32>(bits).memory = value
        putUInt32(UnsafePointer<UInt32>(bits).memory)
    }
    
    func putFloat64(value: Float64) {
        UnsafePointer<Float64>(bits).memory = value
        putUInt64(UnsafePointer<UInt64>(bits).memory)
    }
    
    func putUTF8(value: String) {
        putArray(value.utf8) { self.putUInt8($0) }
    }

    func putInt8(values: Array<Int8>) {
        putArray(values) { self.putInt8($0) }
    }
    
    func putInt16(values: Array<Int16>) {
        putArray(values) { self.putInt16($0) }
    }
    
    func putInt32(values: Array<Int32>) {
        putArray(values) { self.putInt32($0) }
    }
    
    func putInt64(values: Array<Int64>) {
        putArray(values) { self.putInt64($0) }
    }
    
    func putUInt8(source: Array<UInt8>) {
        putUInt8(source, offset: 0, length: source.count)
    }
    
    func putUInt8(source: Array<UInt8>, offset: Int, length: Int) {
        if (length > remaining) {
            fatalError("Buffer overflow")
        }
        
        let destination = data + position
        destination.initializeFrom(source[offset..<offset+length])
        position += length
    }
    
    func putUInt16(values: Array<UInt16>) {
        putArray(values) { self.putUInt16($0) }
    }
    
    func putUInt32(values: Array<UInt32>) {
        putArray(values) { self.putUInt32($0) }
    }
    
    func putUInt64(values: Array<UInt64>) {
        putArray(values) { self.putUInt64($0) }
    }
    
    func putFloat32(values: Array<Float32>) {
        putArray(values) { self.putFloat32($0) }
    }
    
    func putFloat64(values: Array<Float64>) {
        putArray(values) { self.putFloat64($0) }
    }
    
    func putTerminatedUTF8(value: String, terminator: UInt8 = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    func putArray<S : Sequence>(values: S, putter: (S.GeneratorType.Element) -> ()) {
        for value in values {
            putter(value)
        }
    }
    
    func putBits<T>(value: T) {
        UnsafePointer<T>(bits).memory = value
        
        for index in 0..<sizeof(T) {
            data[position++] = bits[index]
        }
    }
    
    subscript(subRange: Range<Int>) -> ByteBuffer {
        let length = subRange.endIndex - subRange.startIndex + 1
        return ByteBuffer(order: order, data: data + subRange.startIndex, capacity: length, freeOnDeinit: false)
    }
    
    func putBuffer(buffer: ByteBuffer) {
        let count = buffer.remaining
        data.initializeFrom(buffer.data + buffer.position, count: count)
        position += count
        buffer.position += count
    }
}
