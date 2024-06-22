public protocol ByteReader {
    var readCount: Int { get }
    var remainingCount: Int { get }
    mutating func read() -> UInt8
    mutating func read(_ count: Int) -> ByteSpan
}

public extension ByteReader {
    @inlinable mutating func read<T: ByteDecoder>(_ type: T.Type) throws -> T.Decodable {
        return try T.decode(from: &self)
    }
    
    @inlinable mutating func read<T: CollectionByteDecoder>(_ type: T.Type, count: Int) throws -> T.Decodable {
        return try T.decode(from: &self, count: count)
    }
    
    @inlinable mutating func peek<T: ByteDecoder>(_ type: T.Type) throws -> T.Decodable {
        var peekSelf = self
        return try peekSelf.read(type)
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
    
    public mutating func read() -> UInt8 {
        let byte = span[0]
        span = span[1...]
        readCount += 1
        return byte
    }
    
    public mutating func read(_ count: Int) -> ByteSpan {
        let bytes = span[0..<count]
        span = span[count...]
        readCount += count
        return bytes
    }
}

public extension ByteReader {
    @inlinable func ensure(_ count: Int) throws {
        guard count <= remainingCount else {
            throw ByteError.notEnoughBytes
        }
    }
}
