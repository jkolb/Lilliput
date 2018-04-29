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

public final class OrderedInputStream<Order : ByteOrder> : ByteInputStream {
    public let stream: ByteInputStream
    
    public init(stream: ByteInputStream) {
        self.stream = stream
    }

    @inline(__always) public func readUInt8()  throws -> UInt8  { return try stream.readUInt8() }
    @inline(__always) public func readUInt16() throws -> UInt16 { return Order.swapOrderUInt16(try stream.readUInt16()) }
    @inline(__always) public func readUInt32() throws -> UInt32 { return Order.swapOrderUInt32(try stream.readUInt32()) }
    @inline(__always) public func readUInt64() throws -> UInt64 { return Order.swapOrderUInt64(try stream.readUInt64()) }
    @inline(__always) public func read(bytes: UnsafeMutableRawPointer, count: Int) throws { try stream.read(bytes: bytes, count: count) }
}
