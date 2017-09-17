//
// ByteOrderTests.swift
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

class ByteOrderTestCase: XCTestCase {
    static var allTests = [
        ("testBigEndian", testBigEndian),
        ("testLittleEndian", testLittleEndian),
    ]

    func testBigEndian() {
        XCTAssertEqual(UInt16(bigEndian: 0x0001), BigEndian.swapUInt16(0x0001))
        XCTAssertEqual(UInt16(bigEndian: 0x0100), BigEndian.swapUInt16(0x0100))
        XCTAssertEqual(UInt16(bigEndian: 0x00FF), BigEndian.swapUInt16(0x00FF))
        XCTAssertEqual(UInt16(bigEndian: 0xFF00), BigEndian.swapUInt16(0xFF00))
        XCTAssertEqual(UInt16(bigEndian: 0x0102), BigEndian.swapUInt16(0x0102))
        XCTAssertEqual(UInt16(bigEndian: 0xFFFF), BigEndian.swapUInt16(0xFFFF))
        
        XCTAssertNotEqual(UInt16(bigEndian: 0x0001), BigEndian.swapUInt16(0x0100))
        XCTAssertNotEqual(UInt16(bigEndian: 0x0100), BigEndian.swapUInt16(0x0001))
        XCTAssertNotEqual(UInt16(bigEndian: 0x00FF), BigEndian.swapUInt16(0xFF00))
        XCTAssertNotEqual(UInt16(bigEndian: 0xFF00), BigEndian.swapUInt16(0x00FF))
        XCTAssertNotEqual(UInt16(bigEndian: 0x0102), BigEndian.swapUInt16(0x0201))
        
        XCTAssertEqual(UInt32(bigEndian: 0x00000001), BigEndian.swapUInt32(0x00000001))
        XCTAssertEqual(UInt32(bigEndian: 0x00000100), BigEndian.swapUInt32(0x00000100))
        XCTAssertEqual(UInt32(bigEndian: 0x00010000), BigEndian.swapUInt32(0x00010000))
        XCTAssertEqual(UInt32(bigEndian: 0x01000000), BigEndian.swapUInt32(0x01000000))
        XCTAssertEqual(UInt32(bigEndian: 0x000000FF), BigEndian.swapUInt32(0x000000FF))
        XCTAssertEqual(UInt32(bigEndian: 0x0000FF00), BigEndian.swapUInt32(0x0000FF00))
        XCTAssertEqual(UInt32(bigEndian: 0x00FF0000), BigEndian.swapUInt32(0x00FF0000))
        XCTAssertEqual(UInt32(bigEndian: 0x01020304), BigEndian.swapUInt32(0x01020304))
        XCTAssertEqual(UInt32(bigEndian: 0xFF000000), BigEndian.swapUInt32(0xFF000000))
        XCTAssertEqual(UInt32(bigEndian: 0xFFFFFFFF), BigEndian.swapUInt32(0xFFFFFFFF))
        
        XCTAssertNotEqual(UInt32(bigEndian: 0x00000001), BigEndian.swapUInt32(0x01000000))
        XCTAssertNotEqual(UInt32(bigEndian: 0x00000100), BigEndian.swapUInt32(0x00010000))
        XCTAssertNotEqual(UInt32(bigEndian: 0x00010000), BigEndian.swapUInt32(0x00000100))
        XCTAssertNotEqual(UInt32(bigEndian: 0x01000000), BigEndian.swapUInt32(0x00000001))
        XCTAssertNotEqual(UInt32(bigEndian: 0x0000FF00), BigEndian.swapUInt32(0x00FF0000))
        XCTAssertNotEqual(UInt32(bigEndian: 0x00FF0000), BigEndian.swapUInt32(0x0000FF00))
        XCTAssertNotEqual(UInt32(bigEndian: 0x01020304), BigEndian.swapUInt32(0x04030201))
        XCTAssertNotEqual(UInt32(bigEndian: 0x000000FF), BigEndian.swapUInt32(0xFF000000))
        XCTAssertNotEqual(UInt32(bigEndian: 0xFF000000), BigEndian.swapUInt32(0x000000FF))

        #if !arch(i386) && !arch(arm)
            // These won't compile on 32-bit
            XCTAssertEqual(UInt64(bigEndian: 0x0000000000000001), BigEndian.swapUInt64(0x0000000000000001))
            XCTAssertEqual(UInt64(bigEndian: 0x0000000000000100), BigEndian.swapUInt64(0x0000000000000100))
            XCTAssertEqual(UInt64(bigEndian: 0x0000000000010000), BigEndian.swapUInt64(0x0000000000010000))
            XCTAssertEqual(UInt64(bigEndian: 0x0000000001000000), BigEndian.swapUInt64(0x0000000001000000))
            XCTAssertEqual(UInt64(bigEndian: 0x0000000100000000), BigEndian.swapUInt64(0x0000000100000000))
            XCTAssertEqual(UInt64(bigEndian: 0x0000010000000000), BigEndian.swapUInt64(0x0000010000000000))
            XCTAssertEqual(UInt64(bigEndian: 0x0001000000000000), BigEndian.swapUInt64(0x0001000000000000))
            XCTAssertEqual(UInt64(bigEndian: 0x0100000000000000), BigEndian.swapUInt64(0x0100000000000000))
            XCTAssertEqual(UInt64(bigEndian: 0xFF00000000000000), BigEndian.swapUInt64(0xFF00000000000000))

            XCTAssertNotEqual(UInt64(bigEndian: 0x00000000000000FF), BigEndian.swapUInt64(0xFF00000000000000))
            XCTAssertNotEqual(UInt64(bigEndian: 0x000000000000FF00), BigEndian.swapUInt64(0x00FF000000000000))
            XCTAssertNotEqual(UInt64(bigEndian: 0x0000000000FF0000), BigEndian.swapUInt64(0x0000FF0000000000))
            XCTAssertNotEqual(UInt64(bigEndian: 0x00000000FF000000), BigEndian.swapUInt64(0x000000FF00000000))
            XCTAssertNotEqual(UInt64(bigEndian: 0x000000FF00000000), BigEndian.swapUInt64(0x00000000FF000000))
            XCTAssertNotEqual(UInt64(bigEndian: 0x0000FF0000000000), BigEndian.swapUInt64(0x0000000000FF0000))
            XCTAssertNotEqual(UInt64(bigEndian: 0x00FF000000000000), BigEndian.swapUInt64(0x000000000000FF00))
            XCTAssertNotEqual(UInt64(bigEndian: 0xFF00000000000000), BigEndian.swapUInt64(0x00000000000000FF))
        #endif
}
    
