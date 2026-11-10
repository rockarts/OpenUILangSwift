//
//  ExpressionTests.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//

import Testing
@testable import OpenUILang_Swift

@Test("Component expressions support mixed argument types")
func componentSupportsMixedArguments() {
    let expression = Expression.component(
        "Button",
        [
            .string("Submit"),
            .boolean(true)
        ]
    )

    guard case let .component(name, arguments) = expression else {
        Issue.record("Expected a component expression")
        return
    }

    #expect(name == "Button")
    #expect(arguments.count == 2)

    guard case .string("Submit") = arguments[0] else {
        Issue.record("Expected a string argument")
        return
    }

    guard case .boolean(true) = arguments[1] else {
        Issue.record("Expected a boolean argument")
        return
    }
}


@Test("Components can contain nested component expressions")
func componentSupportsNesting() {
    let expression = Expression.component(
        "Card",
        [
            .component(
                "TextContent",
                [.string("Hello World"), .string("large-heavy")]
            )
        ]
    )

    guard case let .component(name, arguments) = expression else {
        Issue.record("Expected Card component")
        return
    }

    #expect(name == "Card")
    #expect(arguments.count == 1)

    guard case let .component(childName, childArguments) = arguments[0] else {
        Issue.record("Expected nested component")
        return
    }

    #expect(childName == "TextContent")
    #expect(childArguments.count == 2)
}



@Test("Arrays can contain expressions of different types")
func arraySupportsMixedExpressions() {
    let expression = Expression.array([
        .string("Hello"),
        .number(42),
        .boolean(true)
    ])

    guard case let .array(elements) = expression else {
        Issue.record("Expected an array expression")
        return
    }

    #expect(elements.count == 3)

    guard case .string("Hello") = elements[0] else {
        Issue.record("Expected string as first element")
        return
    }

    guard case .number(42) = elements[1] else {
        Issue.record("Expected number as second element")
        return
    }

    guard case .boolean(true) = elements[2] else {
        Issue.record("Expected boolean as third element")
        return
    }
}


@Test("Expressions can reference identifiers")
func expressionSupportsReferences() {
    let expression = Expression.component(
        "Stack",
        [
            .array([
                .reference("title"),
                .reference("button")
            ])
        ]
    )

    guard case let .component(name, arguments) = expression else {
        Issue.record("Expected a component")
        return
    }

    #expect(name == "Stack")

    guard case let .array(children) = arguments[0] else {
        Issue.record("Expected an array")
        return
    }

    #expect(children.count == 2)

    guard case .reference("title") = children[0] else {
        Issue.record("Expected reference to title")
        return
    }

    guard case .reference("button") = children[1] else {
        Issue.record("Expected reference to button")
        return
    }
}

