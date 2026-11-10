//
//  ast.swift
//  OpenUILang-Swift
//
//  Created by Steven Rockarts on 2026-11-02.
//

indirect enum Expression {
    case string(String)
    case number(Double)
    case boolean(Bool)
    case array(Array<Expression>)
    case component(String, [Expression])
    case reference(String)
}
