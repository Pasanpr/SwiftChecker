//
//  SwiftChecker+Declarations.swift
//  SwiftChecker
//
//  Created by Pasan Premaratne on 2/24/19.
//

import Foundation
import SwiftAST

fileprivate extension Literal {
    static func literalFromType<T>(_ type: T.Type, value: T) -> Literal? {
        let typeDescription = String(describing: type)
        switch typeDescription {
        case "String":
            let stringValue = value as! String
            return Literal.string(stringValue)
        case "Int":
            let intValue = value as! Int
            return Literal.integer(intValue)
        default: return nil
        }
    }
}

// MARK: - Declarations
extension SwiftChecker {
    public func assertContainsConstant<T: CustomStringConvertible>(named name: String, ofType type: T.Type, containingValue value: T) throws -> Bool {
        
        guard let literal = Literal.literalFromType(type, value: value) else { return false }
        let expression = Expression.prefix(operator: nil, rhs: .primary(.literal(literal)))
        return try assertContainsConstant(named: name, ofType: type, containingExpression: expression)
    }
    
    public func assertContainsConstant<T>(named name: String, ofType type: T.Type, containingExpression expression: Expression) throws -> Bool {
        let declrType = Type.typeIdentifier(identifier: String(describing: type))
        let declaration = Declaration.constant(identifier: name, type: declrType, expression: expression)
        return try assertContainsDeclaration(declaration)
    }
    
    public func assertContainsDeclaration(_ declaration: Declaration) throws -> Bool {
        self.targetDeclaration = declaration
        return try traverse()
    }
}