    func testLittleEndian() {
        XCTAssertEqual(UInt16(littleEndian: 0x0001), LittleEndian.swapUInt16(0x0001))
        XCTAssertEqual(UInt16(littleEndian: 0x0100), LittleEndian.swapUInt16(0x0100))
        XCTAssertEqual(UInt16(littleEndian: 0x00FF), LittleEndian.swapUInt16(0x00FF))
        XCTAssertEqual(UInt16(littleEndian: 0xFF00), LittleEndian.swapUInt16(0xFF00))
        XCTAssertEqual(UInt16(littleEndian: 0x0102), LittleEndian.swapUInt16(0x0102))
        XCTAssertEqual(UInt16(littleEndian: 0xFFFF), LittleEndian.swapUInt16(0xFFFF))
        
        XCTAssertNotEqual(UInt16(littleEndian: 0x0001), LittleEndian.swapUInt16(0x0100))
        XCTAssertNotEqual(UInt16(littleEndian: 0x0100), LittleEndian.swapUInt16(0x0001))
        XCTAssertNotEqual(UInt16(littleEndian: 0x00FF), LittleEndian.swapUInt16(0xFF00))
        XCTAssertNotEqual(UInt16(littleEndian: 0xFF00), LittleEndian.swapUInt16(0x00FF))
        XCTAssertNotEqual(UInt16(littleEndian: 0x0102), LittleEndian.swapUInt16(0x0201))
        
        XCTAssertEqual(UInt32(littleEndian: 0x00000001), LittleEndian.swapUInt32(0x00000001))
        XCTAssertEqual(UInt32(littleEndian: 0x00000100), LittleEndian.swapUInt32(0x00000100))
        XCTAssertEqual(UInt32(littleEndian: 0x00010000), LittleEndian.swapUInt32(0x00010000))
        XCTAssertEqual(UInt32(littleEndian: 0x01000000), LittleEndian.swapUInt32(0x01000000))
        XCTAssertEqual(UInt32(littleEndian: 0x000000FF), LittleEndian.swapUInt32(0x000000FF))
        XCTAssertEqual(UInt32(littleEndian: 0x0000FF00), LittleEndian.swapUInt32(0x0000FF00))
        XCTAssertEqual(UInt32(littleEndian: 0x00FF0000), LittleEndian.swapUInt32(0x00FF0000))
        XCTAssertEqual(UInt32(littleEndian: 0x01020304), LittleEndian.swapUInt32(0x01020304))
        XCTAssertEqual(UInt32(littleEndian: 0xFF000000), LittleEndian.swapUInt32(0xFF000000))
        XCTAssertEqual(UInt32(littleEndian: 0xFFFFFFFF), LittleEndian.swapUInt32(0xFFFFFFFF))
        
        XCTAssertNotEqual(UInt32(littleEndian: 0x00000001), LittleEndian.swapUInt32(0x01000000))
        XCTAssertNotEqual(UInt32(littleEndian: 0x00000100), LittleEndian.swapUInt32(0x00010000))
        XCTAssertNotEqual(UInt32(littleEndian: 0x00010000), LittleEndian.swapUInt32(0x00000100))
        XCTAssertNotEqual(UInt32(littleEndian: 0x01000000), LittleEndian.swapUInt32(0x00000001))
        XCTAssertNotEqual(UInt32(littleEndian: 0x0000FF00), LittleEndian.swapUInt32(0x00FF0000))
        XCTAssertNotEqual(UInt32(littleEndian: 0x00FF0000), LittleEndian.swapUInt32(0x0000FF00))
        XCTAssertNotEqual(UInt32(littleEndian: 0x01020304), LittleEndian.swapUInt32(0x04030201))
        XCTAssertNotEqual(UInt32(littleEndian: 0x000000FF), LittleEndian.swapUInt32(0xFF000000))
        XCTAssertNotEqual(UInt32(littleEndian: 0xFF000000), LittleEndian.swapUInt32(0x000000FF))
        
        #if !arch(i386) && !arch(arm)
            // These won't compile on 32-bit
            XCTAssertEqual(UInt64(littleEndian: 0x0000000000000001), LittleEndian.swapUInt64(0x0000000000000001))
            XCTAssertEqual(UInt64(littleEndian: 0x0000000000000100), LittleEndian.swapUInt64(0x0000000000000100))
            XCTAssertEqual(UInt64(littleEndian: 0x0000000000010000), LittleEndian.swapUInt64(0x0000000000010000))
            XCTAssertEqual(UInt64(littleEndian: 0x0000000001000000), LittleEndian.swapUInt64(0x0000000001000000))
            XCTAssertEqual(UInt64(littleEndian: 0x0000000100000000), LittleEndian.swapUInt64(0x0000000100000000))
            XCTAssertEqual(UInt64(littleEndian: 0x0000010000000000), LittleEndian.swapUInt64(0x0000010000000000))
            XCTAssertEqual(UInt64(littleEndian: 0x0001000000000000), LittleEndian.swapUInt64(0x0001000000000000))
            XCTAssertEqual(UInt64(littleEndian: 0x0100000000000000), LittleEndian.swapUInt64(0x0100000000000000))
            XCTAssertEqual(UInt64(littleEndian: 0xFF00000000000000), LittleEndian.swapUInt64(0xFF00000000000000))
            
            XCTAssertNotEqual(UInt64(littleEndian: 0x00000000000000FF), LittleEndian.swapUInt64(0xFF00000000000000))
            XCTAssertNotEqual(UInt64(littleEndian: 0x000000000000FF00), LittleEndian.swapUInt64(0x00FF000000000000))
            XCTAssertNotEqual(UInt64(littleEndian: 0x0000000000FF0000), LittleEndian.swapUInt64(0x0000FF0000000000))
            XCTAssertNotEqual(UInt64(littleEndian: 0x00000000FF000000), LittleEndian.swapUInt64(0x000000FF00000000))
            XCTAssertNotEqual(UInt64(littleEndian: 0x000000FF00000000), LittleEndian.swapUInt64(0x00000000FF000000))
            XCTAssertNotEqual(UInt64(littleEndian: 0x0000FF0000000000), LittleEndian.swapUInt64(0x0000000000FF0000))
            XCTAssertNotEqual(UInt64(littleEndian: 0x00FF000000000000), LittleEndian.swapUInt64(0x000000000000FF00))
            XCTAssertNotEqual(UInt64(littleEndian: 0xFF00000000000000), LittleEndian.swapUInt64(0x00000000000000FF))
        #endif
    }
}
