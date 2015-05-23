//
// ByteOrder.swift
// Lilliput
//
// Copyright (c) 2015 Justin Kolb - https://github.com/jkolb/Lilliput
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

public protocol ByteOrder {
    func toNative(value: UInt16) -> UInt16
    func toNative(value: UInt32) -> UInt32
    func toNative(value: UInt64) -> UInt64
    
    func fromNative(value: UInt16) -> UInt16
    func fromNative(value: UInt32) -> UInt32
    func fromNative(value: UInt64) -> UInt64
}

public func nativeOrder() -> ByteOrder {
    if (UInt16(littleEndian: 1) == UInt16(1).littleEndian) {
        return LittleEndian()
    } else if (UInt16(bigEndian: 1) == UInt16(1).bigEndian) {
        return BigEndian()
    } else {
        fatalError("Unknown byte order")
    }
}

public func foreignOrder() -> ByteOrder {
    if (UInt16(littleEndian: 1) == UInt16(1).littleEndian) {
        return BigEndian()
    } else if (UInt16(bigEndian: 1) == UInt16(1).bigEndian) {
        return LittleEndian()
    } else {
        fatalError("Unknown byte order")
    }
}

public struct LittleEndian : ByteOrder {
    public init() { }
    
    public func toNative(value: UInt16) -> UInt16 {
        return UInt16(littleEndian: value)
    }
    
    public func toNative(value: UInt32) -> UInt32 {
        return UInt32(littleEndian: value)
    }
    
    public func toNative(value: UInt64) -> UInt64 {
        return UInt64(littleEndian: value)
    }
    
    public func fromNative(value: UInt16) -> UInt16 {
        return value.littleEndian
    }
    
    public func fromNative(value: UInt32) -> UInt32 {
        return value.littleEndian
    }
    
    public func fromNative(value: UInt64) -> UInt64 {
        return value.littleEndian
    }
}

public struct BigEndian : ByteOrder {
    public init() { }
    
    public func toNative(value: UInt16) -> UInt16 {
        return UInt16(bigEndian: value)
    }
    
    public func toNative(value: UInt32) -> UInt32 {
        return UInt32(bigEndian: value)
    }
    
    public func toNative(value: UInt64) -> UInt64 {
        return UInt64(bigEndian: value)
    }

    public func fromNative(value: UInt16) -> UInt16 {
        return value.bigEndian
    }
    
    public func fromNative(value: UInt32) -> UInt32 {
        return value.bigEndian
    }
    
    public func fromNative(value: UInt64) -> UInt64 {
        return value.bigEndian
    }
}
