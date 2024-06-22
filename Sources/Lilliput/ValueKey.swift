@frozen public enum ValueKey<V, K> {}

extension ValueKey: CollectionByteDecoder where V: ByteDecoder, K: ByteDecoder, K.Decodable: Hashable {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> [K.Decodable : V.Decodable] {
        var keyValues = [K.Decodable : V.Decodable](minimumCapacity: count)
        
        for _ in 0..<count {
            let value = try V.decode(from: &reader)
            let key = try K.decode(from: &reader)
            keyValues[key] = value
        }
        
        return keyValues
    }
}

extension ValueKey: ByteEncoder where V: ByteEncoder, K: ByteEncoder, K.Encodable: Hashable {
    @inlinable public static func encode<W: ByteWriter>(_ keyValues: [K.Encodable : V.Encodable], to writer: inout W) throws {
        for (key, value) in keyValues {
            try V.encode(value, to: &writer)
            try K.encode(key, to: &writer)
        }
    }
}
