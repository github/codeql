import codeql_ql.ast.Ast as AST
import TreeSitter
private import Builtins
private import AstMocks as Mocks

cached
newtype TAstNode =
  TTopLevel(QL::Ql file) or
  TQLDoc(QL::Qldoc qldoc) or
  TBlockComment(QL::BlockComment comment) or
  TLineComment(QL::LineComment comment) or
  TClasslessPredicate(Mocks::ClasslessPredicateOrMock pred) or
  TVarDecl(Mocks::VarDeclOrMock decl) or
  TFieldDecl(QL::Field field) or
  TClass(Mocks::ClassOrMock cls) or
  TCharPred(QL::Charpred pred) or
  TClassPredicate(QL::MemberPredicate pred) or
  TDBRelation(Dbscheme::Table table) or
  TSelect(QL::Select sel) or
  TModule(Mocks::ModuleOrMock mod) or
  TNewType(QL::Datatype dt) or
  TNewTypeBranch(QL::DatatypeBranch branch) or
  TImport(QL::ImportDirective imp) or
  TType(Mocks::TypeExprOrMock type) or
  TDisjunction(QL::Disjunction disj) or
  TConjunction(QL::Conjunction conj) or
  TComparisonFormula(QL::CompTerm comp) or
  TQuantifier(QL::Quantified quant) or
  TFullAggregate(QL::Aggregate agg) { agg.getChild(_) instanceof QL::FullAggregateBody } or
  TExprAggregate(QL::Aggregate agg) { agg.getChild(_) instanceof QL::ExprAggregateBody } or
  TSuper(QL::SuperRef sup) or
  TIdentifier(QL::Variable var) or
  TAsExpr(QL::AsExpr asExpr) { asExpr.getChild(1) instanceof QL::VarName } or
  TPredicateCall(QL::CallOrUnqualAggExpr call) or
  TMemberCall(QL::QualifiedExpr expr) {
    not expr.getChild(_).(QL::QualifiedRhs).getChild(_) instanceof QL::TypeExpr
  } or
  TInlineCast(QL::QualifiedExpr expr) {
    expr.getChild(_).(QL::QualifiedRhs).getChild(_) instanceof QL::TypeExpr
  } or
  TNoneCall(QL::SpecialCall call) or
  TAnyCall(QL::Aggregate agg) {
    "any" = agg.getChild(0).(QL::AggId).getValue() and
    not agg.getChild(_) instanceof QL::FullAggregateBody
  } or
  TNegation(QL::Negation neg) or
  TIfFormula(QL::IfTerm ifterm) or
  TImplication(QL::Implication impl) or
  TInstanceOf(QL::InstanceOf inst) or
  TInFormula(QL::InExpr inexpr) or
  THigherOrderFormula(QL::HigherOrderTerm hop) or
  TExprAnnotation(QL::ExprAnnotation expr_anno) or
  TAddSubExpr(QL::AddExpr addexp) or
  TMulDivModExpr(QL::MulExpr mulexpr) or
  TRange(QL::Range range) or
  TSet(QL::SetLiteral set) or
  TLiteral(QL::Literal lit) or
  TUnaryExpr(QL::UnaryExpr unaryexpr) or
  TDontCare(QL::Underscore dontcare) or
  TModuleExpr(QL::ModuleExpr me) or
  TPredicateExpr(QL::PredicateExpr pe) or
  TAnnotation(QL::Annotation annot) or
  TAnnotationArg(QL::AnnotArg arg) or
  TYamlComment(Yaml::Comment yc) or
  TYamlEntry(Yaml::Entry ye) or
  TYamlKey(Yaml::Key yk) or
  TYamlListitem(Yaml::Listitem yli) or
  TYamlValue(Yaml::Value yv) or
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

class TTypeRef = TImport or TModuleExpr or TType;

class TYamlNode = TYamlComment or TYamlEntry or TYamlKey or TYamlListitem or TYamlValue;

class TSignatureExpr = TPredicateExpr or TType or TModuleExpr;

class TComment = TQLDoc or TBlockComment or TLineComment;

