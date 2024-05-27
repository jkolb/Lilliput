@frozen public struct Magic2 : RawRepresentable, Hashable, CustomStringConvertible, ExpressibleByArrayLiteral, ExpressibleByStringLiteral {
    public let rawValue: (UInt8, UInt8)
    
    @inlinable public init(_ byte0: UInt8, _ byte1: UInt8) {
        self.init(rawValue: (byte0, byte1))
    }
    
    @inlinable public init(rawValue: (UInt8, UInt8)) {
        self.rawValue = rawValue
    }
    
    @inlinable public init(ascii: (Character, Character)) {
        precondition(ascii.0.isASCII)
        precondition(ascii.1.isASCII)
        
        let ascii0 = ascii.0.asciiValue!
        let ascii1 = ascii.1.asciiValue!
        
        self.init(rawValue: (ascii0, ascii1))
    }
    
    @inlinable public init(arrayLiteral elements: Character...) {
        precondition(elements.count == 2)
        self.init(ascii: (elements[0], elements[1]))
    }
    
    @inlinable public init(stringLiteral value: String) {
        precondition(value.count == 2)
        let characters = [Character](unsafeUninitializedCapacity: 2) { buffer, initializedCount in
            for (index, character) in value.enumerated() {
                buffer[index] = character
            }
            initializedCount = 2
        }
        self.init(ascii: (characters[0], characters[1]))
    }
    
    @inlinable public var stringValue: String {
        return String(
            String.UnicodeScalarView([
                UnicodeScalar(rawValue.0),
                UnicodeScalar(rawValue.1),
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
        ].joined(separator: ", ")
    }
    
    public static func == (lhs: Magic2, rhs: Magic2) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue.0)
        hasher.combine(rawValue.1)
    }
}

extension Magic2 : ByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R) throws -> Magic2 {
        return Magic2(rawValue: try reader.read(UInt8.Tuple2.self))
    }
}

extension Magic2 : ByteEncoder {
    @inlinable public static func encode<W>(_ value: Magic2, to writer: inout W) throws where W : ByteWriter {
        try writer.write(value.rawValue, as: UInt8.Tuple2.self)
    }
}
