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

        while position < characters.count {
            let character = characters[position]

            if character == "\"" {
                position += 1
                break
            }

            if character == "\\" {
                guard position + 1 < characters.count else {
                    position += 1
                    break
                }

                let escaped = characters[position + 1]

                switch escaped {
                case "\"":
                    string.append("\"")
                case "\\":
                    string.append("\\")
                case "n":
                    string.append("\n")
                case "r":
                    string.append("\r")
                case "t":
                    string.append("\t")
                case "b":
                    string.append("\u{0008}")
                case "f":
                    string.append("\u{000C}")
                case "/":
                    string.append("/")
                default:
                    string.append(escaped)
                }

                position += 2
            } else {
                string.append(character)
                position += 1
            }
        }

        return .string(string)
    }

}
