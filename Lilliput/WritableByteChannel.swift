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

public protocol WritableByteChannel : class {
    @warn_unused_result
    func writeData(data: UnsafeMutablePointer<Void>, numberOfBytes: Int) throws -> Int
}

extension WritableByteChannel {
    @warn_unused_result
    public func writeBuffer(buffer: Buffer) throws -> Int {
        return try writeBuffer(buffer, numberOfBytes: buffer.size)
    }
    
    @warn_unused_result
    public func writeBuffer(buffer: Buffer, numberOfBytes: Int) throws -> Int {
        precondition(numberOfBytes <= buffer.size)
        return try writeData(buffer.data, numberOfBytes: numberOfBytes)
    }
    
    @warn_unused_result
    public func writeByteBuffer<Order: ByteOrder>(buffer: ByteBuffer<Order>) throws -> Int {
        return try writeByteBuffer(buffer, numberOfBytes: buffer.remaining)
    }
    
    @warn_unused_result
    public func writeByteBuffer<Order: ByteOrder>(buffer: ByteBuffer<Order>, numberOfBytes: Int) throws -> Int {
        precondition(numberOfBytes <= buffer.remaining)
        let bytesWritten = try writeData(buffer.remainingData, numberOfBytes: numberOfBytes)
        buffer.position += bytesWritten
        return bytesWritten
    }
}
