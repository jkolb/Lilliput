public extension UInt8 {
    @inlinable static func decode(from bytes: ByteSpan) -> UInt8 {
        return bytes[0]
    }
    
    @inlinable static func encode(_ value: UInt8, to bytes: inout MutableByteSpan) {
        bytes[0] = value
    }
}

public extension UInt16 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> UInt16 {
            return (
                UInt16(bytes[0]) &<< 8 |
                UInt16(bytes[1]) &<< 0
            )
        }
        
        @inlinable static func encode(_ value: UInt16, to bytes: inout MutableByteSpan) {
            bytes[0] = UInt8(truncatingIfNeeded: value &>> 8)
            bytes[1] = UInt8(truncatingIfNeeded: value &>> 0)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> UInt16 {
            return (
                UInt16(bytes[0]) &<< 0 |
                UInt16(bytes[1]) &<< 8
            )
        }
        
        @inlinable static func encode(_ value: UInt16, to bytes: inout MutableByteSpan) {
            bytes[0] = UInt8(truncatingIfNeeded: value &>> 0)
            bytes[1] = UInt8(truncatingIfNeeded: value &>> 8)
        }
    }
}

public extension UInt32 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> UInt32 {
            return (
                UInt32(bytes[0]) &<< 24 |
                UInt32(bytes[1]) &<< 16 |
                UInt32(bytes[2]) &<< 8  |
                UInt32(bytes[3]) &<< 0
            )
        }
        
        @inlinable static func encode(_ value: UInt32, to bytes: inout MutableByteSpan) {
            bytes[0] = UInt8(truncatingIfNeeded: value &>> 24)
            bytes[1] = UInt8(truncatingIfNeeded: value &>> 16)
            bytes[2] = UInt8(truncatingIfNeeded: value &>> 8)
            bytes[3] = UInt8(truncatingIfNeeded: value &>> 0)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> UInt32 {
            return (
                UInt32(bytes[0]) &<< 0  |
                UInt32(bytes[1]) &<< 8  |
                UInt32(bytes[2]) &<< 16 |
                UInt32(bytes[3]) &<< 24
            )
        }
        
        @inlinable static func encode(_ value: UInt32, to bytes: inout MutableByteSpan) {
            bytes[0] = UInt8(truncatingIfNeeded: value &>> 0)
            bytes[1] = UInt8(truncatingIfNeeded: value &>> 8)
            bytes[2] = UInt8(truncatingIfNeeded: value &>> 16)
            bytes[3] = UInt8(truncatingIfNeeded: value &>> 24)
        }
    }
}

public extension UInt64 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> UInt64 {
            return (
                UInt64(bytes[0]) &<< 56 |
                UInt64(bytes[1]) &<< 48 |
                UInt64(bytes[2]) &<< 40 |
                UInt64(bytes[3]) &<< 32 |
                UInt64(bytes[4]) &<< 24 |
                UInt64(bytes[5]) &<< 16 |
                UInt64(bytes[6]) &<< 8  |
                UInt64(bytes[7]) &<< 0
            )
        }
        
        @inlinable static func encode(_ value: UInt64, to bytes: inout MutableByteSpan) {
            bytes[0] = UInt8(truncatingIfNeeded: value &>> 56)
            bytes[1] = UInt8(truncatingIfNeeded: value &>> 48)
            bytes[2] = UInt8(truncatingIfNeeded: value &>> 40)
            bytes[3] = UInt8(truncatingIfNeeded: value &>> 32)
            bytes[4] = UInt8(truncatingIfNeeded: value &>> 24)
            bytes[5] = UInt8(truncatingIfNeeded: value &>> 16)
            bytes[6] = UInt8(truncatingIfNeeded: value &>> 8)
            bytes[7] = UInt8(truncatingIfNeeded: value &>> 0)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> UInt64 {
            return (
                UInt64(bytes[0]) &<< 0  |
                UInt64(bytes[1]) &<< 8  |
                UInt64(bytes[2]) &<< 16 |
                UInt64(bytes[3]) &<< 24 |
                UInt64(bytes[4]) &<< 32 |
                UInt64(bytes[5]) &<< 40 |
                UInt64(bytes[6]) &<< 48 |
                UInt64(bytes[7]) &<< 56
            )
        }
        
        @inlinable static func encode(_ value: UInt64, to bytes: inout MutableByteSpan) {
            bytes[0] = UInt8(truncatingIfNeeded: value &>> 0)
            bytes[1] = UInt8(truncatingIfNeeded: value &>> 8)
            bytes[2] = UInt8(truncatingIfNeeded: value &>> 16)
            bytes[3] = UInt8(truncatingIfNeeded: value &>> 24)
            bytes[4] = UInt8(truncatingIfNeeded: value &>> 32)
            bytes[5] = UInt8(truncatingIfNeeded: value &>> 40)
            bytes[6] = UInt8(truncatingIfNeeded: value &>> 48)
            bytes[7] = UInt8(truncatingIfNeeded: value &>> 56)
        }
    }
}

