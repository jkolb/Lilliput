public protocol ByteEncoder {
    associatedtype Encodable
    static func encode<W: ByteWriter>(_ value: Encodable, to writer: inout W) throws
}

extension UInt8 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt8, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 1) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension UInt16.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt16, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension UInt16.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt16, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension UInt32.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt32, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension UInt32.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt32, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension UInt64.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt64, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension UInt64.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: UInt64, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int8 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int8, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 1) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int16.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int16, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int16.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int16, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int32.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int32, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int32.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int32, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int64.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int64, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Int64.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Int64, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Float16.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Float16, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Float16.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Float16, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 2) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Float32.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Float32, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Float32.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Float32, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 4) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Float64.BigEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Float64, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}

extension Float64.LittleEndian : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Float64, to writer: inout W) throws where W : ByteWriter {
        try withTemporaryByteSpan(count: 8) { bytes in
            encode(value, to: &bytes)
            try writer.write(bytes)
        }
    }
}
