public struct ByteSpan {
    public let buffer: UnsafeRawBufferPointer
    
    @inlinable public init(_ mutableBuffer: UnsafeMutableRawBufferPointer) {
        self.init(UnsafeRawBufferPointer(mutableBuffer))
    }
    
    @inlinable public init(_ slice: Slice<UnsafeRawBufferPointer>) {
        self.init(UnsafeRawBufferPointer(rebasing: slice))
    }
    
    @inlinable public init(_ buffer: UnsafeRawBufferPointer) {
        self.buffer = buffer
    }
    
    @inlinable public var bytes: UnsafeBufferPointer<UInt8> {
        return buffer.assumingMemoryBound(to: UInt8.self)
    }
    
    @inlinable public var count: Int {
        return buffer.count
    }
    
    @inlinable public subscript(offset: Int) -> UInt8 {
        return buffer[offset]
    }
    
    @inlinable public subscript(bounds: Range<Int>) -> ByteSpan {
        return ByteSpan(buffer[bounds])
    }

    @inlinable public subscript<R: RangeExpression>(r: R) -> ByteSpan where Int == R.Bound {
        return self[r.relative(to: buffer.indices)]
    }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> ByteSpan {
        return self
    }
    
    @inlinable public subscript(start: Int , count countValue: Int) -> ByteSpan {
        return self[start...][..<countValue]
    }
}

public struct MutableByteSpan {
    public let buffer: UnsafeMutableRawBufferPointer
    
    @inlinable public init(_ slice: Slice<UnsafeMutableRawBufferPointer>) {
        self.init(UnsafeMutableRawBufferPointer(rebasing: slice))
    }
    
    @inlinable public init(_ buffer: UnsafeMutableRawBufferPointer) {
        self.buffer = buffer
    }
    
    @inlinable public var bytes: UnsafeMutableBufferPointer<UInt8> {
        return buffer.assumingMemoryBound(to: UInt8.self)
    }
    
    @inlinable public var count: Int {
        return buffer.count
    }
    
    @inlinable public subscript(offset: Int) -> UInt8 {
        get {
            return buffer[offset]
        }
        set {
            buffer[offset] = newValue
        }
    }
    
    @inlinable public subscript(bounds: Range<Int>) -> MutableByteSpan {
        return MutableByteSpan(buffer[bounds])
    }

    @inlinable public subscript<R: RangeExpression>(r: R) -> MutableByteSpan where Int == R.Bound {
        return self[r.relative(to: buffer.indices)]
    }

    @inlinable public subscript(x: (UnboundedRange_) -> ()) -> MutableByteSpan {
        return self
    }
    
    @inlinable public subscript(start: Int , count countValue: Int) -> MutableByteSpan {
        return self[start...][..<countValue]
    }
}

@inlinable public func withTemporaryByteSpan<R>(count: Int, _ body: (inout MutableByteSpan) throws -> R) rethrows -> R {
    return try withUnsafeTemporaryAllocation(byteCount: count, alignment: 1) { buffer in
        var span = MutableByteSpan(buffer)
        return try body(&span)
    }
}
