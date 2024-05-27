# Lilliput

[Lilliput](http://en.wikipedia.org/wiki/Lilliput_and_Blefuscu) is a native Swift framework for working with binary data.

## Design Decisions

* Does not support streaming data, it only works with data that can fit in memory.
* Allows types to have multiple encodings/decodings, this means that a UInt32 could be easily represented as little endian, big endian, or some custom compressed encoding.
* Does not support the idea of "native" endianness, when working with data where endianess matters you must always be specific. 

## Basic Usage

```swift
import Lilliput

// Allocate enough storage for a 32-bit unsigned integer
let buffer = ByteBuffer(count: 4)

// Write a UInt32 to that storage in little endian encoding
var writer = ByteSpanWriter(buffer)
try writer.write(UInt32(100), as: UInt32.LittleEndian.self)

// Read a UInt32 from that stroage in little endian encoding 
var reader = ByteSpanReader(buffer)
let value = try reader.read(UInt32.LittleEndian.self)
```

## Custom Byte Decodable/Encodable Types

```swift
struct MyType {
    var value0: Int
    var value1: Int8
    var value3: Double
}

extension MyType : ByteDecoder {
    static func decode<R: Reader>(from reader: R) throws -> MyType {
        return MyType(
            value0: Int(try reader.read(UInt32.LittleEndian.self)),
            value1: try reader.read(Int8.self),
            value2: try reader.read(Float64.LittleEndian.self)
        )
    }
}

extension MyType : ByteEncoder {
    static func encode<W: Writer>(_ value: MyType, to writer: inout W) throws {
        try writer.write(UInt32(value.value0), as: UInt32.LittleEndian.self)
        try writer.write(value.value1)
        try writer.write(value.value2, as: Float64.LittleEndian.self)
    }
}
```

## Advanced Byte Decodable/Encodable Types

```swift
public extension MyType {
    @frozen enum Custom {}
}

extension MyType.Custom : ByteDecoder {
    static func decode<R: Reader>(from reader: R) throws -> MyType {
        // Values are loaded/stored in reverse order from the type definition and using big endian
        let value2 = try reader.read(Float64.BigEndian.self)
        let value1 = try reader.read(Int8.self)
        let value0 = Int(try reader.read(UInt32.BigEndian.self))
         
        return MyType(
            value0: value0,
            value1: value1,
            value2: value2
        )
    }
}

extension MyType.Custom : ByteEncoder {
    static func encode<W: Writer>(_ value: MyType, to writer: inout W) throws {
        // Values are loaded/stored in reverse order from the type definition and using big endian
        try writer.write(value.value2, as: Float64.BigEndian.self)
        try writer.write(value.value1)
        try writer.write(UInt32(value.value0), as: UInt32.BigEndian.self)
    }
}
```

## Reading Custom Types From Disk

```swift
import Lilliput
import SystemPackage

let file = try FileDescriptor.open(path, .readOnly)
let buffer = ByteBuffer(count: 13)
try file.readAll(into: buffer)
var reader = ByteSpanReader(buffer)
let myType = try reader.read(MyType.self)

// If the data was stored on disk using the Custom encoding instead
let myTypeCustom = try reader.read(MyType.Custom.self)
```

## Writing Custom Types To Disk
```swift
import Lilliput
import SystemPackage

let myType = MyType(value0: 100, value1: 8, value2: 300.56)
let buffer = ByteBuffer(count: 13)
var writer = SpanByteWriter(buffer)
try writer.write(myType)

// If we wanted to store the data using the Custom encoding instead
try writer.write(myType, as: MyType.Custom.self)

let file = try FileDescriptor.open(path, .writeOnly)
file.writeAll(buffer)
```

## Adding `Lilliput` as a Dependency

To use the `Lilliput` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/jkolb/Lilliput.git", from: "10.0.0"),
```

Finally, include `"Lilliput"` as a dependency for your target:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/jkolb/c.git", from: "10.0.0"),
        // other dependencies
    ],
    targets: [
        .target(name: "MyTarget", dependencies: [
            .product(name: "Lilliput", package: "Lilliput"),
        ]),
        // other targets
    ]
)
```

## License

Lilliput is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
