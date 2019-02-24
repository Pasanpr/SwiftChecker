import XCTest

extension DeclarationTests {
    static let __allTests = [
        ("testConstantNames", testConstantNames),
        ("testConstantTypes", testConstantTypes),
        ("testConstantValues", testConstantValues),
        ("testLinuxSuiteIncludesAllTests", testLinuxSuiteIncludesAllTests),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DeclarationTests.__allTests),
    ]
}
#endif
