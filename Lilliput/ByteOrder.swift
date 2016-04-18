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

public protocol ByteOrder {
    @warn_unused_result
    static func swapUInt16(value: UInt16) -> UInt16
    
    @warn_unused_result
    static func swapUInt32(value: UInt32) -> UInt32
    
    @warn_unused_result
    static func swapUInt64(value: UInt64) -> UInt64
}

public final class LittleEndian : ByteOrder {
    public static func swapUInt16(value: UInt16) -> UInt16 {
        return value.littleEndian
    }
    
    public static func swapUInt32(value: UInt32) -> UInt32 {
        return value.littleEndian
    }
    
    public static func swapUInt64(value: UInt64) -> UInt64 {
        return value.littleEndian
    }
}

public final class BigEndian : ByteOrder {
    public static func swapUInt16(value: UInt16) -> UInt16 {
        return value.bigEndian
    }
    
    public static func swapUInt32(value: UInt32) -> UInt32 {
        return value.bigEndian
    }
    
    public static func swapUInt64(value: UInt64) -> UInt64 {
        return value.bigEndian
    }
}
