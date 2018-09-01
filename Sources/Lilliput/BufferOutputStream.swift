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

public final class BufferOutputStream : ByteOutputStream {
    public let buffer: ByteBuffer
    public private(set) var offset: Int
    
    public init(buffer: ByteBuffer) {
        self.buffer = buffer
        self.offset = 0
    }
    
    public var bytesWritten: Int {
        @inline(__always) get {
            return offset
        }
    }
    
    @inline(__always)
    public func skip(count: Int) throws {
        offset += count
    }

    public var remainingBytes: UnsafeMutableRawPointer {
        @inline(__always)
        get {
            return buffer.bytes + offset
        }
    }
    
    public var remainingCount: Int {
        @inline(__always)
        get {
            return buffer.count - offset
        }
    }

    @inline(__always)
    public func writeUInt8(_ value: UInt8) throws {
        buffer.putUInt8(value, at: offset)
        offset += MemoryLayout<UInt8>.size
    }
    
    @inline(__always)
    public func writeUInt16(_ value: UInt16) throws {
        buffer.putUInt16(value, at: offset)
        offset += MemoryLayout<UInt16>.size
    }
    
    @inline(__always)
    public func writeUInt32(_ value: UInt32) throws {
        buffer.putUInt32(value, at: offset)
        offset += MemoryLayout<UInt32>.size
    }
    
    @inline(__always)
    public func writeUInt64(_ value: UInt64) throws {
        buffer.putUInt64(value, at: offset)
        offset += MemoryLayout<UInt64>.size
    }
    
    @inline(__always)
    public func write(bytes: UnsafeRawPointer, count: Int) throws {
        buffer.put(bytes: bytes, count: count, at: offset)
        offset += count
    }
}
