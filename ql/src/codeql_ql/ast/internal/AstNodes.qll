import codeql_ql.ast.Ast as AST
import TreeSitter
private import Builtins

cached
newtype TAstNode =
  TTopLevel(Generated::Ql file) or
  TQLDoc(Generated::Qldoc qldoc) or
  TClasslessPredicate(Generated::ClasslessPredicate pred) or
  TVarDecl(Generated::VarDecl decl) or
  TClass(Generated::Dataclass dc) or
  TCharPred(Generated::Charpred pred) or
  TClassPredicate(Generated::MemberPredicate pred) or
  TDBRelation(Generated::DbTable table) or
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
  TFullAggregate(Generated::Aggregate agg) {
    agg.getChild(_) instanceof Generated::FullAggregateBody
  } or
  TExprAggregate(Generated::Aggregate agg) {
    agg.getChild(_) instanceof Generated::ExprAggregateBody
  } or
  TSuper(Generated::SuperRef sup) or
  TIdentifier(Generated::Variable var) or
  TAsExpr(Generated::AsExpr asExpr) { asExpr.getChild(1) instanceof Generated::VarName } or
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
  TInFormula(Generated::InExpr inexpr) or
  THigherOrderFormula(Generated::HigherOrderTerm hop) or
  TExprAnnotation(Generated::ExprAnnotation expr_anno) or
  TAddSubExpr(Generated::AddExpr addexp) or
  TMulDivModExpr(Generated::MulExpr mulexpr) or
  TRange(Generated::Range range) or
  TSet(Generated::SetLiteral set) or
  TLiteral(Generated::Literal lit) or
  TUnaryExpr(Generated::UnaryExpr unaryexpr) or
  TDontCare(Generated::Underscore dontcare) or
  TModuleExpr(Generated::ModuleExpr me) or
  TPredicateExpr(Generated::PredicateExpr pe) or
  TAnnotation(Generated::Annotation annot) or
  TAnnotationArg(Generated::AnnotArg arg) or
  TYamlCommemt(Generated::YamlComment yc) or
  TYamlEntry(Generated::YamlEntry ye) or
  TYamlKey(Generated::YamlKey yk) or
  TYamlListitem(Generated::YamlListitem yli) or
  TYamlValue(Generated::YamlValue yv) or
  TBuiltinClassless(string ret, string name, string args) { isBuiltinClassless(ret, name, args) } or
  TBuiltinMember(string qual, string ret, string name, string args) {
    isBuiltinMember(qual, ret, name, args)
  }

class TFormula =
  TDisjunction or TConjunction or TComparisonFormula or TQuantifier or TNegation or TIfFormula or
      TImplication or TInstanceOf or TCall or THigherOrderFormula or TInFormula;

class TBinOpExpr = TAddSubExpr or TMulDivModExpr;

class TAggregate = TFullAggregate or TExprAggregate;

class TExpr =
  TBinOpExpr or TLiteral or TAggregate or TIdentifier or TInlineCast or TCall or TUnaryExpr or
      TExprAnnotation or TDontCare or TRange or TSet or TAsExpr or TSuper;

class TCall = TPredicateCall or TMemberCall or TNoneCall or TAnyCall;

class TModuleRef = TImport or TModuleExpr;

class TYAMLNode = TYamlCommemt or TYamlEntry or TYamlKey or TYamlListitem or TYamlValue;

private Generated::AstNode toGeneratedFormula(AST::AstNode n) {
  n = TConjunction(result) or
  n = TDisjunction(result) or
  n = TComparisonFormula(result) or
  n = TComparisonOp(result) or
  n = TQuantifier(result) or
  n = TFullAggregate(result) or
  n = TIdentifier(result) or
  n = TNegation(result) or
  n = TIfFormula(result) or
  n = TImplication(result) or
  n = TInstanceOf(result) or
  n = THigherOrderFormula(result) or
  n = TInFormula(result)
}

private Generated::AstNode toGeneratedExpr(AST::AstNode n) {
  n = TAddSubExpr(result) or
  n = TMulDivModExpr(result) or
  n = TRange(result) or
  n = TSet(result) or
  n = TExprAnnotation(result) or
  n = TLiteral(result) or
  n = TFullAggregate(result) or
  n = TExprAggregate(result) or
  n = TIdentifier(result) or
  n = TUnaryExpr(result) or
  n = TDontCare(result)
}

private Generated::AstNode toGenerateYAML(AST::AstNode n) {
  n = TYamlCommemt(result) or
  n = TYamlEntry(result) or
  n = TYamlKey(result) or
  n = TYamlListitem(result) or
  n = TYamlValue(result)
}

/**
 * Gets the underlying TreeSitter entity for a given AST node.
 */
Generated::AstNode toGenerated(AST::AstNode n) {
  result = toGeneratedExpr(n)
  or
  result = toGeneratedFormula(n)
  or
  result = toGenerateYAML(n)
  or
  result.(Generated::ParExpr).getChild() = toGenerated(n)
  or
  result =
    any(Generated::AsExpr ae |
      not ae.getChild(1) instanceof Generated::VarName and
      toGenerated(n) = ae.getChild(0)
    )
  or
  n = TTopLevel(result)
  or
  n = TQLDoc(result)
  or
  n = TClasslessPredicate(result)
  or
  n = TVarDecl(result)
  or
  n = TClass(result)
  or
  n = TCharPred(result)
  or
  n = TClassPredicate(result)
  or
  n = TDBRelation(result)
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
  or
  n = TSuper(result)
  or
  n = TAnnotation(result)
  or
  n = TAnnotationArg(result)
}

class TPredicate = TCharPred or TClasslessPredicate or TClassPredicate or TDBRelation;

class TPredOrBuiltin = TPredicate or TNewTypeBranch or TBuiltinClassless or TBuiltinMember;

class TModuleMember = TModuleDeclaration or TImport or TSelect or TQLDoc;

class TDeclaration = TTypeDeclaration or TModuleDeclaration or TPredicate or TVarDecl;

class TTypeDeclaration = TClass or TNewType or TNewTypeBranch;

class TModuleDeclaration = TClasslessPredicate or TModule or TClass or TNewType;

class TVarDef = TVarDecl or TAsExpr;
