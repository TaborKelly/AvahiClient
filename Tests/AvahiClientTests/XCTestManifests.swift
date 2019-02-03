import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AvahiClientTests.allTests),
        testCase(AvahiSimplePollTests.allTests),
    ]
}
#endif
