public protocol ByteReader {
    var readCount: Int { get }
    var remainingCount: Int { get }
    mutating func read(_ count: Int) throws -> ByteSpan
}

public extension ByteReader {
    @inlinable mutating func read<T: ByteDecoder>(_ type: T.Type) throws -> T.Decodable {
        return try T.decode(from: &self)
    }
    
    @inlinable mutating func read<T: CollectionByteDecoder>(_ type: T.Type, count: Int) throws -> T.Decodable {
        return try T.decode(from: &self, count: count)
    }
}

@frozen public struct ByteSpanReader: ByteReader {
    private var span: ByteSpan
    public private(set) var readCount: Int
    
    public var remainingCount: Int {
        return span.count
    }
    
    public init(_ buffer: UnsafeMutableRawBufferPointer) {
        self.init(span: ByteSpan(buffer))
    }
    
    public init(_ buffer: UnsafeRawBufferPointer) {
        self.init(span: ByteSpan(buffer))
    }
    
    public init(span: ByteSpan) {
        self.span = span
        self.readCount = 0
    }
    
    public mutating func read(_ count: Int) throws -> ByteSpan {
        guard count <= remainingCount else {
            throw ByteError.notEnoughBytes
        }
        let bytes = span[0..<count]
        span = span[count...]
        readCount += count
        return bytes
    }
}
