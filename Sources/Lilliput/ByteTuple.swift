public extension UInt8 {
    @frozen enum Tuple2 {}
    @frozen enum Tuple3 {}
    @frozen enum Tuple4 {}
    @frozen enum Tuple8 {}
    @frozen enum Tuple16 {}
}

extension UInt8.Tuple2 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8) {
        let bytes = try reader.read(2)
        return (
            bytes[0],
            bytes[1]
        )
    }
}

extension UInt8.Tuple3 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8) {
        let bytes = try reader.read(3)
        return (
            bytes[0],
            bytes[1],
            bytes[2]
        )
    }
}

extension UInt8.Tuple4 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8, UInt8) {
        let bytes = try reader.read(4)
        return (
            bytes[0],
            bytes[1],
            bytes[2],
            bytes[3]
        )
    }
}

extension UInt8.Tuple8 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        let bytes = try reader.read(8)
        return (
            bytes[0],
            bytes[1],
            bytes[2],
            bytes[3],
            bytes[4],
            bytes[5],
            bytes[6],
            bytes[7]
        )
    }
}

extension UInt8.Tuple16 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        let bytes = try reader.read(16)
        return (
            bytes[0],
            bytes[1],
            bytes[2],
            bytes[3],
            bytes[4],
            bytes[5],
            bytes[6],
            bytes[7],
            bytes[8],
            bytes[9],
            bytes[10],
            bytes[11],
            bytes[12],
            bytes[13],
            bytes[14],
            bytes[15]
        )
    }
}

extension ByteBuffer : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> ByteBuffer {
        return try decode(from: &reader, count: reader.remainingCount)
    }
}

extension UInt8.Tuple2 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: (UInt8, UInt8), to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { span in
            span[0] = value.0
            span[1] = value.1
            try writer.write(span)
        }
    }
}

extension UInt8.Tuple3 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: (UInt8, UInt8, UInt8), to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 3) { span in
            span[0] = value.0
            span[1] = value.1
            span[2] = value.2
            try writer.write(span)
        }
    }
}

extension UInt8.Tuple4 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: (UInt8, UInt8, UInt8, UInt8), to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { span in
            span[0] = value.0
            span[1] = value.1
            span[2] = value.2
            span[3] = value.3
            try writer.write(span)
        }
    }
}

extension UInt8.Tuple8 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { span in
            span[0] = value.0
            span[1] = value.1
            span[2] = value.2
            span[3] = value.3
            span[4] = value.4
            span[5] = value.5
            span[6] = value.6
            span[7] = value.7
            try writer.write(span)
        }
    }
}

extension UInt8.Tuple16 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 16) { span in
            span[0] = value.0
            span[1] = value.1
            span[2] = value.2
            span[3] = value.3
            span[4] = value.4
            span[5] = value.5
            span[6] = value.6
            span[7] = value.7
            span[8] = value.8
            span[9] = value.9
            span[10] = value.10
            span[11] = value.11
            span[12] = value.12
            span[13] = value.13
            span[14] = value.14
            span[15] = value.15
            try writer.write(span)
        }
    }
}
