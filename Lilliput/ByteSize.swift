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

public struct ByteSize : IntegerLiteralConvertible, CustomStringConvertible, Comparable {
    public let numberOfBytes: Int
    
    public init(_ numberOfBytes: Int) {
        precondition(numberOfBytes >= 0)
        self.numberOfBytes = numberOfBytes
    }
    
    public init(integerLiteral value: Int) {
        precondition(value >= 0)
        self.numberOfBytes = value
    }

    @warn_unused_result
    public func align(byteCount: Int) -> ByteSize {
        precondition(byteCount > 0)
        let baseAlignmentFactor = numberOfBytes / byteCount
        let requiresAdditionalFactor = (numberOfBytes % byteCount) > 0
        let alignmentFactor: Int
        if requiresAdditionalFactor {
            alignmentFactor = baseAlignmentFactor + 1
        }
        else {
            alignmentFactor = baseAlignmentFactor
        }
        return ByteSize(alignmentFactor * byteCount)
    }
    
    public var description: String {
        return numberOfBytes.description
    }
}

public func ==(lhs: ByteSize, rhs: ByteSize) -> Bool {
    return lhs.numberOfBytes == rhs.numberOfBytes
}

public func <(lhs: ByteSize, rhs: ByteSize) -> Bool {
    return lhs.numberOfBytes < rhs.numberOfBytes
}
