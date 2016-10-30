/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Justin Kolb
 
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

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public final class POSIXFileChannel : SeekableByteChannel {
    private let fileDescriptor: CInt
    private let closeOnDeinit: Bool
    
    public init(fileDescriptor: CInt, closeOnDeinit: Bool = true) {
        self.fileDescriptor = fileDescriptor
        self.closeOnDeinit = closeOnDeinit
    }
    
    deinit {
        if closeOnDeinit {
            close(fileDescriptor)
        }
    }

    public func readBytes(_ bytes: UnsafeMutableRawPointer, count: Int) throws -> Int {
        precondition(count >= 0)
        
        if count == 0 {
            return 0
        }
        
        let readCount = read(fileDescriptor, bytes, count)
        
        if readCount < 0 {
            throw POSIXError(code: errno)
        }
        
        return readCount
    }

    public func writeBytes(_ bytes: UnsafeMutableRawPointer, count: Int) throws -> Int {
        precondition(count >= 0)
        
        if count == 0 {
            return 0
        }
        
        let writeCount = write(fileDescriptor, bytes, count)
        
        if writeCount < 0 {
            throw POSIXError(code: errno)
        }
        
        return writeCount
    }

    public func position() throws -> Int {
        let seekPosition = lseek(fileDescriptor, 0, SEEK_CUR)
        
        if seekPosition < 0 {
            throw POSIXError(code: errno)
        }
        
        return Int(seekPosition)
    }
    
    public func seekTo(_ position: Int) throws {
        precondition(position >= 0)

        let seekPosition = lseek(fileDescriptor, off_t(position), SEEK_SET)
        
        if seekPosition < 0 {
            throw POSIXError(code: errno)
        }
    }
    
    public func end() throws -> Int {
        let currentPosition = try position()
        let seekPosition = lseek(fileDescriptor, 0, SEEK_END)
        
        if seekPosition < 0 {
            throw POSIXError(code: errno)
        }
        
        try seekTo(currentPosition)
        
        return Int(seekPosition)
    }
    
    public func truncateAt(_ position: Int) throws {
        precondition(position >= 0)
        
        let result = ftruncate(fileDescriptor, off_t(position))
        
        if result < 0 {
            throw POSIXError(code: errno)
        }
    }
}
