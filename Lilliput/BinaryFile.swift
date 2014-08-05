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

public typealias FileOffset = off_t
public typealias FilePosition = off_t
public typealias FileSize = off_t
public typealias ErrorCode = Int32
public typealias FileDescriptor = Int32
public typealias ByteCount = Int

public class BinaryFile {
    public let fileDescriptor: FileDescriptor
    private let closeOnDeinit: Bool

    public struct Error {
        public let code: ErrorCode
        public let message: String
        
        public init(code: ErrorCode, message: String = "") {
            self.code = code
            self.message = message
        }
    }
    
    public enum Result<T> {
        case Success(@autoclosure () -> T)
        case Failure(Error)
        
        public var error: Error? {
            switch self {
            case .Success:
                return nil
            case .Failure(let error):
                return error
            }
        }
        
        public var value: T! {
            switch self {
            case .Success(let value):
                return value()
            case .Failure:
                return nil
            }
        }
    }
    
    public class func openForReading(path: String) -> Result<BinaryFile> {
        return openBinaryFile(path, flags: O_RDONLY)
    }
    
    public class func openForWriting(path: String, create: Bool = true) -> Result<BinaryFile> {
        if create {
            return openBinaryFile(path, flags: O_WRONLY | O_CREAT)
        } else {
            return openBinaryFile(path, flags: O_WRONLY)
        }
    }
    
    public class func openForUpdating(path: String, create: Bool = true) -> Result<BinaryFile> {
        if create {
            return openBinaryFile(path, flags: O_RDWR | O_CREAT)
        } else {
            return openBinaryFile(path, flags: O_RDWR)
        }
    }
    
    public class func openBinaryFile(path: String, flags: CInt) -> Result<BinaryFile> {
        let fileDescriptor = path.withCString { open($0, flags, 0o644) }
        if fileDescriptor < 0 { return .Failure(Error(code: errno)) }
        return .Success(BinaryFile(fileDescriptor: fileDescriptor))
    }
    
    public init(fileDescriptor: FileDescriptor, closeOnDeinit: Bool = true) {
        assert(fileDescriptor >= 0)
        self.fileDescriptor = fileDescriptor
        self.closeOnDeinit = closeOnDeinit
    }
    
    deinit {
        if (closeOnDeinit) { close(fileDescriptor) }
    }
    
    public func readBuffer(buffer: ByteBuffer) -> Result<ByteCount> {
        let bytesRead = read(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        if bytesRead < 0 { return .Failure(Error(code: errno)) }
        buffer.position += bytesRead
        return .Success(bytesRead)
    }
    
    public func writeBuffer(buffer: ByteBuffer) -> Result<ByteCount> {
        let bytesWritten = write(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        if bytesWritten < 0 { return .Failure(Error(code: errno)) }
        buffer.position += bytesWritten
        return .Success(bytesWritten)
    }
    
    public enum SeekFrom {
        case Start
        case Current
        case End
    }
    
    public func seek(offset: FileOffset, from: SeekFrom = .Start) -> Result<FilePosition> {
        var position: FilePosition
        switch from {
        case .Start:
            position = lseek(fileDescriptor, offset, SEEK_SET)
        case .Current:
            position = lseek(fileDescriptor, offset, SEEK_CUR)
        case .End:
            position = lseek(fileDescriptor, offset, SEEK_END)
        }
        if offset < 0 { return .Failure(Error(code: errno)) }
        return .Success(position)
    }
    
    public func size() -> Result<FileSize> {
        var status = stat()
        let result = fstat(fileDescriptor, &status)
        if result < 0 { return .Failure(Error(code: errno)) }
        return .Success(status.st_size)
    }
    
    public func resize(size: FileSize) -> Result<FileSize> {
        let result = ftruncate(fileDescriptor, size)
        if result < 0 { return .Failure(Error(code: errno)) }
        return .Success(size)
    }

    public enum MapMode {
        case Private
        case ReadOnly
        case ReadWrite
    }

    public func map(order: ByteOrder, mode: MapMode) -> Result<ByteBuffer> {
        let sizeResult = size()
        if let error = sizeResult.error { return .Failure(error) }
        return map(order, mode: mode, position: FilePosition(0), size: sizeResult.value)
    }
    
    public func map(order: ByteOrder, mode: MapMode, position: FilePosition, size: FileSize) -> Result<ByteBuffer> {
        var pointer: UnsafeMutablePointer<()>
        switch mode {
        case .Private:
            pointer = mmap(UnsafeMutablePointer<UInt8>(0), UInt(size), PROT_READ | PROT_WRITE, MAP_PRIVATE, fileDescriptor, position)
        case .ReadOnly:
            pointer = mmap(UnsafeMutablePointer<UInt8>(0), UInt(size), PROT_READ, MAP_SHARED, fileDescriptor, position)
        case .ReadWrite:
            pointer = mmap(UnsafeMutablePointer<UInt8>(0), UInt(size), PROT_READ | PROT_WRITE, MAP_SHARED, fileDescriptor, position)

        }
        if pointer == UnsafePointer<()>(-1) { return .Failure(Error(code: errno)) }
        return .Success(ByteBuffer(order: order, data: UnsafeMutablePointer<UInt8>(pointer), capacity: Int(size), freeOnDeinit: false))
    }
    
    public func unmap(buffer: ByteBuffer) -> Result<Bool> {
        let result = munmap(buffer.data, UInt(buffer.capacity))
        if result < 0 { return .Failure(Error(code: errno)) }
        return .Success(true)
    }
}
