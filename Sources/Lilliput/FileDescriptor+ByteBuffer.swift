import SystemPackage

public extension FileDescriptor {
    @inlinable func read(into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try buffer.slice(...) { bytes in
            return try read(into: bytes, retryOnInterrupt:  retryOnInterrupt)
        }
    }
    
    @inlinable func readAll(into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws {
        return try buffer.slice(...) { bytes in
            return try readAll(into: bytes, retryOnInterrupt:  retryOnInterrupt)
        }
    }
    
    @inlinable func read(fromAbsoluteOffset offset: Int64, into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try buffer.slice(...) { bytes in
            return try read(fromAbsoluteOffset: offset, into: bytes, retryOnInterrupt:  retryOnInterrupt)
        }
    }
    
    @inlinable func readAll(fromAbsoluteOffset offset: Int64, into buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws {
        return try buffer.slice(...) { bytes in
            return try readAll(fromAbsoluteOffset: offset, into: bytes, retryOnInterrupt:  retryOnInterrupt)
        }
    }
    
    @inlinable func write(_ buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try buffer.slice(...) { bytes in
            return try write(UnsafeRawBufferPointer(bytes), retryOnInterrupt: retryOnInterrupt)
        }
    }

    @inlinable func write(toAbsoluteOffset offset: Int64, _ buffer: ByteBuffer, retryOnInterrupt: Bool = true) throws -> Int {
        return try buffer.slice(...) { bytes in
            return try write(toAbsoluteOffset: offset, UnsafeRawBufferPointer(bytes), retryOnInterrupt: retryOnInterrupt)
        }
    }
    
    @inlinable func writeAll(_ buffer: ByteBuffer) throws {
        return try buffer.slice(...) { bytes in
            try writeAll(bytes)
        }
    }
    
    @inlinable func writeAll(toAbsoluteOffset offset: Int64, _ buffer: ByteBuffer) throws {
        return try buffer.slice(...) { bytes in
            try writeAll(toAbsoluteOffset: offset, bytes)
        }
    }
}
