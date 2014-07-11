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
    let buffer: UnsafePointer<UInt8>
    let length: Int
    let bits = UnsafePointer<UInt8>.alloc(sizeof(UIntMax))
    var offset = 0
    
    init(order: ByteOrder, length: Int) {
        self.order = order
        self.length = length
        self.buffer = UnsafePointer<UInt8>.alloc(length)
    }

    deinit {
        buffer.dealloc(length)
        bits.dealloc(sizeof(UIntMax))
    }
    
    func nextInt8() -> Int8 {
        return nextUInt8().asSigned()
    }
    
    func nextInt16() -> Int16 {
        return nextUInt16().asSigned()
    }
    
    func nextInt32() -> Int32 {
        return nextUInt32().asSigned()
    }
    
    func nextInt64() -> Int64 {
        return nextUInt64().asSigned()
    }
    
    func nextUInt8() -> UInt8 {
        return buffer[offset++]
    }

    func nextUInt16() -> UInt16 {
        return order.toNative(readBytes())
    }
    
    func nextUInt24() -> UInt32 {
        return order.toNative(readBytes())
    }
    
    func nextUInt32() -> UInt32 {
        return order.toNative(readBytes())
    }
    
    func nextUInt64() -> UInt64 {
        return order.toNative(readBytes())
    }
    
    func nextFloat32() -> Float32 {
        UnsafePointer<UInt32>(bits).memory = nextUInt32()
        return UnsafePointer<Float32>(bits).memory
    }
    
    func nextFloat64() -> Float64 {
        UnsafePointer<UInt64>(bits).memory = nextUInt64()
        return UnsafePointer<Float64>(bits).memory
    }
    
    func readBytes<T>() -> T {
        for index in 0..<sizeof(T) {
            bits[index] = buffer[offset++]
        }
        
        return UnsafePointer<T>(bits).memory
    }
    
    func nextInt8(value: Int8) {
        nextUInt8(value.asUnsigned())
    }
    
    func nextInt16(value: Int16) {
        nextUInt16(value.asUnsigned())
    }
    
    func nextInt32(value: Int32) {
        nextUInt32(value.asUnsigned())
    }
    
    func nextInt64(value: Int64) {
        nextUInt64(value.asUnsigned())
    }
    
    func nextUInt8(value: UInt8) {
        buffer[offset++] = value
    }
    
    func nextUInt16(value: UInt16) {
        writeBytes(order.fromNative(value))
    }
    
    func nextUInt32(value: UInt32) {
        writeBytes(order.fromNative(value))
    }
    
    func nextUInt64(value: UInt64) {
        writeBytes(order.fromNative(value))
    }
    
    func nextFloat32(value: Float32) {
        UnsafePointer<Float32>(bits).memory = value
        nextUInt32(UnsafePointer<UInt32>(bits).memory)
    }
    
    func nextFloat64(value: Float64) {
        UnsafePointer<Float64>(bits).memory = value
        nextUInt64(UnsafePointer<UInt64>(bits).memory)
    }
    
    func writeBytes<T>(value: T) {
        UnsafePointer<T>(bits).memory = value
        
        for index in 0..<sizeof(T) {
            buffer[offset++] = bits[index]
        }
    }
}
