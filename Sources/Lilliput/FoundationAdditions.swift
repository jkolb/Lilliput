#if canImport(Foundation)
import Foundation

public extension Data {
    @inlinable mutating func append(_ byteSpan: ByteSpan) {
        append(byteSpan.bytes)
    }
    
    @inlinable func withSpan<T>(_ body: (ByteSpan) throws -> T) rethrows -> T {
        return try withUnsafeBytes { buffer in
            let span = ByteSpan(buffer)
            return try body(span)
        }
    }
}

@frozen public struct DataReader: ByteReader {
    private let data: Data
    private let readBuffer: ByteBuffer
    public private(set) var readCount: Int
    
    public var remainingCount: Int {
        return data.count - readCount
    }
    
    public init(data: Data) {
        self.init(data: data, maxReadCount: data.count)
    }
    
    public init(data: Data, maxReadCount: Int) {
        precondition(maxReadCount >= 0)
        self.data = data
        self.readBuffer = ByteBuffer(count: maxReadCount)
        self.readCount = 0
    }
    
    public mutating func read() -> UInt8 {
        let byte = data[readCount]
        readCount += 1
        return byte
    }
    
    public mutating func read(_ count: Int) -> ByteSpan {
        guard count <= readBuffer.count else {
            fatalError("maxReadCount exceeded")
        }
        let span = readBuffer.slice(0..<count) { destination in
            data[readCount..<readCount + count].withUnsafeBytes { source in
                destination.copyMemory(from: source)
            }
            return ByteSpan(destination)
        }
        readCount += count
        return span
    }
}

@frozen public struct DataWriter: ByteWriter {
    public var data: Data
    
    public var writeCount: Int {
        return data.count
    }
    
    public var remainingCount: Int {
        return Int.max - writeCount
    }
    
    @inlinable public init() {
        self.data = Data()
    }
    
    @inlinable public init(capacity: Int) {
        self.data = Data(capacity: capacity)
    }
    
    @inlinable public mutating func write(_ byte: UInt8) {
        data.append(byte)
    }
    
    @inlinable public mutating func write(_ bytes: ByteSpan) {
        data.append(bytes)
    }
}

extension Data: CollectionByteDecoder {
    public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> Data {
        try reader.ensure(count)
        return Data(buffer: reader.read(count).bytes)
    }
}

extension Data: ByteEncoder {
    public static func encode<W: ByteWriter>(_ value: Data, to writer: inout W) throws {
        try writer.ensure(value.count)
        value.withSpan { span in
            writer.write(span)
        }
    }
}
#endif
