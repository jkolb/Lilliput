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

    public func readData(data: UnsafeMutablePointer<Void>, numberOfBytes: Int) throws -> Int {
        precondition(numberOfBytes >= 0)
        let numberOfBytesRead = read(fileDescriptor, data, numberOfBytes)
        
        if numberOfBytesRead < 0 {
            throw POSIXError(code: errno)
        }
        
        return numberOfBytesRead
    }

    public func writeData(data: UnsafeMutablePointer<Void>, numberOfBytes: Int) throws -> Int {
        precondition(numberOfBytes >= 0)
        let numberOfBytesWritten = write(fileDescriptor, data, numberOfBytes)
        
        if numberOfBytesWritten < 0 {
            throw POSIXError(code: errno)
        }
        
        return numberOfBytesWritten
    }

    public func position() throws -> FilePosition {
        let bytesFromStart = lseek(fileDescriptor, 0, SEEK_CUR)
        
        if bytesFromStart < 0 {
            throw POSIXError(code: errno)
        }
        
        return FilePosition(bytesFromStart)
    }
    
    public func seek(position: FilePosition) throws -> FilePosition {
        let bytesFromStart = lseek(fileDescriptor, position.bytesFromStart, SEEK_SET)
        
        if bytesFromStart < 0 {
            throw POSIXError(code: errno)
        }
        
        return FilePosition(bytesFromStart)
    }
    
    public func end() throws -> FilePosition {
        let currentPosition = try position()
        let bytesFromStart = lseek(fileDescriptor, 0, SEEK_END)
        
        if bytesFromStart < 0 {
            throw POSIXError(code: errno)
        }
        
        try seek(currentPosition)
        
        return FilePosition(bytesFromStart)
    }
    
    public func truncate(end: FilePosition) throws {
        let result = ftruncate(fileDescriptor, end.bytesFromStart)
        
        if result < 0 {
            throw POSIXError(code: errno)
        }
    }
}
