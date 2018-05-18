# Lilliput

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## ChangeLog

### 9.1.0
* Renamed ByteOutputStream write methods to mirror ByteInputStream read methods.

### 9.0.0
* Updated Examples
* File API stayed the same, but buffer API has changed drastically (again)
* Addded UnalignedAccess extension for UnsafeRawPointer and UnsafeMutableRawPointer
* Addded ByteBuffer, MemoryBuffer, OrderedBuffer, WrappedBuffer
* Addded ByteInputStream, BufferInputStream, OrderedInputStream
* Addded ByteOutputStream, BufferOutputStream, OrderedOutputStream
* Removed support for odd types like 24bits & strings to concentrate on the most generic interface

### 8.0.0
* Another API change.
* BinaryFile now a concrete platform specific class.
* FileFactory was removed.
* Improved performance by removing generic usages of FixedWidthInteger.
* Improved performance by making use of copyBytes method.

### 7.1.0
* Fix dumb bug
* Rename buffer copy methods

### 7.0.0
* Major API change.
* Reduced number of protocols.
* Removed lots of cruft.
* Use FixedWidthInteger protocol to share more code.
* Separate POSIX specific code into its own module.

### 6.0.0
* Attempt to make sure unaligned memory is not accessed directly. The goal of this library is to read from files or other non-platform specific places that generally don't impose a specific alignment while still working on platforms that may crash on unaligned memory access.
* Changed API so that getXAt becomes getX(at:) (For example: getUInt32(at: 13))
* Added getInt24, getUInt24, putInt24, and putUInt24 (all of these are endian order independent as they rely on reading/writing three consecutive bytes)

### 5.0.0
* Swift 4 support

### 4.0.3
* Forgot to push some changes

### 4.0.2
* Remove usages of `@inline(__always)`, will not compile on Linux
* Fixed POSIXError so that it will compile on Linux

### 4.0.1
* Performance enhancements (10+ seconds on a project I'm working on)

### 4.0.0
* Got rid of ByteSize, FilePosition, and FilePath abstractions.
* Renamed ByteBuffer to UnsafeOrderedBuffer.
* Renamed Buffer to UnsafeBuffer.
* No longer attempt to work with Foundation, the API is awkward and it currently has bugs.
* Fixed permission issue with creating files using POSIXFileSystem.
* Removed the limit and mark functionality from UnsafeOrderedBuffer.
* Fix missing shared scheme required for Carthage support.
* Rebuilt project file using Xcode 8.1 version of SwiftPM.

### 3.0.0
* Updated to Swift 3.
* Support for Swift Package Manager.
* Foundation Data now conforms to Buffer protocol.

### 2.0.0
* Added back in support for reading and writing files based on a generic protocols so that it should be easy to port to any operating system. Currently supports POSIX on Linux and OS X.
* Added protocol to abstract out a generic memory buffer that tracks its size, and a protocol to abstract out generating buffers. Currently supports POSIX memory allocation on Linux and OS X.
* Byte buffer now takes its byte order as a generic parameter, this should speed up operations as order is now known at compile time.
* Simplified byte order to just use 3 swap methods.
* Removed hex, oct, etc. string conversion utility methods.

### 1.1.3
Provide accessor for direct access to the buffer's memory.

### 1.1.2
Forgot to update README.

### 1.1.1
Minor improvements and fixes.

### 1.1.0
Updated to support Swift 2.

### 1.0.5
Have to check for "arm" also to prevent compile errors on 32-bit devices.

### 1.0.4
Missed two more tests that will not compile on 32-bit devices.

### 1.0.3
Add compile configuration protection around tests that won't compile on 32-bit devices.

### 1.0.2
Attempting to allow building for both iOS and OSX using one project file.


## Description

[Lilliput](http://en.wikipedia.org/wiki/Lilliput_and_Blefuscu) is a native [Swift](http://en.wikipedia.org/wiki/Jonathan_Swift) framework for working with binary data of varying [endianness](http://en.wikipedia.org/wiki/Endianness). For example you can use it to do custom loading of [PNG](http://www.libpng.org/pub/png/spec/1.2/PNG-DataRep.html#DR.Integers-and-byte-order) files which are written in big endian byte order, or tinker with reverse engineering [game](https://www.asheronscall.com) [data](https://github.com/jkolb/Asheron) files which is what I use it for.

## Examples

**Open and read a file into a little endian buffer**

    let binaryFile = try BinaryFile.open(forUpdatingAtPath: path, create: false)
    let headerBytes = OrderedBuffer<LittleEndian>(count: 1024)
    let readCount = try binaryFile.read(into: headerBytes)
        
    if readCount < headerBytes.count {
        // Handle error
    }
        
    let value1 = headerBytes.getUInt32(at: 0)
    let value2 = headerBytes.getInt8(at: 4)

**Open and read a file into a big endian byte input stream**

    let binaryFile = try BinaryFile.open(forReadingAtPath: path)
    let headerBytes = MemoryBuffer(count: 1024)
    let readCount = try binaryFile.read(into: headerBytes)
        
    if readCount < headerBytes.count {
        // Handle error
    }
        
    let stream = OrderedInputStream<BigEndian>(stream: BufferInputStream(buffer: headerBytes))
    let value1 = try stream.readUInt32()
    let value2 = try stream.readFloat32()


**Open and write to a file into native byte output stream**

    let binaryFile = try BinaryFile.open(forWritingAtPath: path, create: true)
    let headerBytes = MemoryBuffer(count: 1024)    
    let stream = BufferOutputStream(buffer: headerBytes)
    try stream.writeUInt32(4)
    try stream.writeFloat32(3.14)
    let writeCount = try binaryFile.write(from: headerBytes, count: 8)

## Installation

Can install via Carthage, as a Swift package, or by dragging and dropping the project file into your project.

## Contact

[Justin Kolb](https://github.com/jkolb)  
[@nabobnick](https://twitter.com/nabobnick)

## License

Lilliput is available under the MIT license. See the LICENSE file for more info.
