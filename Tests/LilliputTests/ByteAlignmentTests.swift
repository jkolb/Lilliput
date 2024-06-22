import XCTest
import Lilliput

final class ByteAlignmentTests: XCTestCase {
    func testOffsets() {
        XCTAssertEqual(0.offset(alignment: 4), 0)
        XCTAssertEqual(1.offset(alignment: 4), 3)
        XCTAssertEqual(2.offset(alignment: 4), 2)
        XCTAssertEqual(3.offset(alignment: 4), 1)
        XCTAssertEqual(4.offset(alignment: 4), 0)
        XCTAssertEqual(16.offset(alignment: 4), 0)
        XCTAssertEqual(17.offset(alignment: 4), 3)
        XCTAssertEqual(18.offset(alignment: 4), 2)
        XCTAssertEqual(19.offset(alignment: 4), 1)
        XCTAssertEqual(20.offset(alignment: 4), 0)
    }
}
