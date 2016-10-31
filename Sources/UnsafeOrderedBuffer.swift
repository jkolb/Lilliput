/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Justin Kolb
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

public final class UnsafeOrderedBuffer<Order : ByteOrder> {
    public let buffer: UnsafeBuffer
    public var remainingBytes: UnsafeMutableRawPointer {
        return buffer.bytes.advanced(by: position)
    }
    public var count: Int {
        return buffer.count
    }
    public var position: Int
    
    public init(buffer: UnsafeBuffer) {
        self.buffer = buffer
        self.position = 0
    }
    
    public var hasRemaining: Bool {
        return remainingCount > 0
    }
    
    public var remainingCount: Int {
        return count - position
    }
    
    @inline(__always) public func copyFromBuffer<T>(_ source: UnsafeOrderedBuffer<T>) {
        let count = min(remainingCount, source.remainingCount)
        
        if count == 0 {
            return
        }
        
        remainingBytes.copyBytes(from: source.remainingBytes, count: count)
        source.position += count
        position += count
    }
    
    @inline(__always) public func copyToBuffer<T>(_ destination: UnsafeOrderedBuffer<T>) {
        let count = min(remainingCount, destination.remainingCount)
        
        if count == 0 {
            return
        }
        
        destination.remainingBytes.copyBytes(from: remainingBytes, count: count)
        destination.position += count
        position += count
    }
    
    @inline(__always) public func copyFromBuffer(_ source: UnsafeBuffer) {
        let count = min(remainingCount, source.count)
        
        if count == 0 {
            return
        }
        
        remainingBytes.copyBytes(from: source.bytes, count: count)
        position += count
    }

    @inline(__always) public func copyToBuffer(_ destination: UnsafeBuffer) {
        let count = min(remainingCount, destination.count)
        
        if count == 0 {
            return
        }
        
        destination.bytes.copyBytes(from: remainingBytes, count: count)
        position += count
    }

