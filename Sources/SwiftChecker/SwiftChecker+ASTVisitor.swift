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
        case .binary:
            fatalError()
        }
    }
    
    public func visit(_ expression: PrimaryExpression) throws -> Bool {
        if let targetPrimaryExpression = targetPrimaryExpression {
            // Ignoring the value of literals
            // In the event that we don't care what students assign as a value
            switch targetPrimaryExpression {
            case .literal(let literal):
                switch literal {
                case .string(let value):
                    if value == "discard" {
                        return true
                    }
                    break
                default: break
                }
            default: break
            }
            
            
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
