import codeql_ql.ast.Ast as AST
import TreeSitter

cached
newtype TAstNode =
  TClasslessPredicate(Generated::ModuleMember member, Generated::ClasslessPredicate pred) {
    pred.getParent() = member
  } or
  TVarDecl(Generated::VarDecl decl) or
  TClass(Generated::Dataclass dc) or
  TCharPred(Generated::Charpred pred) or
  TClassPredicate(Generated::MemberPredicate pred) or
  TSelect(Generated::Select sel) or
  TModule(Generated::Module mod) or
  TNewType(Generated::Datatype dt) or
  TNewTypeBranch(Generated::DatatypeBranch branch) or
  TImport(Generated::ImportDirective imp) or
  TDisjunction(Generated::Disjunction disj) or
  TConjunction(Generated::Conjunction conj) or
  TComparisonFormula(Generated::CompTerm comp) or
  TComparisonOp(Generated::Compop op) or
  TQuantifier(Generated::Quantified quant) or
  TNegation(Generated::Negation neg) or
  TAddExpr(Generated::AddExpr addexp)

class TFormula = TDisjunction or TConjunction or TComparisonFormula or TQuantifier or TNegation;

class TBinOpExpr = TAddExpr;

class TExpr = TBinOpExpr;

Generated::AstNode toGeneratedFormula(AST::AstNode n) {
  n = TConjunction(result) or
  n = TDisjunction(result) or
  n = TComparisonFormula(result) or
  n = TComparisonOp(result) or
  n = TQuantifier(result) or
  n = TNegation(result)
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
  n = TClass(result)
  or
  n = TCharPred(result)
  or
  n = TClassPredicate(result)
  or
  n = TSelect(result)
  or
  n = TModule(result)
  or
  n = TNewType(result)
  or
  n = TNewTypeBranch(result)
  or
  n = TImport(result)
}

class TPredicate = TCharPred or TClasslessPredicate or TClassPredicate;

class TModuleMember = TClasslessPredicate or TClass or TModule or TNewType or TImport;
