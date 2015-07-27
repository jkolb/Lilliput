Lilliput 1.1.0
==============

####ChangeLog

######1.1.0
Updated to support Swift 2.

######1.0.5
Have to check for "arm" also to prevent compile errors on 32-bit devices.

######1.0.4
Missed two more tests that will not compile on 32-bit devices.

######1.0.3
Add compile configuration protection around tests that won't compile on 32-bit devices.

######1.0.2
Attempting to allow building for both iOS and OSX using one project file.

============
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[Lilliput](http://en.wikipedia.org/wiki/Lilliput_and_Blefuscu) is a native [Swift](http://en.wikipedia.org/wiki/Jonathan_Swift) framework for working with binary data of varying [endianness](http://en.wikipedia.org/wiki/Endianness). For example you can use it to do custom loading of [PNG](http://www.libpng.org/pub/png/spec/1.2/PNG-DataRep.html#DR.Integers-and-byte-order) files which are written in big endian byte order, or tinker with reverse engineering [game](https://www.asheronscall.com) [data](http://www.ugcs.caltech.edu/~dsimpson/) files which is what I use it for.

There are only two types in the framework:

**ByteOrder** - Handles converting values between little and big endianness

**ByteBuffer** - A collection of bytes with a specific byte order

[ByteOrder](http://docs.oracle.com/javase/7/docs/api/java/nio/ByteOrder.html) and [ByteBuffer](http://docs.oracle.com/javase/7/docs/api/java/nio/ByteBuffer.html) are loosely based on similar classes found in Java of the same name, so [knowledge](http://lmgtfy.com/?q=java+byte+buffer+tutorial) of them should help you here.

Examples
========

**Putting and getting a big endian 32 bit integer**

    let buffer = ByteBuffer(order: BigEndian(), capacity: 100)
    buffer.putUInt32(1024) // Put this value at the current position of the buffer
    buffer.flip() // Reset the position to 0 and set the limit to 4 (the amout of bytes written)
    let value = buffer.getUInt32() // Get the value at the current position of the buffer
    
    

**Rough parsing of a PNG file**

    let pngBuffer = ByteBuffer(order: BigEndian(), capacity: 4096) // Filled from a file
    buffer.flip() // Must flip before reading after you write to a buffer
    let signature = buffer.getUInt8(8)
    
    if signature != [UInt8][137, 80, 78, 71, 13, 10, 26, 10] {
        println("Not a PNG file")
        return
    }
    
    let chunkLength = buffer.getUInt32()
    let chunkType = buffer.getUInt8(4)
    let chunkData = buffer.getUInt8(chunkLength)
    let chunkCRC = buffer.getUInt32()

Installation
============

Can install via Carthage, or by dragging and dropping the project file into your project.

Contact
=======

[Justin Kolb](https://github.com/jkolb)  
[@nabobnick](https://twitter.com/nabobnick)

License
=======

Lilliput is available under the MIT license. See the LICENSE file for more info.
