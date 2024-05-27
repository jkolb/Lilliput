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
    
    @inlinable public subscript(bounds: Range<Int>) -> UnsafeMutableRawBufferPointer {
        return UnsafeMutableRawBufferPointer(rebasing: bytes[bounds])
    }

    @inlinable public subscript<R>(r: R) -> UnsafeMutableRawBufferPointer where R : RangeExpression, Int == R.Bound {
        return self[r.relative(to: bytes.indices)]
    }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> UnsafeMutableRawBufferPointer {
        return bytes
    }
    
    @inlinable public subscript(start: Int , count countValue: Int) -> UnsafeMutableRawBufferPointer {
        return UnsafeMutableRawBufferPointer(rebasing: UnsafeMutableRawBufferPointer(rebasing: bytes[start...])[..<countValue])
    }
}

extension ByteBuffer : CollectionByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> ByteBuffer {
        let buffer = ByteBuffer(count: count)
        buffer[...].copyMemory(from: try reader.read(count).buffer)
        return buffer
    }
}

extension ByteBuffer : ByteEncoder {
    @inlinable public static func encode<W>(_ value: ByteBuffer, to writer: inout W) throws where W : ByteWriter {
        let span = ByteSpan(value[...])
        try writer.write(span)
    }
}
