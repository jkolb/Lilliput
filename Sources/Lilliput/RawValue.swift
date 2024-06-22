@frozen public enum RawValue<T, D> {}

extension RawValue: ByteDecoder where T: RawRepresentable, D: ByteDecoder, D.Decodable == T.RawValue {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> T {
        let rawValue = try reader.read(D.self)
        guard let value = T(rawValue: rawValue) else {
            throw ByteError.outOfRange
        }
        return value
    }
}

extension RawValue: ByteEncoder where T: RawRepresentable, D: ByteEncoder, D.Encodable == T.RawValue {
    @inlinable public static func encode<W: ByteWriter>(_ value: T, to writer: inout W) throws {
        try writer.write(value.rawValue, as: D.self)
    }
}

public extension ByteDecoder where Decodable: RawRepresentable {
    @inlinable static func decode<R: ByteReader, T: ByteDecoder>(from reader: inout R, as rawValueDecoder: T.Type) throws -> Decodable where T.Decodable == Decodable.RawValue {
        let rawValue = try reader.read(T.self)
        guard let value = Decodable(rawValue: rawValue) else {
            throw ByteError.outOfRange
        }
        return value
    }
}

public extension ByteEncoder where Encodable: RawRepresentable {
    @inlinable static func encode<W: ByteWriter, T: ByteEncoder>(_ value: Encodable, to writer: inout W, as rawValueEncoder: T.Type) throws where T.Encodable == Encodable.RawValue {
        try writer.write(value.rawValue, as: T.self)
    }
}
