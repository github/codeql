import codeql.unified.Ast

query predicate identifier(Swift::SimpleIdentifier node, string name) { name = node.getValue() }

query predicate func(Swift::FunctionDeclaration node) { any() }