public extension Int8 {
    @inlinable static func decode(from bytes: ByteSpan) -> Int8 {
        return Int8(bitPattern: bytes[0])
    }
    
    @inlinable static func encode(_ value: Int8, to bytes: inout MutableByteSpan) {
        bytes[0] = UInt8(bitPattern: value)
    }
}

public extension Int16 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Int16 {
            return Int16(bitPattern: UInt16.BigEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Int16, to bytes: inout MutableByteSpan) {
            UInt16.BigEndian.encode(UInt16(bitPattern: value), to: &bytes)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Int16 {
            return Int16(bitPattern: UInt16.LittleEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Int16, to bytes: inout MutableByteSpan) {
            UInt16.LittleEndian.encode(UInt16(bitPattern: value), to: &bytes)
        }
    }
}

public extension Int32 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Int32 {
            return Int32(bitPattern: UInt32.BigEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Int32, to bytes: inout MutableByteSpan) {
            UInt32.BigEndian.encode(UInt32(bitPattern: value), to: &bytes)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Int32 {
            return Int32(bitPattern: UInt32.LittleEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Int32, to bytes: inout MutableByteSpan) {
            UInt32.LittleEndian.encode(UInt32(bitPattern: value), to: &bytes)
        }
    }
}

public extension Int64 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Int64 {
            return Int64(bitPattern: UInt64.BigEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Int64, to bytes: inout MutableByteSpan) {
            UInt64.BigEndian.encode(UInt64(bitPattern: value), to: &bytes)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Int64 {
            return Int64(bitPattern: UInt64.LittleEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Int64, to bytes: inout MutableByteSpan) {
            UInt64.LittleEndian.encode(UInt64(bitPattern: value), to: &bytes)
        }
    }
}

public extension Float16 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Float16 {
            return Float16(bitPattern: UInt16.BigEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Float16, to bytes: inout MutableByteSpan) {
            UInt16.BigEndian.encode(value.bitPattern, to: &bytes)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Float16 {
            return Float16(bitPattern: UInt16.LittleEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Float16, to bytes: inout MutableByteSpan) {
            UInt16.LittleEndian.encode(value.bitPattern, to: &bytes)
        }
    }
}

public extension Float32 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Float32 {
            return Float32(bitPattern: UInt32.BigEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Float32, to bytes: inout MutableByteSpan) {
            UInt32.BigEndian.encode(value.bitPattern, to: &bytes)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Float32 {
            return Float32(bitPattern: UInt32.LittleEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Float32, to bytes: inout MutableByteSpan) {
            UInt32.LittleEndian.encode(value.bitPattern, to: &bytes)
        }
    }
}

public extension Float64 {
    @frozen enum BigEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Float64 {
            return Float64(bitPattern: UInt64.BigEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Float64, to bytes: inout MutableByteSpan) {
            UInt64.BigEndian.encode(value.bitPattern, to: &bytes)
        }
    }
    
    @frozen enum LittleEndian {
        @inlinable static func decode(from bytes: ByteSpan) -> Float64 {
            return Float64(bitPattern: UInt64.LittleEndian.decode(from: bytes))
        }
        
        @inlinable static func encode(_ value: Float64, to bytes: inout MutableByteSpan) {
            UInt64.LittleEndian.encode(value.bitPattern, to: &bytes)
        }
    }
}
