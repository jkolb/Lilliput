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

public class POSIXFileChannel : SeekableByteChannel {
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

    public func read(buffer: UnsafeMutablePointer<Void>, numberOfBytes: Int) throws -> Int {
        precondition(numberOfBytes >= 0)

        #if os(Linux)
            let numberOfBytesRead = Glibc.read(fileDescriptor, buffer, numberOfBytes)
        #else
            let numberOfBytesRead = Darwin.read(fileDescriptor, buffer, numberOfBytes)
        #endif
        
        if numberOfBytesRead < 0 {
            throw POSIXError(code: errno)
        }
        
        return numberOfBytesRead
    }

    public func write(buffer: UnsafeMutablePointer<Void>, numberOfBytes: Int) throws -> Int {
        precondition(numberOfBytes >= 0)
        
        #if os(Linux)
            let numberOfBytesWritten = Glibc.write(fileDescriptor, buffer, numberOfBytes)
        #else
            let numberOfBytesWritten = Darwin.write(fileDescriptor, buffer, numberOfBytes)
        #endif
        
        if numberOfBytesWritten < 0 {
            throw POSIXError(code: errno)
        }
        
        return numberOfBytesWritten
    }

    public func position() throws -> Int64 {
        return try seek(0)
    }
    
    public func seek(position: Int64) throws -> Int64 {
        precondition(position >= 0)
        let updatedPosition = lseek(fileDescriptor, position, SEEK_SET)
        
        if updatedPosition < 0 {
            throw POSIXError(code: errno)
        }
        
        return updatedPosition
    }
    
    public func size() throws -> Int64 {
        let currentPosition = try position()
        let endPosition = lseek(fileDescriptor, 0, SEEK_END)
        
        if endPosition < 0 {
            throw POSIXError(code: errno)
        }
        
        try seek(currentPosition)
        
        return endPosition
    }
    
    public func truncate(size: Int64) throws {
        precondition(size >= 0)
        let result = ftruncate(fileDescriptor, size)
        
        if result < 0 {
            throw POSIXError(code: errno)
        }
    }
}
