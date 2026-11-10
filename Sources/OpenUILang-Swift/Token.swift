//
//  Token.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//

enum Token: Equatable {
    case identifier(String)
    case equals
    case leftParen
    case rightParen
    case leftBracket
    case rightBracket
    case comma
    case string(String)
}
