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

class BinaryFile {
    let fileDescriptor: FileDescriptor
    let closeOnDeinit: Bool
    
    enum OpenResult {
        case File(BinaryFile)
        case Error(ErrorCode)
    }
    
    class func openForReading(path: String) -> OpenResult {
        return openBinaryFile(path, flags: O_RDONLY)
    }
    
    class func openForWriting(path: String) -> OpenResult {
        return openBinaryFile(path, flags: O_WRONLY)
    }
    
    class func openForUpdating(path: String) -> OpenResult {
        return openBinaryFile(path, flags: O_RDWR)
    }
    
    class func openBinaryFile(path: String, flags: CInt) -> OpenResult {
        let fileDescriptor = path.withCString { open($0, flags) }
        if (fileDescriptor == -1) { return .Error(errno) }
        return .File(BinaryFile(fileDescriptor: fileDescriptor))
    }
    
    init(fileDescriptor: FileDescriptor, closeOnDeinit: Bool = true) {
        assert(fileDescriptor >= 0)
        self.fileDescriptor = fileDescriptor
        self.closeOnDeinit = closeOnDeinit
    }
    
    deinit {
        if (closeOnDeinit) { close(fileDescriptor) }
    }
    
    enum ReadResult {
        case BytesRead(Int)
        case Error(ErrorCode)
    }
    
    func readBuffer(buffer: ByteBuffer) -> ReadResult {
        let bytesRead = read(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        if (bytesRead < 0) { return .Error(errno) }
        buffer.position += bytesRead
        return .BytesRead(bytesRead)
    }
    
    enum WriteResult {
        case BytesWritten(Int)
        case Error(ErrorCode)
    }
    
    func writeBuffer(buffer: ByteBuffer) -> WriteResult {
        let bytesWritten = write(fileDescriptor, buffer.data + buffer.position, UInt(buffer.remaining))
        if (bytesWritten < 0) { return .Error(errno) }
        buffer.position += bytesWritten
        return .BytesWritten(bytesWritten)
    }
    
    enum SeekResult {
        case Position(FilePosition)
        case Error(ErrorCode)
    }
    
    enum SeekFrom {
        case Start
        case Current
        case End
    }
    
    func seek(offset: FileOffset, from: SeekFrom = .Start) -> SeekResult {
        var position: FilePosition
        
        switch from {
        case .Start:
            position = lseek(fileDescriptor, offset, SEEK_SET)
        case .Current:
            position = lseek(fileDescriptor, offset, SEEK_CUR)
        case .End:
            position = lseek(fileDescriptor, offset, SEEK_END)
        }
        
        if (offset < 0) { return .Error(errno) }
        
        return .Position(position)
    }
}
