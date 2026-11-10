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
            case "\"":
                tokens.append(readString(characters: characters, position: &position))
            case _ where character.isWhitespace:
                position += 1
            case _ where character.isLetter:
                tokens.append(readIdentifier(characters: characters, position: &position))
            default:
                // Handle unknown characters
                position += 1
            }
        }
        
        return tokens
    }
    
    func readIdentifier(characters: [Character], position: inout Int) -> Token {
        var identifier = ""
        
        while position < characters.count &&
                characters[position].isLetter {
            identifier.append(characters[position])
            position += 1
        }
        
        return .identifier(identifier)
    }
    
    private func readString(
        characters: [Character],
        position: inout Int
    ) -> Token {
        var string = ""
        position += 1
        
        while characters[position] != "\"" {
            print(characters[position])
            string.append(characters[position])
            position += 1
        }
        
        position += 1
        return .string(string)
    }
}
