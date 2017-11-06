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

public final class POSIXFile : ReadableFile, WritableFile, SeekableFile {
    private let fd: Int32
    
    public convenience init(forReadingAtPath path: String) throws {
        self.init(fd: try POSIXFile.open(path: path, flags: POSIX.O_RDONLY))
    }
    
    public convenience init(forWritingAtPath path: String, create: Bool) throws {
        self.init(fd: try POSIXFile.open(path: path, flags: create ? (POSIX.O_WRONLY | POSIX.O_CREAT) : POSIX.O_WRONLY))
    }
    
    public convenience init(forUpdatingAtPath path: String, create: Bool) throws {
        self.init(fd: try POSIXFile.open(path: path, flags: create ? (POSIX.O_RDWR | POSIX.O_CREAT) : POSIX.O_RDWR))
    }
    
    private init(fd: Int32) {
        self.fd = fd
    }

    private static func open(path: String, flags: Int32) throws -> Int32 {
        let fd = POSIX.open(path, flags, 0o666)
        
        if fd < 0 {
            throw POSIXError()
        }
        
        return fd
    }

    deinit {
        let _ = POSIX.close(fd)
    }

    public func read(into buffer: UnsafeMutableRawPointer, count: Int) throws -> Int {
        precondition(count >= 0)
        
        let result = POSIX.read(fd, buffer, count)
        
        if result < 0 {
            throw POSIXError()
        }
        
        return result
    }

    public func write(from buffer: UnsafeRawPointer, count: Int) throws -> Int {
        precondition(count >= 0)
        
        let result = POSIX.write(fd, buffer, count)
        
        if result < 0 {
            throw POSIXError()
        }
        
        return result
    }
    
    public func setEndOfFile(position: Int) throws {
        precondition(position >= 0)
        
        let result = POSIX.ftruncate(fd, numericCast(position))
        
        if result < 0 {
            throw POSIXError()
        }
    }

    public var currentPosition: Int {
        get {
            let result = POSIX.lseek(fd, 0, POSIX.SEEK_CUR)
            
            if result < 0 {
                fatalError("Unexpected: (\(POSIXError())")
            }
            
            return numericCast(result)
        }
        set {
            precondition(newValue >= 0)
            
            let result = POSIX.lseek(fd, numericCast(newValue), POSIX.SEEK_SET)
            
            if result < 0 {
                fatalError("Unexpected: (\(POSIXError())")
            }
        }
    }
    
    public func seek(offsetFromCurrent: Int) throws {
        let result = POSIX.lseek(fd, numericCast(offsetFromCurrent), POSIX.SEEK_CUR)
        
        if result < 0 {
            throw POSIXError()
        }
    }
    
    public func seek(offsetFromEnd: Int) throws {
        let result = POSIX.lseek(fd, numericCast(offsetFromEnd), POSIX.SEEK_END)
        
        if result < 0 {
            throw POSIXError()
        }
    }
}
