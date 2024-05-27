@frozen public struct Magic4 : RawRepresentable, Hashable, CustomStringConvertible, ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
    public let rawValue: (UInt8, UInt8, UInt8, UInt8)
    
    @inlinable public init(_ byte0: UInt8, _ byte1: UInt8, _ byte2: UInt8, _ byte3: UInt8) {
        self.init(rawValue: (byte0, byte1, byte2, byte3))
    }
    
    @inlinable public init(rawValue: (UInt8, UInt8, UInt8, UInt8)) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(ascii: (Character, Character, Character, Character)) {
        precondition(ascii.0.isASCII)
        precondition(ascii.1.isASCII)
        precondition(ascii.2.isASCII)
        precondition(ascii.3.isASCII)
        
        let ascii0 = ascii.0.asciiValue!
        let ascii1 = ascii.1.asciiValue!
        let ascii2 = ascii.2.asciiValue!
        let ascii3 = ascii.3.asciiValue!
        
        self.init(rawValue: (ascii0, ascii1, ascii2, ascii3))
    }
    
    @inlinable public init(arrayLiteral elements: Character...) {
        precondition(elements.count == 4)
        self.init(ascii: (elements[0], elements[1], elements[2], elements[3]))
    }
    
    @inlinable public init(stringLiteral value: String) {
        precondition(value.count == 4)
        let characters = [Character](unsafeUninitializedCapacity: 4) { buffer, initializedCount in
            for (index, character) in value.enumerated() {
                buffer[index] = character
            }
            initializedCount = 4
        }
        self.init(ascii: (characters[0], characters[1], characters[2], characters[3]))
    }
    
    @inlinable public var stringValue: String {
        return String(
            String.UnicodeScalarView([
                UnicodeScalar(rawValue.0),
                UnicodeScalar(rawValue.1),
                UnicodeScalar(rawValue.2),
                UnicodeScalar(rawValue.3),
            ])
        )
    }
    
    @inlinable public var description: String {
        return stringValue.debugDescription
    }
    
    @inlinable public var debugDescription: String {
        return [
            rawValue.0.hex,
            rawValue.1.hex,
            rawValue.2.hex,
            rawValue.3.hex,
        ].joined(separator: ", ")
    }
    
    public static func == (lhs: Magic4, rhs: Magic4) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.0)
        hasher.combine(rawValue.1)
        hasher.combine(rawValue.2)
        hasher.combine(rawValue.3)
    }
}

extension Magic4 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Magic4 {
        return Magic4(rawValue: try reader.read(UInt8.Tuple4.self))
    }
}

extension Magic4 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Magic4, to writer: inout W) throws where W : ByteWriter {
        try writer.write(value.rawValue, as: UInt8.Tuple4.self)
    }
}
