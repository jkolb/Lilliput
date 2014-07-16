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

typealias Offset = off_t
typealias ByteCount = ssize_t

class BinaryFile {
    let fileDescriptor: CInt
    let closeOnDeinit: Bool
    
    class func openForReading(path: String) -> BinaryFile? {
        return openBinaryFile(path, flags: O_RDONLY)
    }
    
    class func openForWriting(path: String) -> BinaryFile? {
        return openBinaryFile(path, flags: O_WRONLY)
    }
    
    class func openForUpdating(path: String) -> BinaryFile? {
        return openBinaryFile(path, flags: O_RDWR)
    }
    
    class func openBinaryFile(path: String, flags: CInt) -> BinaryFile? {
        let fd = path.withCString { open($0, flags) }
        
        if (fd == -1) {
            return nil;
        }
        
        return BinaryFile(fileDescriptor: fd)
    }
    
    init(fileDescriptor: CInt, closeOnDeinit: Bool = true) {
        assert(fileDescriptor >= 0)
        self.fileDescriptor = fileDescriptor
        self.closeOnDeinit = closeOnDeinit
    }
    
    deinit {
        if (closeOnDeinit) {
            close(fileDescriptor)
        }
    }
    
    func readBuffer(buffer: ByteBuffer, inout error: Error) -> ByteCount? {
        let bytesRead = read(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        
        if (bytesRead < 0) {
            error = Error(code: Int(errno))
            return nil
        } else {
            buffer.position += bytesRead
            return bytesRead
        }
    }
    
    func writeBuffer(buffer: ByteBuffer, inout error: Error) -> ByteCount? {
        let bytesWritten = write(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        
        if (bytesWritten < 0) {
            error = Error(code: Int(errno))
            return nil
        } else {
            buffer.position += bytesWritten
            return bytesWritten
        }
    }
    
    func seekFromStart(offset: Offset, inout error: Error) -> Offset? {
        let offset = lseek(fileDescriptor, offset, SEEK_SET)
        if (offset < 0) {
            error = Error(code: Int(errno))
            return nil
        } else {
            return offset
        }
    }
    
    func seekFromCurrent(offset: Offset, inout error: Error) -> Offset? {
        let offset = lseek(fileDescriptor, offset, SEEK_CUR)
        if (offset < 0) {
            error = Error(code: Int(errno))
            return nil
        } else {
            return offset
        }
    }
    
    func seekFromEnd(offset: Offset, inout error: Error) -> Offset? {
        let offset = lseek(fileDescriptor, offset, SEEK_END)
        if (offset < 0) {
            error = Error(code: Int(errno))
            return nil
        } else {
            return offset
        }
    }
    
    struct Error {
        let code: Int
    }
}
