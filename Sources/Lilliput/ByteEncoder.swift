public protocol ByteEncoder {
    associatedtype Encodable
    static func encode<W: ByteWriter>(_ value: Encodable, to writer: inout W) throws
}

extension UInt8: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt8, to writer: inout W) throws {
        try writer.ensure(1)
        writer.write(value)
    }
}

extension UInt16.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt16, to writer: inout W) throws {
        try writer.ensure(2)
        writer.write(UInt8(truncatingIfNeeded: value &>> 8))
        writer.write(UInt8(truncatingIfNeeded: value &>> 0))
    }
}

extension UInt16.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt16, to writer: inout W) throws {
        try writer.ensure(2)
        writer.write(UInt8(truncatingIfNeeded: value &>> 0))
        writer.write(UInt8(truncatingIfNeeded: value &>> 8))
    }
}

extension UInt32.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt32, to writer: inout W) throws {
        try writer.ensure(4)
        writer.write(UInt8(truncatingIfNeeded: value &>> 24))
        writer.write(UInt8(truncatingIfNeeded: value &>> 16))
        writer.write(UInt8(truncatingIfNeeded: value &>> 8))
        writer.write(UInt8(truncatingIfNeeded: value &>> 0))
    }
}

extension UInt32.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt32, to writer: inout W) throws {
        try writer.ensure(4)
        writer.write(UInt8(truncatingIfNeeded: value &>> 0))
        writer.write(UInt8(truncatingIfNeeded: value &>> 8))
        writer.write(UInt8(truncatingIfNeeded: value &>> 16))
        writer.write(UInt8(truncatingIfNeeded: value &>> 24))
    }
}

extension UInt64.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt64, to writer: inout W) throws {
        try writer.ensure(8)
        writer.write(UInt8(truncatingIfNeeded: value &>> 56))
        writer.write(UInt8(truncatingIfNeeded: value &>> 48))
        writer.write(UInt8(truncatingIfNeeded: value &>> 40))
        writer.write(UInt8(truncatingIfNeeded: value &>> 32))
        writer.write(UInt8(truncatingIfNeeded: value &>> 24))
        writer.write(UInt8(truncatingIfNeeded: value &>> 16))
        writer.write(UInt8(truncatingIfNeeded: value &>> 8))
        writer.write(UInt8(truncatingIfNeeded: value &>> 0))
    }
}

extension UInt64.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: UInt64, to writer: inout W) throws {
        try writer.ensure(8)
        writer.write(UInt8(truncatingIfNeeded: value &>> 0))
        writer.write(UInt8(truncatingIfNeeded: value &>> 8))
        writer.write(UInt8(truncatingIfNeeded: value &>> 16))
        writer.write(UInt8(truncatingIfNeeded: value &>> 24))
        writer.write(UInt8(truncatingIfNeeded: value &>> 32))
        writer.write(UInt8(truncatingIfNeeded: value &>> 40))
        writer.write(UInt8(truncatingIfNeeded: value &>> 48))
        writer.write(UInt8(truncatingIfNeeded: value &>> 56))
    }
}

extension Int8: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int8, to writer: inout W) throws {
        try UInt8.encode(UInt8(bitPattern: value), to: &writer)
    }
}

extension Int16.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int16, to writer: inout W) throws {
        try UInt16.BigEndian.encode(UInt16(bitPattern: value), to: &writer)
    }
}

extension Int16.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int16, to writer: inout W) throws {
        try UInt16.LittleEndian.encode(UInt16(bitPattern: value), to: &writer)
    }
}

extension Int32.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int32, to writer: inout W) throws {
        try UInt32.BigEndian.encode(UInt32(bitPattern: value), to: &writer)
    }
}

extension Int32.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int32, to writer: inout W) throws {
        try UInt32.LittleEndian.encode(UInt32(bitPattern: value), to: &writer)
    }
}

extension Int64.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int64, to writer: inout W) throws {
        try UInt64.BigEndian.encode(UInt64(bitPattern: value), to: &writer)
    }
}

extension Int64.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Int64, to writer: inout W) throws {
        try UInt64.LittleEndian.encode(UInt64(bitPattern: value), to: &writer)
    }
}

extension Float16.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Float16, to writer: inout W) throws {
        try UInt16.BigEndian.encode(value.bitPattern, to: &writer)
    }
}

extension Float16.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Float16, to writer: inout W) throws {
        try UInt16.LittleEndian.encode(value.bitPattern, to: &writer)
    }
}

extension Float32.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Float32, to writer: inout W) throws {
        try UInt32.BigEndian.encode(value.bitPattern, to: &writer)
    }
}

extension Float32.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Float32, to writer: inout W) throws {
        try UInt32.LittleEndian.encode(value.bitPattern, to: &writer)
    }
}

extension Float64.BigEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Float64, to writer: inout W) throws {
        try UInt64.BigEndian.encode(value.bitPattern, to: &writer)
    }
}

extension Float64.LittleEndian: ByteEncoder {
    @inlinable public static func encode<W: ByteWriter>(_ value: Float64, to writer: inout W) throws {
        try UInt64.LittleEndian.encode(value.bitPattern, to: &writer)
    }
}
