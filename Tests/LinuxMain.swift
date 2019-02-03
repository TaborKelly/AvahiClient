import XCTest

import AvahiClientTests

var tests = [XCTestCaseEntry]()
tests += AvahiClientTests.allTests()
XCTMain(tests)