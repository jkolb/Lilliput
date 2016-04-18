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

public class POSIXFileManager : FileManager {
    public func open(path: String, options: FileOpenOption) throws -> SeekableByteChannel {
        #if os(Linux)
            let fileDescriptor = Glibc.open(path, openFlags(options))
        #else
            let fileDescriptor = Darwin.open(path, openFlags(options))
        #endif
        
        if fileDescriptor < 0 {
            throw POSIXError(code: errno)
        }
        
        return POSIXFileChannel(fileDescriptor: fileDescriptor)
    }
    
    @warn_unused_result
    public func openFlags(options: FileOpenOption) -> CInt {
        var openFlags: CInt = 0
        
        if options.contains(.Read) && options.contains(.Write) {
            openFlags |= O_RDWR
        }
        else if options.contains(.Read) {
            openFlags |= O_RDONLY
        }
        else if options.contains(.Write) {
            openFlags |= O_WRONLY
        }
        
        if options.contains(.Append) {
            openFlags |= O_APPEND
        }
        
        if options.contains(.Create) {
            openFlags |= O_CREAT
        }
        else if options.contains(.CreateNew) {
            openFlags |= (O_CREAT | O_EXCL)
        }
        
        if options.contains(.Truncate) {
            openFlags |= O_TRUNC
        }
        
        return openFlags
    }
}
