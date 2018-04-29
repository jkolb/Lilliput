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

import Lilliput
import XCTest

class OrderedByteBufferTestCase: XCTestCase {
    static var allTests = [
        ("testPut", testPut),
        ("testGetUInt8", testGetUInt8),
        ("testGetUInt16", testGetUInt16),
        ("testGetUInt32", testGetUInt32),
        ("testGetUInt64", testGetUInt64),
        ("testGetFloat32", testGetFloat32),
        ]
    
    func testPut() {
        let byteBuffer = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 4))
        byteBuffer.putUInt8(1, at: 0)
        byteBuffer.putUInt8(2, at: 1)
        byteBuffer.putUInt8(3, at: 2)
        byteBuffer.putUInt8(4, at: 3)
        XCTAssertEqual(UInt8(1), byteBuffer.getUInt8(at: 0), "Fail")
        XCTAssertEqual(UInt8(2), byteBuffer.getUInt8(at: 1), "Fail")
        XCTAssertEqual(UInt8(3), byteBuffer.getUInt8(at: 2), "Fail")
        XCTAssertEqual(UInt8(4), byteBuffer.getUInt8(at: 3), "Fail")
    }
    
    func testGetUInt8() {
        let bigEndian = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 2))
        bigEndian.putUInt8(0x00, at: 0)
        bigEndian.putUInt8(0xFF, at: 1)
        XCTAssertEqual(UInt8(0x00), bigEndian.getUInt8(at: 0), "Fail")
        XCTAssertEqual(UInt8(0xFF), bigEndian.getUInt8(at: 1), "Fail")
        
        let littleEndian = OrderedBuffer<LittleEndian>(buffer: MemoryBuffer(count: 2))
        littleEndian.putUInt8(0x00, at: 0)
        littleEndian.putUInt8(0xFF, at: 1)
        XCTAssertEqual(UInt8(0x00), littleEndian.getUInt8(at: 0), "Fail")
        XCTAssertEqual(UInt8(0xFF), littleEndian.getUInt8(at: 1), "Fail")
    }
    
    func testGetUInt16() {
        let bigEndian = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 2))
        bigEndian.putUInt8(0x00, at: 0)
        bigEndian.putUInt8(0xFF, at: 1)
        XCTAssertEqual(UInt16(0x00FF), bigEndian.getUInt16(at: 0), "Fail")
        
        let littleEndian = OrderedBuffer<LittleEndian>(buffer: MemoryBuffer(count: 2))
        littleEndian.putUInt8(0x00, at: 0)
        littleEndian.putUInt8(0xFF, at: 1)
        XCTAssertEqual(UInt16(0xFF00), littleEndian.getUInt16(at: 0), "Fail")
    }
    
    func testGetUInt32() {
        let bigEndian = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 4))
        bigEndian.putUInt8(0x00, at: 0)
        bigEndian.putUInt8(0x00, at: 1)
        bigEndian.putUInt8(0x00, at: 2)
        bigEndian.putUInt8(0xFF, at: 3)
        XCTAssertEqual(UInt32(0x000000FF), bigEndian.getUInt32(at: 0), "Fail")
        
        let littleEndian = OrderedBuffer<LittleEndian>(buffer: MemoryBuffer(count: 4))
        littleEndian.putUInt8(0x00, at: 0)
        littleEndian.putUInt8(0x00, at: 1)
        littleEndian.putUInt8(0x00, at: 2)
        littleEndian.putUInt8(0xFF, at: 3)
        XCTAssertEqual(UInt32(0xFF000000), littleEndian.getUInt32(at: 0), "Fail")
    }
    
    func testGetUInt64() {
        let bigEndian = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 8))
        bigEndian.putUInt8(0x00, at: 0)
        bigEndian.putUInt8(0x00, at: 1)
        bigEndian.putUInt8(0x00, at: 2)
        bigEndian.putUInt8(0x00, at: 3)
        bigEndian.putUInt8(0x00, at: 4)
        bigEndian.putUInt8(0x00, at: 5)
        bigEndian.putUInt8(0x00, at: 6)
        bigEndian.putUInt8(0xFF, at: 7)
        XCTAssertEqual(UInt64(0x00000000000000FF), bigEndian.getUInt64(at: 0), "Fail")
        
        #if !arch(i386) && !arch(arm)
        // This won't compile on 32-bit
        let littleEndian = OrderedBuffer<LittleEndian>(buffer: MemoryBuffer(count: 8))
        littleEndian.putUInt8(0x00, at: 0)
        littleEndian.putUInt8(0x00, at: 1)
        littleEndian.putUInt8(0x00, at: 2)
        littleEndian.putUInt8(0x00, at: 3)
        littleEndian.putUInt8(0x00, at: 4)
        littleEndian.putUInt8(0x00, at: 5)
        littleEndian.putUInt8(0xFF, at: 6)
        littleEndian.putUInt8(0x00, at: 7)
        XCTAssertEqual(UInt64(0x00FF000000000000), littleEndian.getUInt64(at: 0), "Fail")
        #endif
    }
    
    func testGetFloat32() {
        let bigEndian = OrderedBuffer<BigEndian>(buffer: MemoryBuffer(count: 4))
        bigEndian.putUInt8(0x3F, at: 0)
        bigEndian.putUInt8(0x80, at: 1)
        bigEndian.putUInt8(0x00, at: 2)
        bigEndian.putUInt8(0x00, at: 3)
        XCTAssertEqual(Float32(1.0).bitPattern.bigEndian, bigEndian.getFloat32(at: 0).bitPattern, "Fail")
        
        let littleEndian = OrderedBuffer<LittleEndian>(buffer: MemoryBuffer(count: 4))
        littleEndian.putUInt8(0x00, at: 0)
        littleEndian.putUInt8(0x00, at: 1)
        littleEndian.putUInt8(0x80, at: 2)
        littleEndian.putUInt8(0x3F, at: 3)
        XCTAssertEqual(Float32(1.0).bitPattern.littleEndian, littleEndian.getFloat32(at: 0).bitPattern, "Fail")
    }
}
