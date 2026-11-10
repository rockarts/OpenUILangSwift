//
//  AssignmentTests.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//


import Testing
@testable import OpenUILang_Swift

@Test("An assignment associates a name with an expression")
func assignmentStoresIdentifierAndExpression() {
    let assignment = Assignment(
        name: "count",
        expression: .number(42)
    )

    #expect(assignment.name == "count")

    guard case .number(42) = assignment.expression else {
        Issue.record("Expected the number 42")
        return
    }
}
