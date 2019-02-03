import XCTest
@testable import AvahiClient

final class AvahiSimplePollTests: XCTestCase {
    static var allTests = [
        ("testNewAvahiSimplePoll", testNewAvahiSimplePoll),
    ]

    func testNewAvahiSimplePoll() {
        do {
            let _ = try AvahiSimplePoll()
        } catch {
            XCTFail("\(error)")
        }
    }
}