    @inline(__always) public func getRaw16Bits() -> (UInt8, UInt8) {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8).self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return value
    }
    
    @inline(__always) public func getRaw24Bits() -> (UInt8, UInt8, UInt8) {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8).self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return value
    }
    
    @inline(__always) public func getRaw32Bits() -> (UInt8, UInt8, UInt8, UInt8) {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8, UInt8).self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return value
    }
    
    @inline(__always) public func getRaw64Bits() -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8) {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8).self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return value
    }
    
    @inline(__always) public func getInt8() -> Int8 {
        return Int8(bitPattern: getUInt8())
    }
    
    @inline(__always) public func getInt16() -> Int16 {
        return Int16(bitPattern: getUInt16())
    }
    
    @inline(__always) public func getInt32() -> Int32 {
        return Int32(bitPattern: getUInt32())
    }
    
    @inline(__always) public func getInt64() -> Int64 {
        return Int64(bitPattern: getUInt64())
    }
    
    @inline(__always) public func getUInt8() -> UInt8 {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: UInt8.self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return value
    }
    
    @inline(__always) public func getUInt16() -> UInt16 {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: UInt16.self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return Order.swapUInt16(value)
    }
    
    @inline(__always) public func getUInt32() -> UInt32 {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: UInt32.self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return Order.swapUInt32(value)
    }
    
    @inline(__always) public func getUInt64() -> UInt64 {
        let value = buffer.bytes.advanced(by: position).bindMemory(to: UInt64.self, capacity: 1).pointee
        position += MemoryLayout.size(ofValue: value)
        return Order.swapUInt64(value)
    }
    
    @inline(__always) public func getFloat32() -> Float32 {
        return unsafeBitCast(getUInt32(), to: Float32.self)
    }
    
    @inline(__always) public func getFloat64() -> Float64 {
        return unsafeBitCast(getUInt64(), to: Float64.self)
    }
    
    @inline(__always) public func getInt8(count: Int) -> [Int8] {
        precondition(count <= remainingCount)
        var array = [Int8](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (pointer) -> Void in
            pointer.baseAddress!.copyBytes(from: remainingBytes, count: count)
        }
        position += count
        return array
    }
    
    @inline(__always) public func getInt16(count: Int) -> [Int16] {
        precondition(count <= remainingCount)
        var array = [Int16](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<Int16>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getInt16(), toByteOffset: byteOffset, as: Int16.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getInt32(count: Int) -> [Int32] {
        precondition(count <= remainingCount)
        var array = [Int32](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<Int32>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getInt32(), toByteOffset: byteOffset, as: Int32.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getInt64(count: Int) -> [Int64] {
        precondition(count <= remainingCount)
        var array = [Int64](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<Int64>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getInt64(), toByteOffset: byteOffset, as: Int64.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getUInt8(count: Int) -> [UInt8] {
        precondition(count <= remainingCount)
        var array = [UInt8](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (pointer) -> Void in
            pointer.baseAddress!.copyBytes(from: remainingBytes, count: count)
        }
        position += count
        return array
    }
    
    @inline(__always) public func getUInt16(count: Int) -> [UInt16] {
        precondition(count <= remainingCount)
        var array = [UInt16](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<UInt16>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getUInt16(), toByteOffset: byteOffset, as: UInt16.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getUInt32(count: Int) -> [UInt32] {
        precondition(count <= remainingCount)
        var array = [UInt32](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<UInt32>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getUInt32(), toByteOffset: byteOffset, as: UInt32.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getUInt64(count: Int) -> [UInt64] {
        precondition(count <= remainingCount)
        var array = [UInt64](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<UInt64>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getUInt64(), toByteOffset: byteOffset, as: UInt64.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getFloat32(count: Int) -> [Float32] {
        precondition(count <= remainingCount)
        var array = [Float32](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<Float32>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getFloat32(), toByteOffset: byteOffset, as: Float32.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getFloat64(count: Int) -> [Float64] {
        precondition(count <= remainingCount)
        var array = [Float64](repeating: 0, count: count)
        array.withUnsafeMutableBytes { (arrayBytes) -> Void in
            let stride = MemoryLayout<Float64>.stride
            var byteOffset = 0
            
            for _ in 1...count {
                arrayBytes.storeBytes(of: getFloat64(), toByteOffset: byteOffset, as: Float64.self)
                byteOffset += stride
            }
        }
        return array
    }
    
    @inline(__always) public func getInt8At(_ position: Int) -> Int8 {
        return Int8(bitPattern: getUInt8At(position))
    }
    
    @inline(__always) public func getInt16At(_ position: Int) -> Int16 {
        return Int16(bitPattern: getUInt16At(position))
    }
    
    @inline(__always) public func getInt32At(_ position: Int) -> Int32 {
        return Int32(bitPattern: getUInt32At(position))
    }
    
    @inline(__always) public func getInt64At(_ position: Int) -> Int64 {
        return Int64(bitPattern: getUInt64At(position))
    }

    @inline(__always) public func getUInt8At(_ position: Int) -> UInt8 {
        return buffer.bytes.advanced(by: position).bindMemory(to: UInt8.self, capacity: 1).pointee
    }
    
    @inline(__always) public func getUInt16At(_ position: Int) -> UInt16 {
        return Order.swapUInt16(buffer.bytes.advanced(by: position).bindMemory(to: UInt16.self, capacity: 1).pointee)
    }
    
    @inline(__always) public func getUInt32At(_ position: Int) -> UInt32 {
        return Order.swapUInt32(buffer.bytes.advanced(by: position).bindMemory(to: UInt32.self, capacity: 1).pointee)
    }
    
    @inline(__always) public func getUInt64At(_ position: Int) -> UInt64 {
        return Order.swapUInt64(buffer.bytes.advanced(by: position).bindMemory(to: UInt64.self, capacity: 1).pointee)
    }
    
    @inline(__always) public func getFloat32At(_ position: Int) -> Float32 {
        return unsafeBitCast(getUInt32At(position), to: Float32.self)
    }
    
    @inline(__always) public func getFloat64At(_ position: Int) -> Float64 {
        return unsafeBitCast(getUInt64At(position), to: Float64.self)
    }
    
    @inline(__always) public func getUTF8(length: Int) -> String {
        return decodeCodeUnits(getUInt8(count: length), codec: UTF8())
    }
    
    @inline(__always) public func getTerminatedUTF8(terminator: UInt8 = 0) -> String {
        return decodeCodeUnits(getTerminatedUInt8(terminator: terminator), codec: UTF8())
    }
    
    @inline(__always) public func getUTF16(length: Int) -> String {
        return decodeCodeUnits(getUInt16(count: length), codec: UTF16())
    }
    
    @inline(__always) fileprivate func decodeCodeUnits<C : UnicodeCodec>(_ codeUnits: [C.CodeUnit], codec: C) -> String {
        var decodeCodec = codec
        var generator = codeUnits.makeIterator()
        var characters = [Character]()
        characters.reserveCapacity(codeUnits.count)
        var done = false
        
        while (!done) {
            switch decodeCodec.decode(&generator) {
            case .scalarValue(let scalar):
                characters.append(Character(scalar))
                
            case .emptyInput:
                done = true
                
            case .error:
                done = true
            }
        }
        
        return String(characters)
    }
    
    @inline(__always) public func getTerminatedUInt8(terminator: UInt8 = 0) -> [UInt8] {
        var array = [UInt8]()
        var done = true
        
        while (!done) {
            let value = getUInt8()
            
            if (value == terminator) {
                done = true
            } else {
                array.append(value)
            }
        }
        
        return array
    }
    
    @inline(__always) public func putRaw16Bits(_ value: (UInt8, UInt8)) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8).self, capacity: 1).pointee = value
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putRaw24Bits(_ value: (UInt8, UInt8, UInt8)) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8).self, capacity: 1).pointee = value
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putRaw32Bits(_ value: (UInt8, UInt8, UInt8, UInt8)) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8, UInt8).self, capacity: 1).pointee = value
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putRaw64Bits(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8).self, capacity: 1).pointee = value
        position += MemoryLayout.size(ofValue: value)
    }

    @inline(__always) public func putInt8(_ value: Int8) {
        putUInt8(UInt8(bitPattern: value))
    }
    
    @inline(__always) public func putInt16(_ value: Int16) {
        putUInt16(UInt16(bitPattern: value))
    }
    
    @inline(__always) public func putInt32(_ value: Int32) {
        putUInt32(UInt32(bitPattern: value))
    }
    
    @inline(__always) public func putInt64(_ value: Int64) {
        putUInt64(UInt64(bitPattern: value))
    }
    
    @inline(__always) public func putUInt8(_ value: UInt8) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt8.self, capacity: 1).pointee = value
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putUInt16(_ value: UInt16) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt16.self, capacity: 1).pointee = Order.swapUInt16(value)
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putUInt32(_ value: UInt32) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt32.self, capacity: 1).pointee = Order.swapUInt32(value)
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putUInt64(_ value: UInt64) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt64.self, capacity: 1).pointee = Order.swapUInt64(value)
        position += MemoryLayout.size(ofValue: value)
    }
    
    @inline(__always) public func putFloat32(_ value: Float32) {
        putUInt32(unsafeBitCast(value, to: UInt32.self))
    }
    
    @inline(__always) public func putFloat64(_ value: Float64) {
        putUInt64(unsafeBitCast(value, to: UInt64.self))
    }
    
    @inline(__always) public func putInt8(_ array: [Int8]) {
        for value in array { putInt8(value) }
    }
    
    @inline(__always) public func putInt16(_ array: [Int16]) {
        for value in array { putInt16(value) }
    }
    
    @inline(__always) public func putInt32(_ array: [Int32]) {
        for value in array { putInt32(value) }
    }
    
    @inline(__always) public func putInt64(_ array: [Int64]) {
        for value in array { putInt64(value) }
    }
    
    @inline(__always) public func putUInt8(_ array: [UInt8]) {
        for value in array { putUInt8(value) }
    }
    
    @inline(__always) public func putUInt16(_ array: [UInt16]) {
        for value in array { putUInt16(value) }
    }
    
    @inline(__always) public func putUInt32(_ array: [UInt32]) {
        for value in array { putUInt32(value) }
    }
    
    @inline(__always) public func putUInt64(_ array: [UInt64]) {
        for value in array { putUInt64(value) }
    }
    
    @inline(__always) public func putFloat32(_ array: [Float32]) {
        for value in array { putFloat32(value) }
    }
    
    @inline(__always) public func putFloat64(_ array: [Float64]) {
        for value in array { putFloat64(value) }
    }
    
    @inline(__always) public func putRaw16Bits(_ array: [(UInt8, UInt8)]) {
        for value in array { putRaw16Bits(value) }
    }
    
    @inline(__always) public func putRaw24Bits(_ array: [(UInt8, UInt8, UInt8)]) {
        for value in array { putRaw24Bits(value) }
    }
    
    @inline(__always) public func putRaw32Bits(_ array: [(UInt8, UInt8, UInt8, UInt8)]) {
        for value in array { putRaw32Bits(value) }
    }
    
    @inline(__always) public func putRaw64Bits(_ array: [(UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)]) {
        for value in array { putRaw64Bits(value) }
    }
    
    @inline(__always) public func putRaw16Bits(_ value: (UInt8, UInt8), at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8).self, capacity: 1).pointee = value
    }
    
    @inline(__always) public func putRaw24Bits(_ value: (UInt8, UInt8, UInt8), at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8).self, capacity: 1).pointee = value
    }
    
    @inline(__always) public func putRaw32Bits(_ value: (UInt8, UInt8, UInt8, UInt8), at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8, UInt8).self, capacity: 1).pointee = value
    }
    
    @inline(__always) public func putRaw64Bits(_ value: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8), at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8).self, capacity: 1).pointee = value
    }
    
    @inline(__always) public func putInt8(_ value: Int8, at position: Int) {
        putUInt8(UInt8(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putInt16(_ value: Int16, at position: Int) {
        putUInt16(UInt16(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putInt32(_ value: Int32, at position: Int) {
        putUInt32(UInt32(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putInt64(_ value: Int64, at position: Int) {
        putUInt64(UInt64(bitPattern: value), at: position)
    }
    
    @inline(__always) public func putUInt8(_ value: UInt8, at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt8.self, capacity: 1).pointee = value
    }
    
    @inline(__always) public func putUInt16(_ value: UInt16, at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt16.self, capacity: 1).pointee = Order.swapUInt16(value)
    }
    
    @inline(__always) public func putUInt32(_ value: UInt32, at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt32.self, capacity: 1).pointee = Order.swapUInt32(value)
    }
    
    @inline(__always) public func putUInt64(_ value: UInt64, at position: Int) {
        buffer.bytes.advanced(by: position).bindMemory(to: UInt64.self, capacity: 1).pointee = Order.swapUInt64(value)
    }
    
    @inline(__always) public func putFloat32(_ value: Float32, at position: Int) {
        putUInt32(unsafeBitCast(value, to: UInt32.self), at: position)
    }
    
    @inline(__always) public func putFloat64(_ value: Float64, at position: Int) {
        putUInt64(unsafeBitCast(value, to: UInt64.self), at: position)
    }
    
    @inline(__always) public func putUTF8(_ value: String) {
        value.utf8.forEach { putUInt8($0) }
    }
    
    @inline(__always) public func putTerminatedUTF8(_ value: String, terminator: UTF8.CodeUnit = 0) {
        putUTF8(value)
        putUInt8(terminator)
    }
    
    @inline(__always) public func align(_ byteCount: Int) {
        position += (byteCount - (position % byteCount)) % byteCount
    }
}
