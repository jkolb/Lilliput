import SystemPackage

public extension FileDescriptor {
    @inlinable func read(into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try read(into: buffer[...], retryOnInterrupt:  retryOnInterrupt)
    }
    
    @inlinable func readAll(into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws {
        return try readAll(into: buffer[...], retryOnInterrupt: retryOnInterrupt)
    }
    
    @inlinable func read(fromAbsoluteOffset offset: Int64, into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try read(fromAbsoluteOffset: offset, into: buffer[...], retryOnInterrupt: retryOnInterrupt)
    }
    
    @inlinable func readAll(fromAbsoluteOffset offset: Int64, into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws {
        return try readAll(fromAbsoluteOffset: offset, into: buffer[...], retryOnInterrupt: retryOnInterrupt)
    }
    
    @inlinable func write(_ buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try write(UnsafeRawBufferPointer(buffer[...]), retryOnInterrupt: retryOnInterrupt)
    }

    @inlinable func write(toAbsoluteOffset offset: Int64, _ buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try write(toAbsoluteOffset: offset, UnsafeRawBufferPointer(buffer[...]), retryOnInterrupt: retryOnInterrupt)
    }
    
    @inlinable func writeAll(_ buffer: ByteBuffer) throws {
        try writeAll(buffer[...])
    }
    
    @inlinable func writeAll(toAbsoluteOffset offset: Int64, _ buffer: ByteBuffer) throws {
        try writeAll(toAbsoluteOffset: offset, buffer[...])
    }
}
