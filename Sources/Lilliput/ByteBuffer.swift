public final class ByteBuffer {
    @usableFromInline let bytes: UnsafeMutableRawBufferPointer
    
    public var count: Int {
        return bytes.count
    }
    
    @inlinable public init(count: Int) {
        self.bytes = UnsafeMutableRawBufferPointer.allocate(byteCount: count, alignment: 1)
    }
    
    deinit {
        bytes.deallocate()
    }
    
    @inlinable public func slice<T>(_ bounds: Range<Int>, body: (UnsafeMutableRawBufferPointer) throws -> T) rethrows -> T {
        return try body(UnsafeMutableRawBufferPointer(rebasing: bytes[bounds]))
    }

    @inlinable public func slice<R: RangeExpression, T>(_ r: R, body: (UnsafeMutableRawBufferPointer) throws -> T) rethrows -> T where Int == R.Bound {
        return try slice(r.relative(to: bytes.indices), body: body)
    }

    @inlinable public func slice<T>(_ x: (UnboundedRange_) -> (), body: (UnsafeMutableRawBufferPointer) throws -> T) rethrows -> T {
        return try body(bytes)
    }
    
    @inlinable public func slice<T>(start: Int , count: Int, body: (UnsafeMutableRawBufferPointer) throws -> T) rethrows -> T {
        return try body(UnsafeMutableRawBufferPointer(rebasing: UnsafeMutableRawBufferPointer(rebasing: bytes[start...])[..<count]))
    }
}

extension ByteBuffer : CollectionByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> ByteBuffer {
        let buffer = ByteBuffer(count: count)
        try buffer.slice(...) { $0.copyMemory(from: try reader.read(count).buffer) }
        return buffer
    }
}

extension ByteBuffer : ByteEncoder {
    @inlinable public static func encode<W>(_ buffer: ByteBuffer, to writer: inout W) throws where W : ByteWriter {
        try buffer.slice(...) {
            let span = ByteSpan($0)
            try writer.write(span)
        }
    }
}
