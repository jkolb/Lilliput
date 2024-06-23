# Lilliput

[Lilliput](http://en.wikipedia.org/wiki/Lilliput_and_Blefuscu) is a native Swift framework for working with binary data.

## Design decisions

* Does not support streaming data, it only works with data that can fit in memory.
* Allows types to have multiple encodings/decodings, this means that a UInt32 could be easily represented as little endian, big endian, or some custom compressed encoding.
* Does not support the idea of "native" endianness, when working with data where endianess matters you must always be specific. 
* Makes use of the [swift-system](https://github.com/apple/swift-system) package for reading/writing files.

## Basic usage

```swift
import Lilliput

// Allocate enough storage for a 32-bit unsigned integer
let buffer = ByteBuffer(count: 4)
try buffer.slice(...) { bytes in
    // Write a UInt32 to that storage in little endian encoding
    var writer = ByteSpanWriter(bytes)
    try writer.write(UInt32(100), as: UInt32.LittleEndian.self)

    // Read a UInt32 from that stroage in little endian encoding 
    var reader = ByteSpanReader(bytes)
    let value = try reader.read(UInt32.LittleEndian.self)
}
```

## Custom byte decodable/encodable types

```swift
struct MyType {
    var value0: Int
    var value1: Int8
    var value3: Double
}

extension MyType: ByteDecoder {
    static func decode<R: Reader>(from reader: inout R) throws -> MyType {
        return MyType(
            value0: Int(try reader.read(UInt32.LittleEndian.self)),
            value1: try reader.read(Int8.self),
            value2: try reader.read(Float64.LittleEndian.self)
        )
    }
}

extension MyType: ByteEncoder {
    static func encode<W: Writer>(_ value: MyType, to writer: inout W) throws {
        try writer.write(UInt32(value.value0), as: UInt32.LittleEndian.self)
        try writer.write(value.value1)
        try writer.write(value.value2, as: Float64.LittleEndian.self)
    }
}
```

## Mutiple ways to decode/encode the same type

```swift
extension MyType {
    @frozen enum Custom {}
}

extension MyType.Custom: ByteDecoder {
    static func decode<R: Reader>(from reader: inout R) throws -> MyType {
        // Values are loaded/stored in reverse order from the type definition and using big endian
        let value2 = try reader.read(Float64.BigEndian.self)
        let value1 = try reader.read(Int8.self)
        try reader.alignTo(4) // Make sure next read occurs after three padding bytes
        let value0 = Int(try reader.read(UInt32.BigEndian.self))
         
        return MyType(
            value0: value0,
            value1: value1,
            value2: value2
        )
    }
}

extension MyType.Custom: ByteEncoder {
    static func encode<W: Writer>(_ value: MyType, to writer: inout W) throws {
        // Values are loaded/stored in reverse order from the type definition and using big endian
        try writer.write(value.value2, as: Float64.BigEndian.self)
        try writer.write(value.value1)
        try writer.write((0, 0, 0), as: UInt8.Tuple3.self) // Add three padding bytes
        try writer.write(UInt32(value.value0), as: UInt32.BigEndian.self)
    }
}
```

## Reading types from disk

```swift
import Lilliput
import SystemPackage

let file = try FileDescriptor.open(path, .readOnly)
let buffer = ByteBuffer(count: 13)
let myType = try buffer.slice(...) { bytes in
    try file.readAll(into: bytes)
    var reader = ByteSpanReader(bytes)
    return try reader.read(MyType.self)
}
```

If the data was stored on disk using the Custom encoding instead
```swift
return try reader.read(MyType.Custom.self)
```

## Writing types to disk
```swift
import Lilliput
import SystemPackage

let myType = MyType(value0: 100, value1: 8, value2: 300.56)
let buffer = ByteBuffer(count: 13)
try buffer.slice(...) { bytes in
    var writer = SpanByteWriter(buffer)
    try writer.write(myType)
}
let file = try FileDescriptor.open(path, .writeOnly)
file.writeAll(buffer)
```

If we wanted to store the data using the Custom encoding instead
```swift
try writer.write(myType, as: MyType.Custom.self)
```

## Reading arrays of decodable types

```swift
let count = Int(try reader.read(UInt32.LittleEndian.self))
let arrayOfMyType = try reader.read(Element<MyType>.self, count: count)
```

## Writing arrays of encodable types

```swift
try writer.write(UInt32(arrayOfMyType.count), as: UInt32.LittleEndian.self)
try writer.write(arrayOfMyType, as: Element<MyType>.self)
```

## Custom array decoding/encoding

Note: This is not built in to the library due to decisions on how to encode the count value could differ wildly across use cases.
```swift
@frozen struct MyArray<E> {}

extension MyArray: ByteDecoder where E: ByteDecoder {
    static func decode<R: Reader>(from reader: inout R) throws -> [E.Decodable] {
        let count = Int(try reader.read(UInt32.LittleEndian.self))
        return try reader.read(Element<E>.self, count: count)
    }
}

extension MyArray: ByteEncoder where E: ByteEncoder {
    static func encode<W: ByteWriter>(_ value: [E.Encodable], to writer: inout W) throws {
        try writer.write(UInt32(value.count), as: UInt32.LittleEndian.self)
        
        for element in value {
            try writer.write(element, as: E.self)
        }
    }
}
```

Usage (note that the count value is handled without extra work now)
```swift
let arrayOfMyType = try reader.read(MyArray<MyType>.self)

try writer.write(arrayOfMyType, as: MyArray<MyType>.self)
```

## Foundation Integration
```swift
let data = Data(...) // Get data somehow
var reader = DataReader(data: data, maxReadCount: 8)
let myType = try reader.read(MyType.self)
```

Choose a value for `maxReadCount` that represents the maximum amount of bytes read in one call to `read`. In the example above the longest read is a `Double` which is 8 bytes. In the worst case you can omit the `maxReadCount` parameter and then the entire length of the Data would be used as the default.

## Small Gotcha In Version 12.0.0+ API

All of the `read` methods on `ByteReader` and `write` methods on `ByteWriter` that do not involve a `ByteDecoder`/`ByteEncoder` no longer check to see if there are enough bytes to complete the operation. This is now handled separately be calling `ensure`. For example `try reader.ensure(5)` will throw if there are not enough bytes left to read.

A side effect of this change is that when you write a single `UInt8` it no longer triggers the `UInt8` implementation of `ByteEncoder`.

Previously you would do this and it would throw if there was not enough space to write:
```swift
try writer.write(UInt8(7))
```

Now the new `write` method on `ByteWriter` that takes a single `UInt8` superceeds this.
To get the new behavior do this:

```swift
try ensure(1)
writer.write(UInt8(7))
```

or do this which triggers the `ByteEncoder` implementation manually:

```swift
try writer.write(UInt8(7), as: UInt8.self)  
```

## Adding `Lilliput` as a Dependency

To use the `Lilliput` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/jkolb/Lilliput.git", from: "12.0.0"),
```

Finally, include `"Lilliput"` as a dependency for your target:

```swift
let package = Package(
    // name, platforms, products, etc.
    dependencies: [
        .package(url: "https://github.com/jkolb/Lilliput.git", from: "12.0.0"),
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
