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

#if os(Linux)
    
    import Glibc

    final class POSIX {
        static let SEEK_SET = Glibc.SEEK_SET
        static let SEEK_CUR = Glibc.SEEK_CUR
        static let SEEK_END = Glibc.SEEK_END
        
        static var errno: Int32 {
            return Glibc.errno
        }

        static func open(_ path: UnsafePointer<CChar>, _ oflag: Int32, _ mode: mode_t) -> Int32 {
            return Glibc.open(path, oflag, mode)
        }
        
        static func close(_ filedes: Int32) -> Int32 {
            return Glibc.close(filedes)
        }
        
        static func read(_ filedes: Int32, _ buf: UnsafeMutableRawPointer!, _ nbyte: Int) -> Int {
            return Glibc.read(filedes, buf, nbyte)
        }
        
        static func write(_ filedes: Int32, _ buf: UnsafeRawPointer!, _ nbyte: Int) -> Int {
            return Glibc.write(filedes, buf, nbyte)
        }
        
        static func lseek(_ filedes: Int32, _ offset: off_t, _ whence: Int32) -> off_t {
            return Glibc.lseek(filedes, offset, whence)
        }
        
        static func ftruncate(_ filedes: Int32, _ length: off_t) -> Int32 {
            return Glibc.ftruncate(filedes, length)
        }
        
        static func strerror(_ errnum: Int32) -> UnsafeMutablePointer<Int8>! {
            return Glibc.strerror(errnum)
        }
    }
    
#elseif os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    
    import Darwin

    final class POSIX {
        static let O_RDONLY = Darwin.O_RDONLY
        static let O_WRONLY = Darwin.O_WRONLY
        static let O_RDWR = Darwin.O_RDWR
        static let O_CREAT = Darwin.O_CREAT
        
        static let SEEK_SET = Darwin.SEEK_SET
        static let SEEK_CUR = Darwin.SEEK_CUR
        static let SEEK_END = Darwin.SEEK_END
        
        static var errno: Int32 {
            return Darwin.errno
        }
        
        static func open(_ path: UnsafePointer<CChar>, _ oflag: Int32, _ mode: mode_t) -> Int32 {
            return Darwin.open(path, oflag, mode)
        }
        
        static func close(_ filedes: Int32) -> Int32 {
            return Darwin.close(filedes)
        }
        
        static func read(_ filedes: Int32, _ buf: UnsafeMutableRawPointer!, _ nbyte: Int) -> Int {
            return Darwin.read(filedes, buf, nbyte)
        }
        
        static func write(_ filedes: Int32, _ buf: UnsafeRawPointer!, _ nbyte: Int) -> Int {
            return Darwin.write(filedes, buf, nbyte)
        }
        
        static func lseek(_ filedes: Int32, _ offset: off_t, _ whence: Int32) -> off_t {
            return Darwin.lseek(filedes, offset, whence)
        }
        
        static func ftruncate(_ filedes: Int32, _ length: off_t) -> Int32 {
            return Darwin.ftruncate(filedes, length)
        }
        
        static func strerror(_ errnum: Int32) -> UnsafeMutablePointer<Int8>! {
            return Darwin.strerror(errnum)
        }
    }
    
#endif
