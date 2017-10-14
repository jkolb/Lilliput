//
// ByteBufferTests.swift
// Lilliput
//
// Copyright (c) 2014 Justin Kolb - https://github.com/jkolb/Lilliput
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

import Lilliput
import XCTest

class UnsafeOrderedBufferTestCase: XCTestCase {
    static var allTests = [
        ("testPut", testPut),
        ("testGetUInt8", testGetUInt8),
        ("testGetUInt16", testGetUInt16),
        ("testGetUInt32", testGetUInt32),
        ("testGetUInt24", testGetUInt24),
        ("testGetUInt64", testGetUInt64),
        ("testGetFloat32", testGetFloat32),
    ]

    let memory: Memory = POSIXMemory()
    
    func testPut() {
        let byteBuffer = memory.bufferWithSize(4, order: BigEndian.self)
        byteBuffer.putUInt8([1, 2, 3, 4])
        byteBuffer.position = 0
        XCTAssertEqual(UInt8(1), byteBuffer.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(2), byteBuffer.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(3), byteBuffer.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(4), byteBuffer.getUInt8(), "Fail")
    }
    
    func testGetUInt8() {
        let bigEndian = memory.bufferWithSize(2, order: BigEndian.self)
        bigEndian.putUInt8([0x00, 0xFF])
        bigEndian.position = 0
        XCTAssertEqual(UInt8(0x00), bigEndian.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(0xFF), bigEndian.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(0x00), bigEndian.getUInt8(at: 0), "Fail")
        XCTAssertEqual(UInt8(0xFF), bigEndian.getUInt8(at: 1), "Fail")
        
        let littleEndian = memory.bufferWithSize(2, order: LittleEndian.self)
        littleEndian.putUInt8([0x00, 0xFF])
        littleEndian.position = 0
        XCTAssertEqual(UInt8(0x00), littleEndian.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(0xFF), littleEndian.getUInt8(), "Fail")
        XCTAssertEqual(UInt8(0x00), littleEndian.getUInt8(at: 0), "Fail")
        XCTAssertEqual(UInt8(0xFF), littleEndian.getUInt8(at: 1), "Fail")
    }
    
    func testGetUInt16() {
        let bigEndian = memory.bufferWithSize(2, order: BigEndian.self)
        bigEndian.putUInt8([0x00, 0xFF])
        bigEndian.position = 0
        XCTAssertEqual(UInt16(0x00FF), bigEndian.getUInt16(), "Fail")
        XCTAssertEqual(UInt16(0x00FF), bigEndian.getUInt16(at: 0), "Fail")
        
        let littleEndian = memory.bufferWithSize(2, order: LittleEndian.self)
        littleEndian.putUInt8([0x00, 0xFF])
        littleEndian.position = 0
        XCTAssertEqual(UInt16(0xFF00), littleEndian.getUInt16(), "Fail")
        XCTAssertEqual(UInt16(0xFF00), littleEndian.getUInt16(at: 0), "Fail")
    }
    
    func testGetUInt24() {
        let bigEndian = memory.bufferWithSize(4, order: BigEndian.self)
        bigEndian.putInt24(-8388608)
        bigEndian.position = 0
        XCTAssertEqual(bigEndian.getInt24(), -8388608)
        bigEndian.position = 0
        bigEndian.putInt24(-1)
        bigEndian.position = 0
        XCTAssertEqual(bigEndian.getInt24(), -1)
        bigEndian.position = 0
        bigEndian.putInt24(8388607)
        bigEndian.position = 0
        XCTAssertEqual(bigEndian.getInt24(), 8388607)
        bigEndian.position = 0
        bigEndian.putUInt24(16777215)
        bigEndian.position = 0
        XCTAssertEqual(bigEndian.getUInt24(), 16777215)

        let littleEndian = memory.bufferWithSize(4, order: LittleEndian.self)
        littleEndian.putInt24(-8388608)
        littleEndian.position = 0
        XCTAssertEqual(littleEndian.getInt24(), -8388608)
        littleEndian.position = 0
        littleEndian.putInt24(-1)
        littleEndian.position = 0
        XCTAssertEqual(littleEndian.getInt24(), -1)
        littleEndian.position = 0
        littleEndian.putInt24(8388607)
        littleEndian.position = 0
        XCTAssertEqual(littleEndian.getInt24(), 8388607)
        littleEndian.position = 0
        littleEndian.putUInt24(16777215)
        littleEndian.position = 0
        XCTAssertEqual(littleEndian.getUInt24(), 16777215)
    }

    func testGetUInt32() {
        let bigEndian = memory.bufferWithSize(4, order: BigEndian.self)
        bigEndian.putUInt8([0x00, 0x00, 0x00, 0xFF])
        bigEndian.position = 0
        XCTAssertEqual(UInt32(0x000000FF), bigEndian.getUInt32(), "Fail")
        
        let littleEndian = memory.bufferWithSize(4, order: LittleEndian.self)
        littleEndian.putUInt8([0x00, 0x00, 0x00, 0xFF])
        littleEndian.position = 0
        XCTAssertEqual(UInt32(0xFF000000), littleEndian.getUInt32(), "Fail")
    }
    
    func testGetUInt64() {
        let bigEndian = memory.bufferWithSize(8, order: BigEndian.self)
        bigEndian.putUInt8([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        bigEndian.position = 0
        XCTAssertEqual(UInt64(0x00000000000000FF), bigEndian.getUInt64(), "Fail")
        
        #if !arch(i386) && !arch(arm)
            // This won't compile on 32-bit
            let littleEndian = memory.bufferWithSize(8, order: LittleEndian.self)
            littleEndian.putUInt8([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00])
            littleEndian.position = 0
            XCTAssertEqual(UInt64(0x00FF000000000000), littleEndian.getUInt64(), "Fail")
        #endif
    }
    
    func testGetFloat32() {
        let bigEndian = memory.bufferWithSize(4, order: BigEndian.self)
        bigEndian.putUInt8([0x3F, 0x80, 0x00, 0x00])
        bigEndian.position = 0
        XCTAssertEqual(Float32(1.0), bigEndian.getFloat32(), "Fail")
        
        let littleEndian = memory.bufferWithSize(4, order: LittleEndian.self)
        littleEndian.putUInt8([0x00, 0x00, 0x80, 0x3F])
        littleEndian.position = 0
        XCTAssertEqual(Float32(1.0), littleEndian.getFloat32(), "Fail")
    }
}
