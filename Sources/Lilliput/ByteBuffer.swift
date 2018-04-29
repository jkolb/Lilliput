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

public protocol ByteBuffer {
    var bytes: UnsafeMutableRawPointer { get }
    var count: Int { get }
}

extension ByteBuffer {
    @_transparent public func getUInt8 (at offset: Int) -> UInt8  { return bytes.load(fromByteOffset: offset, as: UInt8.self) }
    @_transparent public func getUInt16(at offset: Int) -> UInt16 { return bytes.loadUnalignedUInt16(fromByteOffset: offset) }
    @_transparent public func getUInt32(at offset: Int) -> UInt32 { return bytes.loadUnalignedUInt32(fromByteOffset: offset) }
    @_transparent public func getUInt64(at offset: Int) -> UInt64 { return bytes.loadUnalignedUInt64(fromByteOffset: offset) }

    @_transparent public func getInt8 (at offset: Int) -> Int8  { return Int8 (bitPattern: getUInt8 (at: offset)) }
    @_transparent public func getInt16(at offset: Int) -> Int16 { return Int16(bitPattern: getUInt16(at: offset)) }
    @_transparent public func getInt32(at offset: Int) -> Int32 { return Int32(bitPattern: getUInt32(at: offset)) }
    @_transparent public func getInt64(at offset: Int) -> Int64 { return Int64(bitPattern: getUInt64(at: offset)) }

    @_transparent public func getFloat32(at offset: Int) -> Float32 { return Float32(bitPattern: getUInt32(at: offset)) }
    @_transparent public func getFloat64(at offset: Int) -> Float64 { return Float64(bitPattern: getUInt64(at: offset)) }

    @_transparent public func putUInt8 (_ value: UInt8,  at offset: Int) { bytes.storeBytes(of: value, toByteOffset: offset, as: UInt8.self) }
    @_transparent public func putUInt16(_ value: UInt16, at offset: Int) { bytes.storeUnalignedUInt16(value, toByteOffset: offset) }
    @_transparent public func putUInt32(_ value: UInt32, at offset: Int) { bytes.storeUnalignedUInt32(value, toByteOffset: offset) }
    @_transparent public func putUInt64(_ value: UInt64, at offset: Int) { bytes.storeUnalignedUInt64(value, toByteOffset: offset) }

    @_transparent public func putInt8 (_ value: Int8,  at offset: Int) { putUInt8 (UInt8 (bitPattern: value), at: offset) }
    @_transparent public func putInt16(_ value: Int16, at offset: Int) { putUInt16(UInt16(bitPattern: value), at: offset) }
    @_transparent public func putInt32(_ value: Int32, at offset: Int) { putUInt32(UInt32(bitPattern: value), at: offset) }
    @_transparent public func putInt64(_ value: Int64, at offset: Int) { putUInt64(UInt64(bitPattern: value), at: offset) }

    @_transparent public func putFloat32(_ value: Float32, at offset: Int) { putUInt32(value.bitPattern, at: offset) }
    @_transparent public func putFloat64(_ value: Float64, at offset: Int) { putUInt64(value.bitPattern, at: offset) }

    @_transparent
    public func get(bytes: UnsafeMutableRawPointer, count: Int, at offset: Int) {
        precondition(offset + count <= self.count)
        bytes.copyMemory(from: (self.bytes + offset), byteCount: count)
    }
    
    @_transparent
    public func put(bytes: UnsafeRawPointer, count: Int, at offset: Int) {
        precondition(offset + count <= self.count)
        (self.bytes + offset).copyMemory(from: bytes, byteCount: count)
    }
}
