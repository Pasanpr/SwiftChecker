import Foundation
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
    
    internal func traverse() throws -> Bool {
        let program = try generateAST()
        return try traverse(program)
    }
    
    internal var targetDeclaration: Declaration?
    internal var targetExpression: Expression?
    internal var targetPrimaryExpression: PrimaryExpression?
    internal var targetPrefixExpression: PrefixExpression?
    internal var targetPostfixExpression: PostfixExpression?
}