/** DEPRECATED: Alias for TYamlNode */
deprecated class TYAMLNode = TYamlNode;

private QL::AstNode toQLFormula(AST::AstNode n) {
  n = TConjunction(result) or
  n = TDisjunction(result) or
  n = TComparisonFormula(result) or
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

private QL::AstNode toQLExpr(AST::AstNode n) {
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

Yaml::AstNode toGenerateYaml(AST::AstNode n) {
  n = TYamlComment(result) or
  n = TYamlEntry(result) or
  n = TYamlKey(result) or
  n = TYamlListitem(result) or
  n = TYamlValue(result)
}

Dbscheme::AstNode toDbscheme(AST::AstNode n) { n = TDBRelation(result) }

/**
 * Gets the underlying TreeSitter entity for a given AST node.
 */
cached
QL::AstNode toQL(AST::AstNode n) {
  result = toQLExpr(n)
  or
  result = toQLFormula(n)
  or
  result.(QL::ParExpr).getChild() = toQL(n)
  or
  result =
    any(QL::AsExpr ae |
      not ae.getChild(1) instanceof QL::VarName and
      toQL(n) = ae.getChild(0)
    )
  or
  n = TTopLevel(result)
  or
  n = TQLDoc(result)
  or
  n = TBlockComment(result)
  or
  n = TLineComment(result)
  or
  n = TClasslessPredicate(any(Mocks::ClasslessPredicateOrMock m | m.asLeft() = result))
  or
  n = TVarDecl(any(Mocks::VarDeclOrMock m | m.asLeft() = result))
  or
  n = TFieldDecl(result)
  or
  n = TClass(any(Mocks::ClassOrMock m | m.asLeft() = result))
  or
  n = TCharPred(result)
  or
  n = TClassPredicate(result)
  or
  n = TSelect(result)
  or
  n = TModule(any(Mocks::ModuleOrMock m | m.asLeft() = result))
  or
  n = TNewType(result)
  or
  n = TNewTypeBranch(result)
  or
  n = TImport(result)
  or
  n = TType(any(Mocks::TypeExprOrMock m | m.asLeft() = result))
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

Mocks::MockAst toMock(AST::AstNode n) {
  n = TModule(any(Mocks::ModuleOrMock m | m.asRight() = result))
  or
  n = TClass(any(Mocks::ClassOrMock m | m.asRight() = result))
  or
  n = TType(any(Mocks::TypeExprOrMock m | m.asRight() = result))
  or
  n = TClasslessPredicate(any(Mocks::ClasslessPredicateOrMock m | m.asRight() = result))
  or
  n = TVarDecl(any(Mocks::VarDeclOrMock m | m.asRight() = result))
}

class TPredicate =
  TCharPred or TClasslessPredicate or TClassPredicate or TDBRelation or TNewTypeBranch;

class TPredOrBuiltin = TPredicate or TBuiltin;

class TBuiltin = TBuiltinClassless or TBuiltinMember;

class TModuleMember = TModuleDeclaration or TImport or TSelect or TQLDoc;

class TDeclaration = TTypeDeclaration or TModuleDeclaration or TPredicate or TVarDecl;

class TTypeDeclaration = TClass or TNewType or TNewTypeBranch;

class TModuleDeclaration = TClasslessPredicate or TModule or TClass or TNewType;

class TVarDef = TVarDecl or TAsExpr;

module AstConsistency {
  import ql
  import codeql_ql.ast.internal.AstNodes as AstNodes

  query predicate nonTotalGetParent(AstNode node) {
    exists(toQL(node).getParent()) and
    not exists(node.getParent()) and
    not node.getLocation().getStartColumn() = 1 and // startcolumn = 1 <=> top level in file <=> fine to have no parent
    exists(node.toString()) and // <- there are a few parse errors in "global-data-flow-java-1.ql", this way we filter them out.
    not (node instanceof QLDoc and node.getLocation().getFile().getExtension() = "dbscheme") // qldoc in dbschemes are not hooked up
  }

  query predicate nonUniqueParent(AstNode node) { count(node.getParent()) >= 2 }
}
