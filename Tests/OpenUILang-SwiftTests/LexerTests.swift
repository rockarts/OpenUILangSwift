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
    
    @Test("Lexer recognizes string literals")
    func recognizesStringLiterals() {
        let lexer = Lexer(
            source: #"title = TextContent("Hello World")"#
        )

        let tokens = lexer.tokenize()

        #expect(tokens == [
            .identifier("title"),
            .equals,
            .identifier("TextContent"),
            .leftParen,
            .string("Hello World"),
            .rightParen
        ])
    }
    
    @Test("Lexer handles an unterminated string without crashing")
    func handlesUnterminatedString() {
        let lexer = Lexer(source: "\"Hello World")

        let tokens = lexer.tokenize()

        #expect(tokens == [
            .string("Hello World")
        ])
    }

    
    @Test("Lexer handles escaped quotation marks")
    func recognizesEscapedQuotes() {
        let lexer = Lexer(
            source: #""Hi \"Hello\"""#
        )

        let tokens = lexer.tokenize()

        #expect(tokens == [
            .string("Hi \"Hello\"")
        ])
    }
    
    
    @Test("Lexer recognizes escaped backslashes")
    func recognizesEscapedBackslashes() {
        let lexer = Lexer(source: #""Hello\\World""#)

        let tokens = lexer.tokenize()

        #expect(tokens == [
            .string("Hello\\World")
        ])
    }

    @Test(
        "Recognizes supported string escape sequences",
        arguments: [
            (#""Hello \"World\"""#, "Hello \"World\""),
            (#""Hello\\World""#, "Hello\\World"),
            (#""Hello\nWorld""#, "Hello\nWorld"),
            (#""Hello\rWorld""#, "Hello\rWorld"),
            (#""Hello\tWorld""#, "Hello\tWorld"),
            (#""Hello\bWorld""#, "Hello\u{0008}World"),
            (#""Hello\fWorld""#, "Hello\u{000C}World"),
            (#""Hello\/World""#, "Hello/World")
        ]
    )
    func recognizesStringEscapes(
        source: String,
        expected: String
    ) {
        let lexer = Lexer(source: source)
        let tokens = lexer.tokenize()

        #expect(tokens == [.string(expected)])
    }

    @Test("Recognizes multiple escape sequences in one string")
    func recognizesMultipleEscapes() {
        let lexer = Lexer(
            source: #""First\nSecond\t\"Hello\"""#
        )

        let tokens = lexer.tokenize()

        #expect(tokens == [
            .string("First\nSecond\t\"Hello\"")
        ])
    }

    @Test("Recognizes an empty string")
    func recognizesEmptyString() {
        let lexer = Lexer(source: #""""#)

        #expect(lexer.tokenize() == [.string("")])
    }

    @Test("Handles trailing backslash without crashing")
    func handlesTrailingBackslash() {
        let lexer = Lexer(source: #""Hello\"#)

        #expect(lexer.tokenize() == [
            .string("Hello")
        ])
    }

    @Test("Handles unknown escapes using current fallback")
    func handlesUnknownEscape() {
        let lexer = Lexer(source: #""Hello\qWorld""#)

        #expect(lexer.tokenize() == [
            .string("HelloqWorld")
        ])
    }
    
    @Test(
        "Lexer decodes Unicode escapes",
        arguments: [
            (#""\u0041""#, "A"),
            (#""\u00E9""#, "é"),
            (#""\u03A9""#, "Ω"),
            (#""\u2764""#, "❤")
        ]
    )
    func recognizesUnicodeEscapes(
        source: String,
        expected: String
    ) {
        let lexer = Lexer(source: source)
        let tokens = lexer.tokenize()

        #expect(tokens == [.string(expected)])
    }
    
    @Test("Lexer decodes Unicode surrogate pairs")
    func recognizesSurrogatePairs() {
        let lexer = Lexer(source: #""\uD83D\uDE00""#)

        let tokens = lexer.tokenize()

        #expect(tokens == [.string("😀")])
    }

    @Test(
        "Decodes Unicode escapes",
        arguments: [
            (#""\u0041""#, "A"),
            (#""\u00E9""#, "é"),
            (#""\u03A9""#, "Ω"),
            (#""\u2764""#, "❤"),
            (#""\uD83D\uDE00""#, "😀"),
            (#""\uD83D\uDE80""#, "🚀"),
            (#""Hello \uD83D\uDE00 World""#, "Hello 😀 World"),
            (#""\u0041\u0042\u0043""#, "ABC"),
            (#""\uD83D\uDE00\uD83D\uDE80""#, "😀🚀")
        ]
    )
    func decodesUnicodeEscapes(
        source: String,
        expected: String
    ) {
        let lexer = Lexer(source: source)

        #expect(lexer.tokenize() == [.string(expected)])
    }

    @Test("Handles isolated high surrogate")
    func handlesIsolatedHighSurrogate() {
        let lexer = Lexer(source: #""\uD83D""#)

        #expect(lexer.tokenize() == [.string("")])
    }

    @Test("Handles isolated low surrogate")
    func handlesIsolatedLowSurrogate() {
        let lexer = Lexer(source: #""\uDE00""#)

        #expect(lexer.tokenize() == [.string("")])
    }

}
