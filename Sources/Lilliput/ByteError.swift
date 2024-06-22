@frozen public enum ByteError: Error {
    case tooManyBytes
    case notEnoughBytes
    case leftOverBytes
    case outOfRange
    case unexpectedData
}
