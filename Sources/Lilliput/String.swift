@frozen public enum ASCII : CollectionByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> String {
        return String(decoding: try reader.read(count).buffer, as: Unicode.ASCII.self)
    }
}

@frozen public enum UTF8 : CollectionByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> String {
        return String(decoding: try reader.read(count).buffer, as: Unicode.UTF8.self)
    }
}
