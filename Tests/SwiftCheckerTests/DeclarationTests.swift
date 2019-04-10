//
//  DeclarationTests.swift
//  SwiftCheckerTests
//
//  Created by Pasan Premaratne on 2/23/19.
//

import XCTest
@testable import SwiftChecker

class DeclarationTests: XCTestCase {
    let checker = SwiftChecker()
    
    override func setUp() {
        checker.setSource(source: "let foo = \"bar\"")
    }
    
    func testLinuxSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        let thisClass = type(of: self)
        let linuxCount = thisClass.__allTests.count
        #if swift(>=4.0)
        let darwinCount = thisClass.defaultTestSuite.testCaseCount
        #else
        let darwinCount = Int(thisClass.defaultTestSuite().testCaseCount)
        #endif
        XCTAssertEqual(linuxCount, darwinCount, "\(darwinCount - linuxCount) tests are missing from __allTests")
        #endif
    }
    
    // MARK: - Constants
    
    func testConstantNames() {
        try! XCTAssertTrue(checker.assertContainsConstant(named: "foo", ofType: String.self, containingValue: "bar"))
        try! XCTAssertFalse(checker.assertContainsConstant(named: "baz", ofType: String.self, containingValue: "bar"))
    }
    
    func testConstantTypes() {
        checker.setSource(source: "let foo = 1")
        try XCTAssertTrue(checker.assertContainsConstant(named: "foo", ofType: Int.self, containingValue: 1))
        try XCTAssertFalse(checker.assertContainsConstant(named: "foo", ofType: String.self, containingValue: "1"))
    }
    
    func testConstantValues() {
        try! XCTAssertFalse(checker.assertContainsConstant(named: "foo", ofType: String.self, containingValue: "baz"))
    }
    
    func testConstantContainsAnyValueOfType() {
        try! XCTAssertTrue(checker.assertContainsConstant(named: "foo", ofType: String.self, containingValue: "discard"))
    }
    
    // MARK: - Variables
}
