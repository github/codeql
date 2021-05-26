import codeql_ql.ast.Ast as AST
import TreeSitter

cached
newtype TAstNode =
  TClasslessPredicate(Generated::ModuleMember member, Generated::ClasslessPredicate pred) {
    pred.getParent() = member
  } or
  TVarDecl(Generated::VarDecl decl) or
  TBody(Generated::Body body) or
  TClass(Generated::Dataclass dc) or
  TCharPred(Generated::Charpred pred) or
  TClassPredicate(Generated::MemberPredicate pred)

/**
 * Gets the underlying TreeSitter entity for a given AST node.
 */
Generated::AstNode toGenerated(AST::AstNode n) {
  n = TClasslessPredicate(_, result)
  or
  n = TVarDecl(result)
  or
  n = TBody(result)
  or
  n = TClass(result)
  or
  n = TCharPred(result)
  or
  n = TClassPredicate(result)
}
