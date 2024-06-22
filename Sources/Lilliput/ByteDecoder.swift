public protocol ByteDecoder {
    associatedtype Decodable
    static func decode<R: ByteReader>(from reader: inout R) throws -> Decodable
}

extension UInt8: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt8 {
        try reader.ensure(1)
        return reader.read()
    }
}

public extension UInt16 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension UInt16.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt16 {
        try reader.ensure(2)
        return (
            UInt16(reader.read()) &<< 8 |
            UInt16(reader.read()) &<< 0
        )
    }
}

extension UInt16.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt16 {
        try reader.ensure(2)
        return (
            UInt16(reader.read()) &<< 0 |
            UInt16(reader.read()) &<< 8
        )
    }
}

public extension UInt32 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension UInt32.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt32 {
        try reader.ensure(4)
        return (
            UInt32(reader.read()) &<< 24 |
            UInt32(reader.read()) &<< 16 |
            UInt32(reader.read()) &<< 8  |
            UInt32(reader.read()) &<< 0
        )
    }
}

extension UInt32.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt32 {
        try reader.ensure(4)
        return (
            UInt32(reader.read()) &<< 0  |
            UInt32(reader.read()) &<< 8  |
            UInt32(reader.read()) &<< 16 |
            UInt32(reader.read()) &<< 24
        )
    }
}

public extension UInt64 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension UInt64.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt64 {
        try reader.ensure(8)
        return (
            UInt64(reader.read()) &<< 56 |
            UInt64(reader.read()) &<< 48 |
            UInt64(reader.read()) &<< 40 |
            UInt64(reader.read()) &<< 32 |
            UInt64(reader.read()) &<< 24 |
            UInt64(reader.read()) &<< 16 |
            UInt64(reader.read()) &<< 8  |
            UInt64(reader.read()) &<< 0
        )
    }
}

extension UInt64.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt64 {
        try reader.ensure(8)
        return (
            UInt64(reader.read()) &<< 0  |
            UInt64(reader.read()) &<< 8  |
            UInt64(reader.read()) &<< 16 |
            UInt64(reader.read()) &<< 24 |
            UInt64(reader.read()) &<< 32 |
            UInt64(reader.read()) &<< 40 |
            UInt64(reader.read()) &<< 48 |
            UInt64(reader.read()) &<< 56
        )
    }
}

extension Int8: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int8 {
        return Int8(bitPattern: try UInt8.decode(from: &reader))
    }
}

public extension Int16 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension Int16.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int16 {
        return Int16(bitPattern: try UInt16.BigEndian.decode(from: &reader))
    }
}

extension Int16.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int16 {
        return Int16(bitPattern: try UInt16.LittleEndian.decode(from: &reader))
    }
}

public extension Int32 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension Int32.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int32 {
        return Int32(bitPattern: try UInt32.BigEndian.decode(from: &reader))
    }
}

extension Int32.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int32 {
        return Int32(bitPattern: try UInt32.LittleEndian.decode(from: &reader))
    }
}

public extension Int64 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension Int64.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int64 {
        return Int64(bitPattern: try UInt64.BigEndian.decode(from: &reader))
    }
}

extension Int64.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int64 {
        return Int64(bitPattern: try UInt64.LittleEndian.decode(from: &reader))
    }
}

public extension Float16 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension Float16.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float16 {
        return Float16(bitPattern: try UInt16.BigEndian.decode(from: &reader))
    }
}

extension Float16.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float16 {
        return Float16(bitPattern: try UInt16.LittleEndian.decode(from: &reader))
    }
}

public extension Float32 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension Float32.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float32 {
        return Float32(bitPattern: try UInt32.BigEndian.decode(from: &reader))
    }
}

extension Float32.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float32 {
        return Float32(bitPattern: try UInt32.LittleEndian.decode(from: &reader))
    }
}

public extension Float64 {
    @frozen enum BigEndian {}
    @frozen enum LittleEndian {}
}

extension Float64.BigEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float64 {
        return Float64(bitPattern: try UInt64.BigEndian.decode(from: &reader))
    }
}

extension Float64.LittleEndian: ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float64 {
        return Float64(bitPattern: try UInt64.LittleEndian.decode(from: &reader))
    }
}
