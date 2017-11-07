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

public typealias ReadOnlyFile = ReadableFile & SeekableFile
public typealias WriteOnlyFile = WritableFile & SeekableFile
public typealias ReadWriteFile = ReadableFile & WritableFile & SeekableFile

#if os(Linux) || os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    
#if os(Linux)
    import Glibc
#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#endif
    
    public final class BinaryFile : ReadWriteFile {
        private let fd: Int32
        
        public static func open(forReadingAtPath path: String) throws -> ReadOnlyFile {
            return BinaryFile(fd: try open(path: path, flags: O_RDONLY))
        }
        
        public static func open(forWritingAtPath path: String, create: Bool) throws -> WriteOnlyFile {
            return BinaryFile(fd: try open(path: path, flags: create ? (O_WRONLY | O_CREAT) : O_WRONLY))
        }
        
        public static func open(forUpdatingAtPath path: String, create: Bool) throws -> ReadWriteFile {
            return BinaryFile(fd: try open(path: path, flags: create ? (O_RDWR | O_CREAT) : O_RDWR))
        }
        
        private init(fd: Int32) {
            self.fd = fd
        }
        
        private static func open(path: String, flags: Int32) throws -> Int32 {
            #if os(Linux)
                let fd = Glibc.open(path, flags, 0o666)
            #elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                let fd = Darwin.open(path, flags, 0o666)
            #endif
            
            if fd < 0 {
                throw POSIXError()
            }
            
            return fd
        }
        
        deinit {
            let _ = close(fd)
        }
        
        public func read(into buffer: UnsafeMutableRawPointer, count: Int) throws -> Int {
            precondition(count >= 0)
            
            #if os(Linux)
                let result = Glibc.read(fd, buffer, count)
            #elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                let result = Darwin.read(fd, buffer, count)
            #endif
            
            if result < 0 {
                throw POSIXError()
            }
            
            return result
        }
        
        public func write(from buffer: UnsafeRawPointer, count: Int) throws -> Int {
            precondition(count >= 0)
            
            #if os(Linux)
                let result = Glibc.write(fd, buffer, count)
            #elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                let result = Darwin.write(fd, buffer, count)
            #endif
            
            if result < 0 {
                throw POSIXError()
            }
            
            return result
        }
        
        public func setEndOfFile(position: Int) throws {
            precondition(position >= 0)
            
            let result = ftruncate(fd, numericCast(position))
            
            if result < 0 {
                throw POSIXError()
            }
        }
        
        public var position: Int {
            get {
                let result = lseek(fd, 0, SEEK_CUR)
                
                if result < 0 {
                    fatalError("Unexpected: (\(POSIXError())")
                }
                
                return numericCast(result)
            }
            set {
                precondition(newValue >= 0)
                
                let result = lseek(fd, numericCast(newValue), SEEK_SET)
                
                if result < 0 {
                    fatalError("Unexpected: (\(POSIXError())")
                }
            }
        }
        
        public func seek(offsetFromCurrent: Int) throws {
            let result = lseek(fd, numericCast(offsetFromCurrent), SEEK_CUR)
            
            if result < 0 {
                throw POSIXError()
            }
        }
        
        public func seek(offsetFromEnd: Int) throws {
            let result = lseek(fd, numericCast(offsetFromEnd), SEEK_END)
            
            if result < 0 {
                throw POSIXError()
            }
        }
    }
    
    public struct POSIXError : Error, CustomStringConvertible {
        public let code: Int32
        
        public init() {
            self.init(code: errno)
        }
        
        public init(code: Int32) {
            self.code = code
        }
        
        public var description: String {
            if let message = String(validatingUTF8: strerror(code)) {
                return "errno: \(code): \(message)"
            }
            else {
                return "errno: \(code)"
            }
        }
    }
    
#endif
