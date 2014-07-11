//
// BinaryFile.swift
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

class BinaryFile {
    var handle: UnsafePointer<FILE>
    
    class func openForReading(path: String) -> BinaryFile? {
        var file = BinaryFile(path: path, mode: "r")
        if file.handle == UnsafePointer<FILE>.null() {
            return nil
        }
        return file
    }
    
    class func openForWriting(path: String) -> BinaryFile? {
        var file = BinaryFile(path: path, mode: "w")
        if file.handle == UnsafePointer<FILE>.null() {
            return nil
        }
        return file
    }
    
    class func openForUpdating(path: String) -> BinaryFile? {
        var file = BinaryFile(path: path, mode: "rw")
        if file.handle == UnsafePointer<FILE>.null() {
            return nil
        }
        return file
    }
    
    init(path: String, mode: String) {
        var handle: UnsafePointer<FILE>!
        
        path.withCString {
            cPath in mode.withCString {
                cMode in handle = fopen(cPath, cMode)
            }
        }
        
        self.handle = handle
    }
    
    deinit {
        if handle != UnsafePointer<FILE>.null() {
            fclose(handle)
        }
    }
    
    func read(buffer: ByteBuffer) -> Int {
        return Int(fread(buffer.buffer, UInt(sizeof(UInt8)), UInt(buffer.length), handle))
    }
    
    func write(buffer: ByteBuffer, length: Int) -> Int {
        return Int(fwrite(buffer.buffer, UInt(sizeof(UInt8)), UInt(length), handle))
    }
    
    func seek(offset: Int) {
        //SEEK_SET, SEEK_CUR, or SEEK_END
        let result = fseek(handle, offset, SEEK_SET)
        if (result == -1) {
            // error!
        }
    }
}
