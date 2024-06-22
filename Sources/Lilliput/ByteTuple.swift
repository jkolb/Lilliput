public extension UInt8 {
    @frozen enum Tuple2 {}
    @frozen enum Tuple3 {}
    @frozen enum Tuple4 {}
    @frozen enum Tuple8 {}
    @frozen enum Tuple16 {}
}

extension UInt8.Tuple2: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8) {
        try reader.ensure(2)
        return (
            reader.read(),
            reader.read()
        )
    }
}

extension UInt8.Tuple3: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8) {
        try reader.ensure(3)
        return (
            reader.read(),
            reader.read(),
            reader.read()
        )
    }
}

extension UInt8.Tuple4: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8, UInt8) {
        try reader.ensure(4)
        return (
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read()
        )
    }
}

extension UInt8.Tuple8: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        try reader.ensure(8)
        return (
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read()
        )
    }
}

extension UInt8.Tuple16: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        try reader.ensure(16)
        return (
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read(),
            reader.read()
        )
    }
}

extension UInt8.Tuple2: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: (UInt8, UInt8), to writer: inout W) throws {
        try writer.ensure(2)
        writer.write(value.0)
        writer.write(value.1)
    }
}

extension UInt8.Tuple3: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: (UInt8, UInt8, UInt8), to writer: inout W) throws {
        try writer.ensure(3)
        writer.write(value.0)
        writer.write(value.1)
        writer.write(value.2)
    }
}

extension UInt8.Tuple4: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: (UInt8, UInt8, UInt8, UInt8), to writer: inout W) throws {
        try writer.ensure(4)
        writer.write(value.0)
        writer.write(value.1)
        writer.write(value.2)
        writer.write(value.3)
    }
}

extension UInt8.Tuple8: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), to writer: inout W) throws {
        try writer.ensure(8)
        writer.write(value.0)
        writer.write(value.1)
        writer.write(value.2)
        writer.write(value.3)
        writer.write(value.4)
        writer.write(value.5)
        writer.write(value.6)
        writer.write(value.7)
    }
}

extension UInt8.Tuple16: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), to writer: inout W) throws {
        try writer.ensure(16)
        writer.write(value.0)
        writer.write(value.1)
        writer.write(value.2)
        writer.write(value.3)
        writer.write(value.4)
        writer.write(value.5)
        writer.write(value.6)
        writer.write(value.7)
        writer.write(value.8)
        writer.write(value.9)
        writer.write(value.10)
        writer.write(value.11)
        writer.write(value.12)
        writer.write(value.13)
        writer.write(value.14)
        writer.write(value.15)
    }
}
