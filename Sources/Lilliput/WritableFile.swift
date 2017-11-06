/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Justin Kolb
 
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

public protocol WritableFile {
    func write(from buffer: UnsafeRawPointer, count: Int) throws -> Int
    
    func setEndOfFile(position: Int) throws
}

extension WritableFile {
    public func write(from buffer: ByteBuffer, count: Int) throws -> Int {
        precondition(count <= buffer.count)
        return try write(from: buffer.bytes, count: count)
    }
    
    public func write(from buffer: ByteBuffer) throws -> Int {
        return try write(from: buffer, count: buffer.count)
    }

    public func write<Order>(from buffer: OrderedByteBuffer<Order>, count: Int) throws -> Int {
        precondition(count <= buffer.remainingCount)
        let writeCount = try write(from: buffer.remainingBytes, count: count)
        buffer.position += writeCount
        return writeCount
    }
    
    public func write<Order>(from buffer: OrderedByteBuffer<Order>) throws -> Int {
        return try write(from: buffer, count: buffer.remainingCount)
    }
}
