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

extension UnsafeRawPointer {
    @_transparent
    public func loadUnalignedUInt16(fromByteOffset offset: Int = 0) -> UInt16 {
        var value: UInt16 = 0
        UnsafeMutableRawPointer(&value).copyMemory(from: (self + offset), byteCount: MemoryLayout<UInt16>.size)
        return value
    }
    
    @_transparent
    public func loadUnalignedUInt32(fromByteOffset offset: Int = 0) -> UInt32 {
        var value: UInt32 = 0
        UnsafeMutableRawPointer(&value).copyMemory(from: (self + offset), byteCount: MemoryLayout<UInt32>.size)
        return value
    }
    
    @_transparent
    public func loadUnalignedUInt64(fromByteOffset offset: Int = 0) -> UInt64 {
        var value: UInt64 = 0
        UnsafeMutableRawPointer(&value).copyMemory(from: (self + offset), byteCount: MemoryLayout<UInt64>.size)
        return value
    }
}

extension UnsafeMutableRawPointer {
    @_transparent
    public func loadUnalignedUInt16(fromByteOffset offset: Int = 0) -> UInt16 {
        var value: UInt16 = 0
        UnsafeMutableRawPointer(&value).copyMemory(from: (self + offset), byteCount: MemoryLayout<UInt16>.size)
        return value
    }
    
    @_transparent
    public func loadUnalignedUInt32(fromByteOffset offset: Int = 0) -> UInt32 {
        var value: UInt32 = 0
        UnsafeMutableRawPointer(&value).copyMemory(from: (self + offset), byteCount: MemoryLayout<UInt32>.size)
        return value
    }
    
    @_transparent
    public func loadUnalignedUInt64(fromByteOffset offset: Int = 0) -> UInt64 {
        var value: UInt64 = 0
        UnsafeMutableRawPointer(&value).copyMemory(from: (self + offset), byteCount: MemoryLayout<UInt64>.size)
        return value
    }

    @_transparent
    public func storeUnalignedUInt16(_ value: UInt16, toByteOffset offset: Int = 0) {
        var value: UInt16 = value
        (self + offset).copyMemory(from: &value, byteCount: MemoryLayout<UInt16>.size)
    }

    @_transparent
    public func storeUnalignedUInt32(_ value: UInt32, toByteOffset offset: Int = 0) {
        var value: UInt32 = value
        (self + offset).copyMemory(from: &value, byteCount: MemoryLayout<UInt32>.size)
    }

    @_transparent
    public func storeUnalignedUInt64(_ value: UInt64, toByteOffset offset: Int = 0) {
        var value: UInt64 = value
        (self + offset).copyMemory(from: &value, byteCount: MemoryLayout<UInt64>.size)
    }
}
