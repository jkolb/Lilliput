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

typealias FileOffset = off_t
typealias FilePosition = off_t
typealias ErrorCode = Int32
typealias FileDescriptor = Int32
typealias ByteCount = Int

class BinaryFile {
    let fileDescriptor: FileDescriptor
    let closeOnDeinit: Bool

    struct Error {
        let code: ErrorCode
        let message: String
        
        init(code: ErrorCode, message: String = "") {
            self.code = code
            self.message = message
        }
    }
    
    enum Result<T> {
        case Success(@auto_closure () -> T)
        case Failure(Error)
        
        var error: Error? {
            switch self {
            case .Success:
                return nil
            case .Failure(let error):
                return error
            }
        }
        
        var value: T! {
            switch self {
            case .Success(let value):
                return value()
            case .Failure:
                return nil
            }
        }
    }
    
    class func openForReading(path: String) -> Result<BinaryFile> {
        return openBinaryFile(path, flags: O_RDONLY)
    }
    
    class func openForWriting(path: String) -> Result<BinaryFile> {
        return openBinaryFile(path, flags: O_WRONLY)
    }
    
    class func openForUpdating(path: String) -> Result<BinaryFile> {
        return openBinaryFile(path, flags: O_RDWR)
    }
    
    class func openBinaryFile(path: String, flags: CInt) -> Result<BinaryFile> {
        let fileDescriptor = path.withCString { open($0, flags) }
        if (fileDescriptor == -1) { return .Failure(Error(code: errno)) }
        return .Success(BinaryFile(fileDescriptor: fileDescriptor))
    }
    
    init(fileDescriptor: FileDescriptor, closeOnDeinit: Bool = true) {
        assert(fileDescriptor >= 0)
        self.fileDescriptor = fileDescriptor
        self.closeOnDeinit = closeOnDeinit
    }
    
    deinit {
        if (closeOnDeinit) { close(fileDescriptor) }
    }
    
    func readBuffer(buffer: ByteBuffer) -> Result<ByteCount> {
        let bytesRead = read(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        if (bytesRead < 0) { return .Failure(Error(code: errno)) }
        buffer.position += bytesRead
        return .Success(bytesRead)
    }
    
    enum WriteResult {
        case BytesWritten(Int)
        case Error(ErrorCode)
    }
    
    func writeBuffer(buffer: ByteBuffer) -> Result<ByteCount> {
        let bytesWritten = write(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        if (bytesWritten < 0) { return .Failure(Error(code: errno)) }
        buffer.position += bytesWritten
        return .Success(bytesWritten)
    }
    
    enum SeekFrom {
        case Start
        case Current
        case End
    }
    
    func seek(offset: FileOffset, from: SeekFrom = .Start) -> Result<FilePosition> {
        var position: FilePosition
        
        switch from {
        case .Start:
            position = lseek(fileDescriptor, offset, SEEK_SET)
        case .Current:
            position = lseek(fileDescriptor, offset, SEEK_CUR)
        case .End:
            position = lseek(fileDescriptor, offset, SEEK_END)
        }
        
        if (offset < 0) { return .Failure(Error(code: errno)) }
        
        return .Success(position)
    }
}
