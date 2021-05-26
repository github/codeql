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
  TClassPredicate(Generated::MemberPredicate pred) or
  TDisjunction(Generated::Disjunction disj) or
  TConjunction(Generated::Conjunction conj) or
  TComparisonFormula(Generated::CompTerm comp) or
  TComparisonOp(Generated::Compop op) or
  TAddExpr(Generated::AddExpr addexp)


class TBinOpExpr = TAddExpr; // Can this work?

Generated::AstNode toGeneratedFormula(AST::AstNode n) {
  n = TConjunction(result) or
  n = TDisjunction(result) or
  n = TComparisonFormula(result)
}

Generated::AstNode toGeneratedExpr(AST::AstNode n) { n = TAddExpr(result) }

/**
 * Gets the underlying TreeSitter entity for a given AST node.
 */
Generated::AstNode toGenerated(AST::AstNode n) {
  result = toGeneratedExpr(n)
  or
  result = toGeneratedFormula(n)
  or
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
