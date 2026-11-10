//
//  DocumentTests.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//


import Testing
@testable import OpenUILang_Swift

@Test("A document stores multiple assignments in order")
func documentStoresAssignments() {
    let document = Document(assignments: [
        Assignment(
            name: "root",
            expression: .component("Stack", [
                .array([.reference("title"), .reference("button")])
            ])
        ),
        Assignment(
            name: "title",
            expression: .component("TextContent", [.string("Hello World")])
        ),
        Assignment(
            name: "button",
            expression: .component("Button", [.string("Submit")])
        )
    ])

    #expect(document.assignments.count == 3)
    #expect(document.assignments[0].name == "root")
    #expect(document.assignments[1].name == "title")
    #expect(document.assignments[2].name == "button")
}
