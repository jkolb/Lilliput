// https://en.m.wikipedia.org/wiki/Windows-1252
// https://forums.swift.org/t/string-decoding-as-with-as-not-utf8-self-and-not-ascii-self/40464/7
@frozen public enum CP1252 {
}

extension CP1252: Unicode.Encoding {
    @inlinable public static var encodedReplacementCharacter: EncodedScalar {
        return EncodedScalar(0x1a) // U+001A SUBSTITUTE; best we can do for ASCII like encodings
    }
    
    @inlinable public static func decode(_ content: EncodedScalar) -> Unicode.Scalar {
        let content = content.first!
        switch content {
        case 0x80: return "\u{20ac}"
        case 0x82: return "\u{201a}"
        case 0x83: return "\u{019a}"
        case 0x84: return "\u{201e}"
        case 0x85: return "\u{2026}"
        case 0x86: return "\u{2020}"
        case 0x87: return "\u{2021}"
        case 0x88: return "\u{02c6}"
        case 0x89: return "\u{2030}"
        case 0x8a: return "\u{0160}"
        case 0x8b: return "\u{2039}"
        case 0x8c: return "\u{0152}"
        case 0x8e: return "\u{017d}"
        case 0x91: return "\u{2018}"
        case 0x92: return "\u{2019}"
        case 0x93: return "\u{201c}"
        case 0x94: return "\u{201d}"
        case 0x95: return "\u{2022}"
        case 0x96: return "\u{2013}"
        case 0x97: return "\u{2014}"
        case 0x98: return "\u{02dc}"
        case 0x99: return "\u{2122}"
        case 0x9a: return "\u{0161}"
        case 0x9b: return "\u{203a}"
        case 0x9c: return "\u{0153}"
        case 0x9e: return "\u{017e}"
        case 0x9f: return "\u{0178}"
        default:
            // The rest matches Unicode
            return Unicode.Scalar(content)
        }
    }

    @inlinable public static func encode(_ content: Unicode.Scalar) -> EncodedScalar? {
        let result: UInt8
        switch content.value {
        case 0x20ac: result = 0x80
        case 0x201a: result = 0x82
        case 0x019a: result = 0x83
        case 0x201e: result = 0x84
        case 0x2026: result = 0x85
        case 0x2020: result = 0x86
        case 0x2021: result = 0x87
        case 0x02c6: result = 0x88
        case 0x2030: result = 0x89
        case 0x0160: result = 0x8a
        case 0x2039: result = 0x8b
        case 0x0152: result = 0x8c
        case 0x017d: result = 0x8e
        case 0x2018: result = 0x91
        case 0x2019: result = 0x92
        case 0x201c: result = 0x93
        case 0x201d: result = 0x94
        case 0x2022: result = 0x95
        case 0x2013: result = 0x96
        case 0x2014: result = 0x97
        case 0x02dc: result = 0x98
        case 0x2122: result = 0x99
        case 0x0161: result = 0x9a
        case 0x203a: result = 0x9b
        case 0x0153: result = 0x9c
        case 0x017e: result = 0x9e
        case 0x0178: result = 0x9f
        case 0..<0x100: result = .init(content.value)
        default: return nil
        }
        
        return .init(result)
    }

    public typealias CodeUnit = UInt8
    public typealias EncodedScalar = CollectionOfOne<CodeUnit>

    @frozen public struct Parser {
        @inlinable public init() {
        }
    }
    
    public typealias ForwardParser = Parser
    public typealias ReverseParser = Parser
}

extension CP1252.Parser : Unicode.Parser {
    public typealias Encoding = CP1252
    
    @inlinable public mutating func parseScalar<I: IteratorProtocol>(from input: inout I) -> Unicode.ParseResult<Encoding.EncodedScalar> where I.Element == Encoding.CodeUnit {
        guard let raw = input.next() else {
            return .emptyInput
        }
        
        switch raw {
        case 0x81, 0x8d, 0x8f, 0x90, 0x9d:
            return .error(length: 1)
            
        default:
            return .valid(CP1252.EncodedScalar(raw))
        }
    }
}

extension CP1252 : CollectionByteDecoder {
    @inlinable public static func decode<R: ByteReader>(from reader: inout R, count: Int) throws -> String {
        return String(decoding: try reader.read(count).buffer, as: CP1252.self)
    }
}
