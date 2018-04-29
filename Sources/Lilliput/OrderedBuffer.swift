/*
 The MIT License (MIT)
 
 Copyright (c) 2018 Justin Kolb
 
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

public final class OrderedBuffer<Order : ByteOrder> : ByteBuffer {
    public let buffer: ByteBuffer
    
    public init(buffer: ByteBuffer) {
        self.buffer = buffer
    }

    public convenience init(count: Int) {
        self.init(buffer: MemoryBuffer(count: count))
    }
    
    public var bytes: UnsafeMutableRawPointer {
        @inline(__always)
        get {
            return buffer.bytes
        }
    }
    
    public var count: Int {
        @inline(__always)
        get {
            return buffer.count
        }
    }
    
    @inline(__always) public func getUInt16(at offset: Int) -> UInt16 { return Order.swapOrderUInt16(buffer.getUInt16(at: offset)) }
    @inline(__always) public func getUInt32(at offset: Int) -> UInt32 { return Order.swapOrderUInt32(buffer.getUInt32(at: offset)) }
    @inline(__always) public func getUInt64(at offset: Int) -> UInt64 { return Order.swapOrderUInt64(buffer.getUInt64(at: offset)) }

    @inline(__always) public func putUInt16(_ value: UInt16, at offset: Int) { buffer.putUInt16(Order.swapOrderUInt16(value), at: offset) }
    @inline(__always) public func putUInt32(_ value: UInt32, at offset: Int) { buffer.putUInt32(Order.swapOrderUInt32(value), at: offset) }
    @inline(__always) public func putUInt64(_ value: UInt64, at offset: Int) { buffer.putUInt64(Order.swapOrderUInt64(value), at: offset) }
}
