import codeql.unified.Ast

query predicate identifier(Swift::SimpleIdentifier node, string name) { name = node.getValue() }

query predicate func(Swift::FunctionDeclaration node) { any() }

query predicate add(Swift::AdditiveExpression node, Swift::AstNode lhs, Swift::AstNode rhs) {
  lhs = node.getLhs(0) and rhs = node.getRhs(0)
}
