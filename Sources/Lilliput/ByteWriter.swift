public protocol ByteWriter {
    var writeCount: Int { get }
    var remainingCount: Int { get }
    mutating func write(_ bytes: ByteSpan) throws
}

public extension ByteWriter {
    @inlinable mutating func write(_ bytes: MutableByteSpan) throws {
        try write(ByteSpan(bytes.buffer))
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

@frozen public struct ByteSizeWriter : ByteWriter {
    public private(set) var writeCount: Int
    
    public var remainingCount: Int {
        return Int.max - writeCount
    }
    
    public init() {
        self.writeCount = 0
    }
    
    public mutating func write(_ bytes: ByteSpan) throws {
        writeCount += bytes.count
    }
}

@frozen public struct ByteSpanWriter : ByteWriter {
    private var span: MutableByteSpan
    public private(set) var writeCount: Int
    
    public var remainingCount: Int {
        return span.count
    }
    
    public init(_ byteBuffer: ByteBuffer) {
        self.init(byteBuffer[...])
    }
    
    public init(_ buffer: UnsafeMutableRawBufferPointer) {
        self.init(span: MutableByteSpan(buffer))
    }
    
    public init(span: MutableByteSpan) {
        self.span = span
        self.writeCount = 0
    }
    
    public mutating func write(_ bytes: ByteSpan) throws {
        let count = bytes.count
        guard count <= remainingCount else {
            throw ByteError.tooManyBytes
        }
        span[0..<count].buffer.copyMemory(from: bytes.buffer)
        span = span[count...]
        writeCount += count
    }
}
