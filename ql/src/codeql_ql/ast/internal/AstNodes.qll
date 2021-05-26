import codeql_ql.ast.Ast as AST
import TreeSitter

cached
newtype TAstNode =
  TClasslessPredicate(Generated::ModuleMember member, Generated::ClasslessPredicate pred) {
    pred.getParent() = member
  }

/**
 * Gets the underlying TreeSitter entity for a given AST node.
 */
Generated::AstNode toGenerated(AST::AstNode n) { n = TClasslessPredicate(_, result) }
