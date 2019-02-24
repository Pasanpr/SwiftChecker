import SwiftAST

public class SwiftChecker {
    private var source: String
    
    public init(source: String) {
        self.source = source
    }
    
    public convenience init() {
        self.init(source: "")
    }
    
    public func setSource(filepath: String) {
        // read in contents of file
        fatalError()
    }
    
    public func setSource(source: String) {
        self.source = source
    }
    
    private func generateAST() throws -> Program {
        let ast = try SwiftAST(contentsOfFile: self.source)
        return try ast.generateAST()
    }
    
    private func traverse() throws -> Bool {
        let program = try generateAST()
        return try traverse(program)
    }
    
    private func traverse(_ program: Program) throws -> Bool {
        return try traverse(program.statements)
    }
    
    private func traverse(_ statements: [Statement]) throws -> Bool {
        for stmt in statements {
            guard try traverse(stmt) else { return false }
        }
        
        return true
    }
    
    private func traverse(_ statement: Statement) throws -> Bool {
        switch statement {
        case .declaration(let declaration):
            return try traverse(declaration)
        default: fatalError()
        }
    }
    
    private func traverse(_ declaration: Declaration) throws -> Bool {
        return try visit(declaration)
    }
    
    private var targetDeclaration: Declaration?
    
    func visit(_ declaration: Declaration) throws -> Bool {
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
    
    private var targetExpression: Expression?
    
    func visit(_ expression: Expression) throws -> Bool {
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
    
    private var targetPrimaryExpression: PrimaryExpression?
    
    func visit(_ expression: PrimaryExpression) throws -> Bool {
        if let targetPrimaryExpression = targetPrimaryExpression {
            return expression == targetPrimaryExpression
        }
        
        return true
    }
    
    private var targetPrefixExpression: PrefixExpression?
    
    func visit(_ expression: PrefixExpression) throws -> Bool {
        fatalError()
    }
    
    private var targetPostfixExpression: PostfixExpression?
    
    func visit(_ expression: PostfixExpression) throws -> Bool {
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

extension Literal {
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


