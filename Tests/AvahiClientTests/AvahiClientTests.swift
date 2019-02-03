import XCTest
@testable import AvahiClient

final class AvahiClientTests: XCTestCase {
    static var allTests = [
        ("testNewAvahiClient", testNewAvahiClient),
    ]

    func testNewAvahiClient() {
        do {
            let c = try AvahiClient()
            print(c)
        } catch {
            XCTFail("\(error)")
        }
    }
}
