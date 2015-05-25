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

import XCTest

class ByteOrderTests: XCTestCase {
    func testNativeOrder() {
        let native: ByteOrder = nativeOrder()
        
        XCTAssertEqual(UInt16(0x0001), native.fromNative(UInt16(0x0001)), "Test Failed")
        XCTAssertEqual(UInt16(0x0100), native.fromNative(UInt16(0x0100)), "Test Failed")
        XCTAssertEqual(UInt16(0x00FF), native.fromNative(UInt16(0x00FF)), "Test Failed")
        XCTAssertEqual(UInt16(0xFF00), native.fromNative(UInt16(0xFF00)), "Test Failed")
        XCTAssertEqual(UInt16(0x0102), native.fromNative(UInt16(0x0102)), "Test Failed")
        XCTAssertEqual(UInt16(0xFFFF), native.fromNative(UInt16(0xFFFF)), "Test Failed")
        
        XCTAssertNotEqual(UInt16(0x0001), native.toNative(UInt16(0x0100)), "Test Failed")
        XCTAssertNotEqual(UInt16(0x0100), native.toNative(UInt16(0x0001)), "Test Failed")
        XCTAssertNotEqual(UInt16(0x00FF), native.toNative(UInt16(0xFF00)), "Test Failed")
        XCTAssertNotEqual(UInt16(0xFF00), native.toNative(UInt16(0x00FF)), "Test Failed")
        XCTAssertNotEqual(UInt16(0x0102), native.toNative(UInt16(0x0201)), "Test Failed")
        
        XCTAssertEqual(UInt32(0x00000001), native.fromNative(UInt32(0x00000001)), "Test Failed")
        XCTAssertEqual(UInt32(0x00000100), native.fromNative(UInt32(0x00000100)), "Test Failed")
        XCTAssertEqual(UInt32(0x00010000), native.fromNative(UInt32(0x00010000)), "Test Failed")
        XCTAssertEqual(UInt32(0x01000000), native.fromNative(UInt32(0x01000000)), "Test Failed")
        XCTAssertEqual(UInt32(0x000000FF), native.fromNative(UInt32(0x000000FF)), "Test Failed")
        XCTAssertEqual(UInt32(0x0000FF00), native.fromNative(UInt32(0x0000FF00)), "Test Failed")
        XCTAssertEqual(UInt32(0x00FF0000), native.fromNative(UInt32(0x00FF0000)), "Test Failed")
        XCTAssertEqual(UInt32(0x01020304), native.fromNative(UInt32(0x01020304)), "Test Failed")
        
        XCTAssertNotEqual(UInt32(0x00000001), native.toNative(UInt32(0x01000000)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x00000100), native.toNative(UInt32(0x00010000)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x00010000), native.toNative(UInt32(0x00000100)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x01000000), native.toNative(UInt32(0x00000001)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x0000FF00), native.toNative(UInt32(0x00FF0000)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x00FF0000), native.toNative(UInt32(0x0000FF00)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x01020304), native.toNative(UInt32(0x04030201)), "Test Failed")

        #if !arch(i386) && !arch(arm)
            // These won't compile on 32-bit
            XCTAssertEqual(UInt32(0xFF000000), native.fromNative(UInt32(0xFF000000)), "Test Failed")
            XCTAssertEqual(UInt32(0xFFFFFFFF), native.fromNative(UInt32(0xFFFFFFFF)), "Test Failed")

            XCTAssertNotEqual(UInt32(0x000000FF), native.toNative(UInt32(0xFF000000)), "Test Failed")
            XCTAssertNotEqual(UInt32(0xFF000000), native.toNative(UInt32(0x000000FF)), "Test Failed")
            
            XCTAssertEqual(UInt64(0x0000000000000001), native.fromNative(UInt64(0x0000000000000001)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000000000000100), native.fromNative(UInt64(0x0000000000000100)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000000000010000), native.fromNative(UInt64(0x0000000000010000)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000000001000000), native.fromNative(UInt64(0x0000000001000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000000100000000), native.fromNative(UInt64(0x0000000100000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000010000000000), native.fromNative(UInt64(0x0000010000000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x0001000000000000), native.fromNative(UInt64(0x0001000000000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x0100000000000000), native.fromNative(UInt64(0x0100000000000000)), "Test Failed")

            XCTAssertEqual(UInt64(0x00000000000000FF), native.fromNative(UInt64(0x00000000000000FF)), "Test Failed")
            XCTAssertEqual(UInt64(0x000000000000FF00), native.fromNative(UInt64(0x000000000000FF00)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000000000FF0000), native.fromNative(UInt64(0x0000000000FF0000)), "Test Failed")
            XCTAssertEqual(UInt64(0x00000000FF000000), native.fromNative(UInt64(0x00000000FF000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x000000FF00000000), native.fromNative(UInt64(0x000000FF00000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x0000FF0000000000), native.fromNative(UInt64(0x0000FF0000000000)), "Test Failed")
            XCTAssertEqual(UInt64(0x00FF000000000000), native.fromNative(UInt64(0x00FF000000000000)), "Test Failed")
            
            // This won't compile on 64-bit
//            XCTAssertEqual(UInt64(0xFF00000000000000), native.fromNative(UInt64(0xFF00000000000000)), "Test Failed")
        #endif
}
    
    func testForeignOrder() {
        let foreign: ByteOrder = foreignOrder()
        
        XCTAssertNotEqual(UInt16(0x0001), foreign.fromNative(UInt16(0x0001)), "Test Failed")
        XCTAssertNotEqual(UInt16(0x0100), foreign.fromNative(UInt16(0x0100)), "Test Failed")
        XCTAssertNotEqual(UInt16(0x00FF), foreign.fromNative(UInt16(0x00FF)), "Test Failed")
        XCTAssertNotEqual(UInt16(0xFF00), foreign.fromNative(UInt16(0xFF00)), "Test Failed")
        XCTAssertNotEqual(UInt16(0x0102), foreign.fromNative(UInt16(0x0102)), "Test Failed")
        
        XCTAssertEqual(UInt16(0x0001), foreign.toNative(UInt16(0x0100)), "Test Failed")
        XCTAssertEqual(UInt16(0x0100), foreign.toNative(UInt16(0x0001)), "Test Failed")
        XCTAssertEqual(UInt16(0x00FF), foreign.toNative(UInt16(0xFF00)), "Test Failed")
        XCTAssertEqual(UInt16(0xFF00), foreign.toNative(UInt16(0x00FF)), "Test Failed")
        XCTAssertEqual(UInt16(0x0102), foreign.toNative(UInt16(0x0201)), "Test Failed")
        XCTAssertEqual(UInt16(0xFFFF), foreign.toNative(UInt16(0xFFFF)), "Test Failed")
        
        XCTAssertNotEqual(UInt32(0x00000001), foreign.fromNative(UInt32(0x00000001)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x00000100), foreign.fromNative(UInt32(0x00000100)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x00010000), foreign.fromNative(UInt32(0x00010000)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x01000000), foreign.fromNative(UInt32(0x01000000)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x000000FF), foreign.fromNative(UInt32(0x000000FF)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x0000FF00), foreign.fromNative(UInt32(0x0000FF00)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x00FF0000), foreign.fromNative(UInt32(0x00FF0000)), "Test Failed")
        XCTAssertNotEqual(UInt32(0x01020304), foreign.fromNative(UInt32(0x01020304)), "Test Failed")
        
        XCTAssertEqual(UInt32(0x00000001), foreign.toNative(UInt32(0x01000000)), "Test Failed")
        XCTAssertEqual(UInt32(0x00000100), foreign.toNative(UInt32(0x00010000)), "Test Failed")
        XCTAssertEqual(UInt32(0x00010000), foreign.toNative(UInt32(0x00000100)), "Test Failed")
        XCTAssertEqual(UInt32(0x01000000), foreign.toNative(UInt32(0x00000001)), "Test Failed")
        XCTAssertEqual(UInt32(0x0000FF00), foreign.toNative(UInt32(0x00FF0000)), "Test Failed")
        XCTAssertEqual(UInt32(0x00FF0000), foreign.toNative(UInt32(0x0000FF00)), "Test Failed")
        XCTAssertEqual(UInt32(0x01020304), foreign.toNative(UInt32(0x04030201)), "Test Failed")

        #if !arch(i386) && !arch(arm)
            // These won't compile on 32-bit
            XCTAssertEqual(UInt32(0xFF000000), foreign.toNative(UInt32(0x000000FF)), "Test Failed")
            XCTAssertEqual(UInt32(0x000000FF), foreign.toNative(UInt32(0xFF000000)), "Test Failed")
            XCTAssertEqual(UInt32(0xFFFFFFFF), foreign.toNative(UInt32(0xFFFFFFFF)), "Test Failed")
            
            XCTAssertNotEqual(UInt32(0xFF000000), foreign.fromNative(UInt32(0xFF000000)), "Test Failed")
            
            XCTAssertNotEqual(UInt64(0x00000000000000FF), foreign.fromNative(UInt64(0x00000000000000FF)), "Test Failed")
            XCTAssertNotEqual(UInt64(0x000000000000FF00), foreign.fromNative(UInt64(0x000000000000FF00)), "Test Failed")
            XCTAssertNotEqual(UInt64(0x0000000000FF0000), foreign.fromNative(UInt64(0x0000000000FF0000)), "Test Failed")
            XCTAssertNotEqual(UInt64(0x00000000FF000000), foreign.fromNative(UInt64(0x00000000FF000000)), "Test Failed")
            XCTAssertNotEqual(UInt64(0x000000FF00000000), foreign.fromNative(UInt64(0x000000FF00000000)), "Test Failed")
            XCTAssertNotEqual(UInt64(0x0000FF0000000000), foreign.fromNative(UInt64(0x0000FF0000000000)), "Test Failed")
            XCTAssertNotEqual(UInt64(0x00FF000000000000), foreign.fromNative(UInt64(0x00FF000000000000)), "Test Failed")
            
            // This won't compile on 64-bit
//            XCTAssertNotEqual(UInt64(0xFF00000000000000), foreign.fromNative(UInt64(0xFF00000000000000)), "Test Failed")
        #endif
    }
}
