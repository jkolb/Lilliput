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
    let capacity: Int
    let bits = UnsafePointer<UInt8>.alloc(sizeof(UIntMax))
    var privatePosition = 0
    var privateLimit = 0
    var privateMark = -1
    
    init(order: ByteOrder, capacity: Int) {
        self.order = order
        self.capacity = capacity
        self.data = UnsafePointer<UInt8>.alloc(capacity)
        
        self.limit = capacity
    }

    deinit {
        data.dealloc(capacity)
        bits.dealloc(sizeof(UIntMax))
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
    
    func put(source: Array<UInt8>) {
        put(source, offset: 0, length: source.count)
    }
    
    func put(source: Array<UInt8>, offset: Int, length: Int) {
        if (length > remaining) {
            fatalError("Buffer overflow")
        }

        let destination = data + position
        destination.initializeFrom(source[offset..<offset+length])
        position += length
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
        return order.toNative(readBytes())
    }
    
    func getUInt24() -> UInt32 {
        return order.toNative(readBytes())
    }
    
    func getUInt32() -> UInt32 {
        return order.toNative(readBytes())
    }
    
    func getUInt64() -> UInt64 {
        return order.toNative(readBytes())
    }
    
    func getFloat32() -> Float32 {
        UnsafePointer<UInt32>(bits).memory = getUInt32()
        return UnsafePointer<Float32>(bits).memory
    }
    
    func getFloat64() -> Float64 {
        UnsafePointer<UInt64>(bits).memory = getUInt64()
        return UnsafePointer<Float64>(bits).memory
    }
    
    func readBytes<T>() -> T {
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
        writeBytes(order.fromNative(value))
    }
    
    func putUInt32(value: UInt32) {
        writeBytes(order.fromNative(value))
    }
    
    func putUInt64(value: UInt64) {
        writeBytes(order.fromNative(value))
    }
    
    func putFloat32(value: Float32) {
        UnsafePointer<Float32>(bits).memory = value
        putUInt32(UnsafePointer<UInt32>(bits).memory)
    }
    
    func putFloat64(value: Float64) {
        UnsafePointer<Float64>(bits).memory = value
        putUInt64(UnsafePointer<UInt64>(bits).memory)
    }
    
    func writeBytes<T>(value: T) {
        UnsafePointer<T>(bits).memory = value
        
        for index in 0..<sizeof(T) {
            data[position++] = bits[index]
        }
    }
}
