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
  TType(Generated::TypeExpr type) or
  TDisjunction(Generated::Disjunction disj) or
  TConjunction(Generated::Conjunction conj) or
  TComparisonFormula(Generated::CompTerm comp) or
  TComparisonOp(Generated::Compop op) or
  TQuantifier(Generated::Quantified quant) or
  TAggregate(Generated::Aggregate agg) { agg.getChild(_) instanceof Generated::FullAggregateBody } or
  TIdentifier(Generated::Variable var) or
  TAsExpr(Generated::AsExpr asExpr) or
  TPredicateCall(Generated::CallOrUnqualAggExpr call) or
  TMemberCall(Generated::QualifiedExpr expr) {
    not expr.getChild(_).(Generated::QualifiedRhs).getChild(_) instanceof Generated::TypeExpr
  } or
  TInlineCast(Generated::QualifiedExpr expr) {
    expr.getChild(_).(Generated::QualifiedRhs).getChild(_) instanceof Generated::TypeExpr
  } or
  TNoneCall(Generated::SpecialCall call) or
  TAnyCall(Generated::Aggregate agg) {
    "any" = agg.getChild(0).(Generated::AggId).getValue() and
    not agg.getChild(_) instanceof Generated::FullAggregateBody
  } or
  TNegation(Generated::Negation neg) or
  TIfFormula(Generated::IfTerm ifterm) or
  TImplication(Generated::Implication impl) or
  TInstanceOf(Generated::InstanceOf inst) or
  TAddExpr(Generated::AddExpr addexp) or
  TLiteral(Generated::Literal lit) or
  TUnaryExpr(Generated::UnaryExpr unaryexpr) or
  TDontCare(Generated::Underscore dontcare) or
  TModuleExpr(Generated::ModuleExpr me) or
  TPredicateExpr(Generated::PredicateExpr pe)

class TFormula =
  TDisjunction or TConjunction or TComparisonFormula or TQuantifier or TNegation or TIfFormula or
      TImplication or TInstanceOf;

class TBinOpExpr = TAddExpr;

class TExpr =
  TBinOpExpr or TLiteral or TAggregate or TIdentifier or TInlineCast or TCall or TUnaryExpr or
      TDontCare;

class TCall = TPredicateCall or TMemberCall or TNoneCall or TAnyCall;

class TModuleRef = TImport or TModuleExpr;

Generated::AstNode toGeneratedFormula(AST::AstNode n) {
  n = TConjunction(result) or
  n = TDisjunction(result) or
  n = TComparisonFormula(result) or
  n = TComparisonOp(result) or
  n = TQuantifier(result) or
  n = TAggregate(result) or
  n = TIdentifier(result) or
  n = TNegation(result) or
  n = TIfFormula(result) or
  n = TImplication(result) or
  n = TInstanceOf(result)
}

Generated::AstNode toGeneratedExpr(AST::AstNode n) {
  n = TAddExpr(result) or
  n = TLiteral(result) or
  n = TAggregate(result) or
  n = TIdentifier(result) or
  n = TUnaryExpr(result) or
  n = TDontCare(result)
}

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
  or
  n = TType(result)
  or
  n = TAsExpr(result)
  or
  n = TModuleExpr(result)
  or
  n = TPredicateExpr(result)
  or
  n = TPredicateCall(result)
  or
  n = TMemberCall(result)
  or
  n = TInlineCast(result)
  or
  n = TNoneCall(result)
  or
  n = TAnyCall(result)
}

class TPredicate = TCharPred or TClasslessPredicate or TClassPredicate;

class TModuleMember = TClasslessPredicate or TClass or TModule or TNewType or TImport;
