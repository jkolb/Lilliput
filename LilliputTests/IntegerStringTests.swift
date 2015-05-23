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
    func testHex() {
        XCTAssertEqual(hex(Int32(0xffff)), "0000ffff", "Failed")
        XCTAssertEqual(hex(UInt32(0xffff)), "0000ffff", "Failed")
    }
    
    func testBinary() {
        XCTAssertEqual(binary(Int8(0b01110000)), "01110000", "Failed")
        XCTAssertEqual(binary(UInt8(0b11110000)), "11110000", "Failed")
    }
    
    func testOctal() {
        XCTAssertEqual(octal(Int32(0o644)), "644", "Failed")
        XCTAssertEqual(octal(UInt32(0o644)), "644", "Failed")
        XCTAssertEqual(octal(UInt32(0o644), length: 4), "0644", "Failed")
    }
    
    func testBase36() {
        XCTAssertEqual(base36(Int8(0x0f)), "f", "Failed")
        XCTAssertEqual(base36(UInt8(0xff)), "73", "Failed")
        XCTAssertEqual(base36(UInt8(0xff), length: 4), "0073", "Failed")
    }
}
