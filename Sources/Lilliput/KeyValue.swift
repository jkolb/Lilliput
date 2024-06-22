@frozen public enum KeyValue<K, V> {}

extension KeyValue: CollectionByteDecoder where K: ByteDecoder, V: ByteDecoder, K.Decodable: Hashable {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> [K.Decodable : V.Decodable] {
        var keyValues = [K.Decodable : V.Decodable](minimumCapacity: count)
        
        for _ in 0..<count {
            let key = try K.decode(from: &reader)
            let value = try V.decode(from: &reader)
            keyValues[key] = value
        }
        
        return keyValues
    }
}

extension KeyValue: ByteEncoder where K: ByteEncoder, V: ByteEncoder, K.Encodable: Hashable {
    @inlinable public static func encode<W: ByteWriter>(_ keyValues: [K.Encodable : V.Encodable], to writer: inout W) throws {
        for (key, value) in keyValues {
            try K.encode(key, to: &writer)
            try V.encode(value, to: &writer)
        }
    }
}
