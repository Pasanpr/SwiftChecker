//
//  SwiftChecker+ASTVisitor.swift
//  SwiftAST
//
//  Created by Pasan Premaratne on 2/24/19.
//

import Foundation
import SwiftAST

extension SwiftChecker: ASTVisitor {
    public func visit(_ declaration: Declaration) throws -> Bool {
        if let targetDecl = targetDeclaration {
            guard targetDecl.identifier == declaration.identifier, targetDecl.type == declaration.type else {
                return false
            }
            
            self.targetExpression = targetDecl.expression
            
            return try visit(declaration.expression)
        } else {
            return true
        }
    }
    
    public func visit(_ expression: Expression) throws -> Bool {
        if let targetExpression = targetExpression {
            switch targetExpression {
            case .primary(let primary): self.targetPrimaryExpression = primary
            case .prefix(_, let rhs): self.targetPostfixExpression = rhs
            default: fatalError()
            }
        }
        
        switch expression {
        case .primary(let primary):
            return try visit(primary)
        case .prefix(_, let postfixExpr):
            return try visit(postfixExpr)
        case .binary(let op, let lhs, let rhs):
            fatalError()
        }
    }
    
    public func visit(_ expression: PrimaryExpression) throws -> Bool {
        if let targetPrimaryExpression = targetPrimaryExpression {
            return expression == targetPrimaryExpression
        }
        
        return true
    }
    
    public func visit(_ expression: PrefixExpression) throws -> Bool {
        fatalError()
    }
    
    public func visit(_ expression: PostfixExpression) throws -> Bool {
        switch expression {
        case .primary(let primary):
            if let postfixExpr = targetPostfixExpression {
                switch postfixExpr {
                case .primary(let primaryExpr): self.targetPrimaryExpression = primaryExpr
                default: fatalError()
                }
            }
            return try visit(primary)
        default: fatalError()
        }
    }
}
