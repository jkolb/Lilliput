# Lilliput

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## ChangeLog

###### 6.0.0
* Attempt to make sure unaligned memory is not accessed directly. The goal of this library is to read from files or other non-platform specific places that generally don't impose a specific alignment while still working on platforms that may crash on unaligned memory access.
* Changed API so that getXAt becomes getX(at:) (For example: getUInt32(at: 13))
* Added getInt24, getUInt24, putInt24, and putUInt24 (all of these are endian order independent as they rely on reading/writing three consecutive bytes)

###### 5.0.0
* Swift 4 support

###### 4.0.3
* Forgot to push some changes

###### 4.0.2
* Remove usages of `@inline(__always)`, will not compile on Linux
* Fixed POSIXError so that it will compile on Linux

###### 4.0.1
* Performance enhancements (10+ seconds on a project I'm working on)

###### 4.0.0
* Got rid of ByteSize, FilePosition, and FilePath abstractions.
* Renamed ByteBuffer to UnsafeOrderedBuffer.
* Renamed Buffer to UnsafeBuffer.
* No longer attempt to work with Foundation, the API is awkward and it currently has bugs.
* Fixed permission issue with creating files using POSIXFileSystem.
* Removed the limit and mark functionality from UnsafeOrderedBuffer.
* Fix missing shared scheme required for Carthage support.
* Rebuilt project file using Xcode 8.1 version of SwiftPM.

###### 3.0.0
* Updated to Swift 3.
* Support for Swift Package Manager.
* Foundation Data now conforms to Buffer protocol.

###### 2.0.0
* Added back in support for reading and writing files based on a generic protocols so that it should be easy to port to any operating system. Currently supports POSIX on Linux and OS X.
* Added protocol to abstract out a generic memory buffer that tracks its size, and a protocol to abstract out generating buffers. Currently supports POSIX memory allocation on Linux and OS X.
* Byte buffer now takes its byte order as a generic parameter, this should speed up operations as order is now known at compile time.
* Simplified byte order to just use 3 swap methods.
* Removed hex, oct, etc. string conversion utility methods.

###### 1.1.3
Provide accessor for direct access to the buffer's memory.

###### 1.1.2
Forgot to update README.

###### 1.1.1
Minor improvements and fixes.

###### 1.1.0
Updated to support Swift 2.

###### 1.0.5
Have to check for "arm" also to prevent compile errors on 32-bit devices.

###### 1.0.4
Missed two more tests that will not compile on 32-bit devices.

###### 1.0.3
Add compile configuration protection around tests that won't compile on 32-bit devices.

###### 1.0.2
Attempting to allow building for both iOS and OSX using one project file.


## Description

[Lilliput](http://en.wikipedia.org/wiki/Lilliput_and_Blefuscu) is a native [Swift](http://en.wikipedia.org/wiki/Jonathan_Swift) framework for working with binary data of varying [endianness](http://en.wikipedia.org/wiki/Endianness). For example you can use it to do custom loading of [PNG](http://www.libpng.org/pub/png/spec/1.2/PNG-DataRep.html#DR.Integers-and-byte-order) files which are written in big endian byte order, or tinker with reverse engineering [game](https://www.asheronscall.com) [data](http://www.ugcs.caltech.edu/~dsimpson/) files which is what I use it for.
Functionality is loosely based on similar functionality found in Java.

## Examples

**Putting and getting a big endian 32 bit integer**

    let memory = POSIXMemory()
    let buffer = memory.buferWithSize(100, order: BigEndian.self)
    buffer.putUInt32(1024) // Put this value at the current position of the buffer
    buffer.flip() // Reset the position to 0 and set the limit to 4 (the amout of bytes written)
    let value = buffer.getUInt32() // Get the value at the current position of the buffer



**Rough parsing of a PNG file**

    let filesystem = POSIXFileSystem()
    let path = filesystem.parsePath("image.png")
    let channel = try filesystem.openPath(path, [.Read])
    let memory = POSIXMemory()
    let buffer = memory.buferWithSize(4096, order: BigEndian.self)
    let bytesRead = try channel.readByteBuffer(buffer)

    if bytesRead < PNGHeaderLength {
        throw PNGError.MissingHeader
    }

    buffer.flip() // Must flip before reading after you fill the buffer
    let signature = buffer.getUInt8(8)

    if signature != [UInt8][137, 80, 78, 71, 13, 10, 26, 10] {
        throw PNGError.NotAPNG
    }

    let chunkLength = buffer.getUInt32()
    let chunkType = buffer.getUInt8(4)
    let chunkData = buffer.getUInt8(chunkLength)
    let chunkCRC = buffer.getUInt32()

## Installation

Can install via Carthage, or by dragging and dropping the project file into your project.

## Contact

[Justin Kolb](https://github.com/jkolb)  
[@nabobnick](https://twitter.com/nabobnick)

## License

Lilliput is available under the MIT license. See the LICENSE file for more info.
