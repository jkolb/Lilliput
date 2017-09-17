import XCTest
@testable import LilliputTests

XCTMain([
     testCase(ByteOrderTestCase.allTests),
     testCase(UnsafeOrderedBufferTestCase.allTests),
])
