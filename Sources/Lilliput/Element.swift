@frozen public enum Element<E> {}

extension Element: CollectionByteDecoder where E: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> [E.Decodable] {
        var elements = [E.Decodable]()
        elements.reserveCapacity(count)
        
        for _ in 0..<count {
            let element = try E.decode(from: &reader)
            elements.append(element)
        }
        
        return elements
    }
}

extension Element: ByteEncoder where E: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ elements: [E.Encodable], to writer: inout W) throws {
        for element in elements {
            try E.encode(element, to: &writer)
        }
    }
}
