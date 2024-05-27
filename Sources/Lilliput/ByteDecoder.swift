public protocol ByteDecoder {
    associatedtype Decodable
    static func decode<R: ByteReader>(from reader: inout R) throws -> Decodable
}

extension UInt8 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt8 {
        return decode(from: try reader.read(1))
    }
}

extension UInt16.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt16 {
        return decode(from: try reader.read(2))
    }
}

extension UInt16.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt16 {
        return decode(from: try reader.read(2))
    }
}

extension UInt32.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt32 {
        return decode(from: try reader.read(4))
    }
}

extension UInt32.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt32 {
        return decode(from: try reader.read(4))
    }
}

extension UInt64.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt64 {
        return decode(from: try reader.read(8))
    }
}

extension UInt64.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> UInt64 {
        return decode(from: try reader.read(8))
    }
}

extension Int8 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int8 {
        return decode(from: try reader.read(1))
    }
}

extension Int16.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int16 {
        return decode(from: try reader.read(2))
    }
}

extension Int16.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int16 {
        return decode(from: try reader.read(2))
    }
}

extension Int32.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int32 {
        return decode(from: try reader.read(4))
    }
}

extension Int32.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int32 {
        return decode(from: try reader.read(4))
    }
}

extension Int64.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int64 {
        return decode(from: try reader.read(8))
    }
}

extension Int64.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Int64 {
        return decode(from: try reader.read(8))
    }
}

extension Float16.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float16 {
        return decode(from: try reader.read(2))
    }
}

extension Float16.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float16 {
        return decode(from: try reader.read(2))
    }
}

extension Float32.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float32 {
        return decode(from: try reader.read(4))
    }
}

extension Float32.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float32 {
        return decode(from: try reader.read(4))
    }
}

extension Float64.BigEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float64 {
        return decode(from: try reader.read(8))
    }
}

extension Float64.LittleEndian : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Float64 {
        return decode(from: try reader.read(8))
    }
}
