//
//  Lexer.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//

struct Lexer {
    let source: String
    
    func tokenize() -> [Token] {
        var tokens: [Token] = []
        
        let characters = Array(source)
        var position = 0
        
        while position < characters.count {
            let character = characters[position]
            
            switch character {
            case "=":
                tokens.append(.equals)
                position += 1
                
            case "(":
                tokens.append(.leftParen)
                position += 1
            case ")":
                tokens.append(.rightParen)
                position += 1
            case "[":
                tokens.append(.leftBracket)
                position += 1
            case "]":
                tokens.append(.rightBracket)
                position += 1
            case ",":
                tokens.append(.comma)
                position += 1
            case _ where character.isWhitespace:
                position += 1
            case _ where character.isLetter:
                var identifier = ""
                
                while position < characters.count &&
                        characters[position].isLetter {
                    identifier.append(characters[position])
                    position += 1
                }
                
                tokens.append(.identifier(identifier))
            default:
                // Handle unknown characters
                position += 1
            }
        }
        
        return tokens
    }
}
