import XCTest

extension DeclarationTests {
    static let __allTests = [
        ("testConstantNames", testConstantNames),
        ("testConstantTypes", testConstantTypes),
        ("testConstantValues", testConstantValues),
        ("testConstantContainsAnyValueOfType", testConstantContainsAnyValueOfType),
        ("testContainsConstant", testContainsConstant),
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
