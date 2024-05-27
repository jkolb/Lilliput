public protocol CollectionByteDecoder {
    associatedtype Decodable
    static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> Decodable
}

@frozen public enum ByteArray : CollectionByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> [UInt8] {
        return try [UInt8](unsafeUninitializedCapacity: count) { buffer, initializedCount in
            UnsafeMutableRawBufferPointer(buffer).copyMemory(from: try reader.read(count).buffer)
            initializedCount = count
        }
    }
}
