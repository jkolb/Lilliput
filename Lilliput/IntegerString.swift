//
// IntegerString.swift
// Lilliput
//
// Copyright (c) 2014 Justin Kolb - https://github.com/jkolb/Lilliput
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

public func hex<T: _SignedIntegerType>(value: T) -> String {
    return pad(String(value, radix: 16), padChar: "0", length: sizeof(T) * 2)
}

public func hex<T: UnsignedIntegerType>(value: T) -> String {
    return pad(String(value, radix: 16), padChar: "0", length: sizeof(T) * 2)
}

public func binary<T: _SignedIntegerType>(value: T) -> String {
    return pad(String(value, radix: 2), padChar: "0", length: sizeof(T) * 8)
}

public func binary<T: UnsignedIntegerType>(value: T) -> String {
    return pad(String(value, radix: 2), padChar: "0", length: sizeof(T) * 8)
}

public func octal<T: _SignedIntegerType>(value: T, length: Int = 0) -> String {
    return pad(String(value, radix: 8), padChar: "0", length: length)
}

public func octal<T: UnsignedIntegerType>(value: T, length: Int = 0) -> String {
    return pad(String(value, radix: 8), padChar: "0", length: length)
}

public func base36<T: _SignedIntegerType>(value: T, length: Int = 0) -> String {
    return pad(String(value, radix: 36), padChar: "0", length: length)
}

public func base36<T: UnsignedIntegerType>(value: T, length: Int = 0) -> String {
    return pad(String(value, radix: 36), padChar: "0", length: length)
}

public func pad(string: String, padChar: Character, length: Int) -> String {
    let stringLength = string.characters.count
    if (stringLength >= length) { return string }
    let padding = String(count: length - stringLength, repeatedValue: padChar)
    return padding + string
}
