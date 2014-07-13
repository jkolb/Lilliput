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

import XCTest

class ByteBufferTests: XCTestCase {
    func testFill() {
        let buffer = ByteBuffer(order: BigEndian(), length: 4)
        buffer.fill([1, 2, 3, 4])
        XCTAssertEqual(UInt8(1), buffer.nextUInt8(), "Fail")
        XCTAssertEqual(UInt8(2), buffer.nextUInt8(), "Fail")
        XCTAssertEqual(UInt8(3), buffer.nextUInt8(), "Fail")
        XCTAssertEqual(UInt8(4), buffer.nextUInt8(), "Fail")
    }
    
    func testNextUInt16() {
        let bigEndian = ByteBuffer(order: BigEndian(), length: 2)
        bigEndian.fill([0x00, 0xFF])
        XCTAssertEqual(UInt16(0x00FF), bigEndian.nextUInt16(), "Fail")
        
        let littleEndian = ByteBuffer(order: LittleEndian(), length: 2)
        littleEndian.fill([0x00, 0xFF])
        XCTAssertEqual(UInt16(0xFF00), littleEndian.nextUInt16(), "Fail")
    }
    
    func testNextUInt32() {
        let bigEndian = ByteBuffer(order: BigEndian(), length: 4)
        bigEndian.fill([0x00, 0x00, 0x00, 0xFF])
        XCTAssertEqual(UInt32(0x000000FF), bigEndian.nextUInt32(), "Fail")
        
        let littleEndian = ByteBuffer(order: LittleEndian(), length: 4)
        littleEndian.fill([0x00, 0x00, 0x00, 0xFF])
        XCTAssertEqual(UInt32(0xFF000000), littleEndian.nextUInt32(), "Fail")
    }
    
    func testNextUInt64() {
        let bigEndian = ByteBuffer(order: BigEndian(), length: 8)
        bigEndian.fill([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF])
        XCTAssertEqual(UInt64(0x00000000000000FF), bigEndian.nextUInt64(), "Fail")
        
        let littleEndian = ByteBuffer(order: LittleEndian(), length: 8)
        littleEndian.fill([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0x00])
        XCTAssertEqual(UInt64(0x00FF000000000000), littleEndian.nextUInt64(), "Fail")
    }
    
    func testNextFloat32() {
        let bigEndian = ByteBuffer(order: BigEndian(), length: 4)
        bigEndian.fill([0x3F, 0x80, 0x00, 0x00])
        XCTAssertEqual(Float32(1.0), bigEndian.nextFloat32(), "Fail")
        
        let littleEndian = ByteBuffer(order: LittleEndian(), length: 4)
        littleEndian.fill([0x00, 0x00, 0x80, 0x3F])
        XCTAssertEqual(Float32(1.0), littleEndian.nextFloat32(), "Fail")
    }
}
