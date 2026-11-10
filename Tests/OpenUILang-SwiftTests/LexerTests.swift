//
//  LexerTests.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//


import Testing
@testable import OpenUILang_Swift

@Suite("Lexer Tests")
struct LexerTests {
    @Test("Lexer recognizes an identifier")
    func lexerRecognizesIdentifier() {
        let lexer = Lexer(source: "title")
        
        let tokens = lexer.tokenize()
        
        #expect(tokens.count == 1)
        
        guard case .identifier("title") = tokens[0] else {
            Issue.record("Expected identifier token")
            return
        }
    }
    
    
    @Test("Lexer recognizes multiple identifiers")
    func lexerRecognizesMultipleIdentifiers() {
        let lexer = Lexer(source: "title button root")
        
        let tokens = lexer.tokenize()
        
        #expect(tokens.count == 3)
        
        guard case .identifier("title") = tokens[0],
              case .identifier("button") = tokens[1],
              case .identifier("root") = tokens[2] else {
            Issue.record("Expected three identifier tokens")
            return
        }
    }
    
    
    @Test("Lexer recognizes assignment operator")
    func lexerRecognizesEquals() {
        let lexer = Lexer(source: "title = TextContent")
        
        let tokens = lexer.tokenize()
        
        #expect(tokens.count == 3)
        
        guard case .identifier("title") = tokens[0],
              case .equals = tokens[1],
              case .identifier("TextContent") = tokens[2] else {
            Issue.record("Expected identifier, equals, identifier")
            return
        }
    }
    
    @Test("Lexer recognizes an equals sign without spaces")
    func lexerRecognizesEqualsWithoutSpaces() {
        let lexer = Lexer(source: "=")
        
        let tokens = lexer.tokenize()
        
        #expect(tokens.count == 1)
        
        guard case .equals = tokens[0] else {
            Issue.record("Expected an equals token")
            return
        }
    }
    
    
    @Test("Lexer recognizes parentheses")
    func lexerRecognizesParentheses() {
        let lexer = Lexer(source: "TextContent()")
        let tokens = lexer.tokenize()
        
        #expect(tokens.count == 3)
        
        guard case .identifier("TextContent") = tokens[0],
              case .leftParen = tokens[1],
              case .rightParen = tokens[2] else {
            Issue.record("Expected identifier and parentheses")
            return
        }
    }
    
    
    @Test(
        "Recognizes punctuation tokens",
        arguments: [
            ("=", Token.equals),
            ("(", Token.leftParen),
            (")", Token.rightParen),
            ("[", Token.leftBracket),
            ("]", Token.rightBracket),
            (",", Token.comma)
        ]
    )
    func recognizesPunctuation(
        source: String,
        expected: Token
    ) {
        let lexer = Lexer(source: source)
        let tokens = lexer.tokenize()

        #expect(tokens.count == 1)
        #expect(tokens.first == expected)
    }
    
    @Test("Identifier stops at punctuation")
    func identifierStopsAtPunctuation() {
        let lexer = Lexer(source: "hello=world")
        let tokens = lexer.tokenize()

        #expect(tokens == [
            .identifier("hello"),
            .equals,
            .identifier("world")
        ])
    }
}
