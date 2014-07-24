Lilliput
========

A native Swift framework for working with binary data of varying endianness

There are three types:

*ByteOrder* - Handles converting values between little and big endianness

*ByteBuffer* - A collection of bytes with a specific byte order

*BinaryFile* - A wrapper around POSIX file descriptors that makes it easy to read, write, or map ByteBuffer instances

ByteOrder and ByteBuffer are loosely based on similar ones found in Java of the same name, so knowledge of them should help you here. BinaryFile is based off of a combination of FileChannel and RandomAccessFile.


Examples
========

    // Putting and getting a big endian 32 bit integer
    let buffer = ByteBuffer(order: BigEndian(), capacity: 100)
    buffer.putUInt32(1024) // Put this value at the current position of the buffer
    buffer.flip() // Reset the position to 0 and set the limit to 4 (the amout of bytes written)
    let value = buffer.getUInt32() // Get the value at the current position of the buffer
    
    
    // Parsing a PNG file
    let openResult = BinaryFile.openForReading("path to png file")
    
    if let error = openResult.error {
        println(error.code)
        return
    }
    
    let file = openResult.value
    let buffer = ByteBuffer(order: BigEndian(), capacity: 4096)
    let readResult = file.readBuffer(buffer)
    
    if let error = readResult.error {
        println(error.code)
        return
    }
    
    let bytesRead = readResult.value
    buffer.flip() // buffer.limit should now match bytesRead
    let signature = buffer.getUInt8(8)
    
    if signature != [UInt8][137, 80, 78, 71, 13, 10, 26, 10] {
        println("Not a PNG file")
        return
    }
    
    let chunkLength = buffer.getUInt32()
    let chunkType = buffer.getUInt8(4)
    let chunkData = buffer.getUInt8(chunkLength)
    let chunkCRC = buffer.getUInt32()
