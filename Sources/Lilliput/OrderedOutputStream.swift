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

public final class OrderedOutputStream<Order : ByteOrder> : ByteOutputStream {
    public let stream: ByteOutputStream
    
    public init(stream: ByteOutputStream) {
        self.stream = stream
    }

    @inline(__always) public func writeUInt8 (_ value: UInt8 ) throws { try stream.writeUInt8(value) }
    @inline(__always) public func writeUInt16(_ value: UInt16) throws { try stream.writeUInt16(Order.swapOrderUInt16(value)) }
    @inline(__always) public func writeUInt32(_ value: UInt32) throws { try stream.writeUInt32(Order.swapOrderUInt32(value)) }
    @inline(__always) public func writeUInt64(_ value: UInt64) throws { try stream.writeUInt64(Order.swapOrderUInt64(value)) }
    @inline(__always) public func write(bytes: UnsafeRawPointer, count: Int) throws { try stream.write(bytes: bytes, count: count) }
}
