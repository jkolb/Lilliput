import SystemPackage

public extension FileDescriptor {
    @inlinable func readAll(into buffer: UnsafeMutableRawBufferPointer, retryOnInterrupt: Bool = true) throws {
        let bytesRead = try read(into: buffer, retryOnInterrupt: retryOnInterrupt)
        
        guard bytesRead == buffer.count else {
            throw ByteError.notEnoughBytes
        }
    }
    
    @inlinable func readAll(fromAbsoluteOffset offset: Int64, into buffer: UnsafeMutableRawBufferPointer, retryOnInterrupt: Bool = true) throws {
        let bytesRead = try read(fromAbsoluteOffset: offset, into: buffer, retryOnInterrupt: retryOnInterrupt)
        
        guard bytesRead == buffer.count else {
            throw ByteError.notEnoughBytes
        }
    }
}
