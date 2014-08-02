//
// IntegerStringTests.swift
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

class IntegerStringTests: XCTestCase {
    func testSingleDigit() {
        XCTAssertEqual(format(0x0, 16), "0", "Failed")
        XCTAssertEqual(format(0x1, 16), "1", "Failed")
        XCTAssertEqual(format(0x2, 16), "2", "Failed")
        XCTAssertEqual(format(0x3, 16), "3", "Failed")
        XCTAssertEqual(format(0x4, 16), "4", "Failed")
        XCTAssertEqual(format(0x5, 16), "5", "Failed")
        XCTAssertEqual(format(0x6, 16), "6", "Failed")
        XCTAssertEqual(format(0x7, 16), "7", "Failed")
        XCTAssertEqual(format(0x8, 16), "8", "Failed")
        XCTAssertEqual(format(0x9, 16), "9", "Failed")
        XCTAssertEqual(format(0xA, 16), "A", "Failed")
        XCTAssertEqual(format(0xB, 16), "B", "Failed")
        XCTAssertEqual(format(0xC, 16), "C", "Failed")
        XCTAssertEqual(format(0xD, 16), "D", "Failed")
        XCTAssertEqual(format(0xE, 16), "E", "Failed")
        XCTAssertEqual(format(0xF, 16), "F", "Failed")
    }
    
    func testDoubleDigit() {
        XCTAssertEqual(format(0x01, 16), "1", "Failed")
        XCTAssertEqual(format(0x12, 16), "12", "Failed")
        XCTAssertEqual(format(0x23, 16), "23", "Failed")
        XCTAssertEqual(format(0x34, 16), "34", "Failed")
        XCTAssertEqual(format(0x45, 16), "45", "Failed")
        XCTAssertEqual(format(0x56, 16), "56", "Failed")
        XCTAssertEqual(format(0x67, 16), "67", "Failed")
        XCTAssertEqual(format(0x78, 16), "78", "Failed")
        XCTAssertEqual(format(0x89, 16), "89", "Failed")
        XCTAssertEqual(format(0x9A, 16), "9A", "Failed")
        XCTAssertEqual(format(0xAB, 16), "AB", "Failed")
        XCTAssertEqual(format(0xBC, 16), "BC", "Failed")
        XCTAssertEqual(format(0xCD, 16), "CD", "Failed")
        XCTAssertEqual(format(0xDE, 16), "DE", "Failed")
        XCTAssertEqual(format(0xEF, 16), "EF", "Failed")
        XCTAssertEqual(format(0xF0, 16), "F0", "Failed")
    }
    
    func testTripleDigit() {
        XCTAssertEqual(format(0x012, 16), "12", "Failed")
        XCTAssertEqual(format(0x123, 16), "123", "Failed")
        XCTAssertEqual(format(0x234, 16), "234", "Failed")
        XCTAssertEqual(format(0x345, 16), "345", "Failed")
        XCTAssertEqual(format(0x456, 16), "456", "Failed")
        XCTAssertEqual(format(0x567, 16), "567", "Failed")
        XCTAssertEqual(format(0x678, 16), "678", "Failed")
        XCTAssertEqual(format(0x789, 16), "789", "Failed")
        XCTAssertEqual(format(0x89A, 16), "89A", "Failed")
        XCTAssertEqual(format(0x9AB, 16), "9AB", "Failed")
        XCTAssertEqual(format(0xABC, 16), "ABC", "Failed")
        XCTAssertEqual(format(0xBCD, 16), "BCD", "Failed")
        XCTAssertEqual(format(0xCDE, 16), "CDE", "Failed")
        XCTAssertEqual(format(0xDEF, 16), "DEF", "Failed")
        XCTAssertEqual(format(0xEF0, 16), "EF0", "Failed")
        XCTAssertEqual(format(0xF01, 16), "F01", "Failed")
    }
    
    func testHex() {
        XCTAssertEqual(hex(UInt32(0xFFFF)), "0000FFFF", "Failed")
    }
    
    func testBinary() {
        XCTAssertEqual(binary(UInt8(0b11110000)), "11110000", "Failed")
    }
    
    func testOctal() {
        XCTAssertEqual(octal(UInt32(0o644)), "644", "Failed")
        XCTAssertEqual(octal(UInt32(0o644), length: 4), "0644", "Failed")
    }
    
    func testBase36() {
        XCTAssertEqual(base36(UInt8(0xFF)), "73", "Failed")
        XCTAssertEqual(base36(UInt8(0xFF), length: 4), "0073", "Failed")
    }
}
