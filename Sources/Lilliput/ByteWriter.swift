public protocol ByteWriter {
    var writeCount: Int { get }
    var remainingCount: Int { get }
    mutating func write(_ byte: UInt8)
    mutating func write(_ bytes: ByteSpan)
}

public extension ByteWriter {
    @inlinable mutating func write(_ bytes: MutableByteSpan) {
        write(ByteSpan(bytes.buffer))
    }
}

public extension ByteWriter {
    @inlinable mutating func write<T: ByteEncoder>(_ value: T) throws where T.Encodable == T {
        try T.encode(value, to: &self)
    }
    
    @inlinable mutating func write<T, E: ByteEncoder>(_ value: T, as encoder: E.Type) throws where E.Encodable == T {
        try E.encode(value, to: &self)
    }
}

@frozen public struct ByteSizeWriter: ByteWriter {
    public private(set) var writeCount: Int
    
    public var remainingCount: Int {
        return Int.max - writeCount
    }
    
    public init() {
        self.writeCount = 0
    }
    
    public mutating func write(_ byte: UInt8) {
        writeCount += 1
    }
    
    public mutating func write(_ bytes: ByteSpan) {
        writeCount += bytes.count
    }
}

@frozen public struct ByteSpanWriter: ByteWriter {
    private var span: MutableByteSpan
    public private(set) var writeCount: Int
    
    public var remainingCount: Int {
        return span.count
    }
    
    public init(_ buffer: UnsafeMutableRawBufferPointer) {
        self.init(span: MutableByteSpan(buffer))
    }
    
    public init(span: MutableByteSpan) {
        self.span = span
        self.writeCount = 0
    }
    
    public mutating func write(_ byte: UInt8) {
        span[0] = byte
        span = span[1...]
        writeCount += 1
    }
    
    public mutating func write(_ bytes: ByteSpan) {
        let count = bytes.count
        span[0..<count].buffer.copyMemory(from: bytes.buffer)
        span = span[count...]
        writeCount += count
    }
}

public extension ByteWriter {
    @inlinable func ensure(_ count: Int) throws {
        guard count <= remainingCount else {
            throw ByteError.tooManyBytes
        }
    }
}
