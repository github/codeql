import ql
private import codeql_ql.ast.internal.AstNodes
private import codeql_ql.ast.internal.Module

/** An AST node of a QL program */
class AstNode extends TAstNode {
  string toString() { result = getAPrimaryQlClass() }

  Location getLocation() {
    exists(Generated::AstNode node | not node instanceof Generated::ParExpr |
      node = toGenerated(this) and
      result = node.getLocation()
    )
  }

  AstNode getParent() {
    toGenerated(result) = toGenerated(this).getParent() and
    not result = this
  }

  string getAPrimaryQlClass() { result = "???" }
}

/**
 * The `from, where, select` part of a QL query.
 */
class Select extends TSelect, AstNode {
  Generated::Select sel;

  Select() { this = TSelect(sel) }

  override string getAPrimaryQlClass() { result = "Select" }
  // TODO: Getters for VarDecls, Where-clause, selects.
}

/**
 * A QL predicate.
 */
class Predicate extends TPredicate, AstNode {
  /**
   * Gets the body of the predicate.
   */
  Formula getBody() { none() }

  /**
   * Gets the name of the predicate.
   */
  string getName() { none() }

  /**
   * Gets the `i`th parameter of the predicate.
   */
  VarDecl getParameter(int i) { none() }
  // TODO: ReturnType.
}

class PredicateExpr extends TPredicateExpr, AstNode {
  Generated::PredicateExpr pe;

  PredicateExpr() { this = TPredicateExpr(pe) }

  override string toString() { result = "predicate" }

  ModuleExpr getQualifier() {
    exists(Generated::AritylessPredicateExpr ape |
      ape.getParent() = pe and
      toGenerated(result).getParent() = ape
    )
  }
}

/**
 * A classless predicate.
 */
class ClasslessPredicate extends TClasslessPredicate, Predicate, ModuleMember {
  Generated::ModuleMember member;
  Generated::ClasslessPredicate pred;

  ClasslessPredicate() { this = TClasslessPredicate(member, pred) }

  final PredicateExpr getAlias() {
    exists(Generated::PredicateAliasBody alias |
      alias.getParent() = pred and
      toGenerated(result).getParent() = alias
    )
  }

  final override predicate isPrivate() {
    member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
  }

  override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

  override Formula getBody() { toGenerated(result) = pred.getChild(_).(Generated::Body).getChild() }

  override string getName() { result = pred.getName().getValue() }

  override VarDecl getParameter(int i) {
    toGenerated(result) =
      rank[i](Generated::VarDecl decl, int index | decl = pred.getChild(index) | decl order by index)
  }
}

/**
 * A predicate in a class.
 */
class ClassPredicate extends TClassPredicate, Predicate {
  Generated::MemberPredicate pred;

  ClassPredicate() { this = TClassPredicate(pred) }

  override string getName() { result = pred.getName().getValue() }

  override Formula getBody() { toGenerated(result) = pred.getChild(_).(Generated::Body).getChild() }

  override string getAPrimaryQlClass() { result = "ClassPredicate" }

  override Class getParent() { result.getAClassPredicate() = this }

  override VarDecl getParameter(int i) {
    toGenerated(result) =
      rank[i](Generated::VarDecl decl, int index | decl = pred.getChild(index) | decl order by index)
  }
}

/**
 * A characteristic predicate of a class.
 */
class CharPred extends TCharPred, Predicate {
  Generated::Charpred pred;

  CharPred() { this = TCharPred(pred) }

  override string getAPrimaryQlClass() { result = "CharPred" }

  override Formula getBody() { toGenerated(result) = pred.getBody() }

  override string getName() { result = getParent().getName() }

  override Class getParent() { result.getCharPred() = this }
}

/**
 * A variable declaration, with a type and a name.
 */
class VarDecl extends TVarDecl, AstNode {
  Generated::VarDecl var;

  VarDecl() { this = TVarDecl(var) }

  /**
   * Gets the name for this variable declaration.
   */
  string getName() { result = var.getChild(1).(Generated::VarName).getChild().getValue() }

  override string getAPrimaryQlClass() { result = "VarDecl" }

  override AstNode getParent() {
    result = super.getParent()
    or
    result.(Class).getAField() = this
    or
    result.(Aggregate).getAnArgument() = this
    or
    result.(Quantifier).getAnArgument() = this
  }

  Type getType() { toGenerated(result) = var.getChild(0) }
}

/**
 * A type, such as `DataFlow::Node`.
 */
class Type extends TType, AstNode {
  Generated::TypeExpr type;

  Type() { this = TType(type) }

  override string getAPrimaryQlClass() { result = "Type" }

  /**
   * Gets the class name for the type.
   * E.g. `Node` in `DataFlow::Node`.
   * Also gets the name for primitive types such as `string` or `int`
   * or db-types such as `@locateable`.
   */
  string getClassName() {
    result = type.getName().getValue()
    or
    result = type.getChild().(Generated::PrimitiveType).getValue()
    or
    result = type.getChild().(Generated::Dbtype).getValue()
  }

  /**
   * Holds if this type is a primitive such as `string` or `int`.
   */
  predicate isPrimitive() { type.getChild() instanceof Generated::PrimitiveType }

  /**
   * Holds if this type is a db-type.
   */
  predicate isDBType() { type.getChild() instanceof Generated::Dbtype }

  /**
   * Gets the module of the type, if it exists.
   * E.g. `DataFlow` in `DataFlow::Node`.
   */
  ModuleExpr getModule() { toGenerated(result) = type.getChild() }

  override AstNode getParent() {
    result = super.getParent()
    or
    result.(InlineCast).getType() = this
    or
    result.(Class).getAliasType() = this
  }
}

/**
 * A QL module.
 */
class Module extends TModule, AstNode, ModuleMember {
  Generated::Module mod;

  Module() { this = TModule(mod) }

  override string getAPrimaryQlClass() { result = "Module" }

  final override predicate isPrivate() {
    exists(Generated::ModuleMember member |
      mod = member.getChild(_) and
      member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
    )
  }

  /**
   * Gets the name of the module.
   */
  string getName() { result = mod.getName().(Generated::ModuleName).getChild().getValue() }

  /**
   * Gets a member of the module.
   */
  AstNode getAMember() {
    toGenerated(result) = mod.getChild(_).(Generated::ModuleMember).getChild(_)
  }

  /** Gets the module expression that this module is an alias for, if any. */
  ModuleExpr getAlias() {
    toGenerated(result) = mod.getAFieldOrChild().(Generated::ModuleAliasBody).getChild()
  }
}

/**
 * Something that can be member of a module.
 */
class ModuleMember extends TModuleMember, AstNode {
  override AstNode getParent() { result.(Module).getAMember() = this }

  /** Holds if this member is declared as `private`. */
  predicate isPrivate() { none() } // TODO: Implement.
}

/**
 * A QL class.
 */
class Class extends TClass, AstNode, ModuleMember {
  Generated::Dataclass cls;

  Class() { this = TClass(cls) }

  override string getAPrimaryQlClass() { result = "Class" }

  final override predicate isPrivate() {
    exists(Generated::ModuleMember member |
      cls = member.getChild(_) and
      member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
    )
  }

  /**
   * Gets the name of the class.
   */
  string getName() { result = cls.getName().getValue() }

  /**
   * Gets the charateristic predicate for this class.
   */
  CharPred getCharPred() {
    toGenerated(result) = cls.getChild(_).(Generated::ClassMember).getChild(_)
  }

  /**
   * Gets a predicate in this class.
   */
  ClassPredicate getAClassPredicate() {
    toGenerated(result) = cls.getChild(_).(Generated::ClassMember).getChild(_)
  }

  /**
   * Gets predicate `name` implemented in this class.
   */
  ClassPredicate getClassPredicate(string name) {
    result = getAClassPredicate() and
    result.getName() = name
  }

  /**
   * Gets a field in this class.
   */
  VarDecl getAField() {
    toGenerated(result) =
      cls.getChild(_).(Generated::ClassMember).getChild(_).(Generated::Field).getChild()
  }

  /**
   * Gets a super-type for this class.
   * That is: a type after the `extends` keyword.
   */
  Type getASuperType() { toGenerated(result) = cls.getChild(_) }

  /** Gets the type that this class is defined to be an alias of. */
  Type getAliasType() {
    toGenerated(result) = cls.getChild(_).(Generated::TypeAliasBody).getChild()
  }
}

/**
 * A `newtype Foo` declaration.
 */
class NewType extends TNewType, ModuleMember {
  Generated::Datatype type;

  NewType() { this = TNewType(type) }

  string getName() { result = type.getName().getValue() }

  override string getAPrimaryQlClass() { result = "NewType" }

  final override predicate isPrivate() {
    exists(Generated::ModuleMember member |
      type = member.getChild(_) and
      member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
    )
  }

  /**
   * Gets a branch in this `newtype`.
   */
  NewTypeBranch getABranch() { toGenerated(result) = type.getChild().getChild(_) }
}

/**
 * A branch in a `newtype`.
 */
class NewTypeBranch extends TNewTypeBranch, AstNode {
  Generated::DatatypeBranch branch;

  NewTypeBranch() { this = TNewTypeBranch(branch) }

  override string getAPrimaryQlClass() { result = "NewTypeBranch" }

  /** Gets the name of this branch. */
  string getName() { result = branch.getName().getValue() }

  /** Gets a field in this branch. */
  VarDecl getField(int i) {
    toGenerated(result) =
      rank[i](Generated::VarDecl var | var = branch.getChild(i) | var order by i)
  }

  /** Gets the body of this branch. */
  Formula getBody() { toGenerated(result) = branch.getChild(_).(Generated::Body).getChild() }

  override NewType getParent() { result.getABranch() = this }
}

class Call extends TCall, AstNode {
  Expr getArgument(int i) {
    none() // overriden in sublcasses.
  }

  ModuleExpr getQualifier() { none() }
}

class PredicateCall extends TPredicateCall, Call {
  Generated::CallOrUnqualAggExpr expr;

  PredicateCall() { this = TPredicateCall(expr) }

  override Expr getArgument(int i) {
    exists(Generated::CallBody body | body.getParent() = expr |
      toGenerated(result) = body.getChild(i)
    )
  }

  final override ModuleExpr getQualifier() {
    exists(Generated::AritylessPredicateExpr ape |
      ape.getParent() = expr and
      toGenerated(result).getParent() = ape
    )
  }

  override string getAPrimaryQlClass() { result = "PredicateCall" }

  string getPredicateName() {
    result = expr.getChild(0).(Generated::AritylessPredicateExpr).getName().getValue()
  }
}

class MemberCall extends TMemberCall, Call {
  Generated::QualifiedExpr expr;

  MemberCall() { this = TMemberCall(expr) }

  override string getAPrimaryQlClass() { result = "MemberCall" }

  string getMemberName() {
    result = expr.getChild(_).(Generated::QualifiedRhs).getName().getValue()
  }

  override Expr getArgument(int i) {
    result =
      rank[i + 1](Expr e, int index |
        toGenerated(e) = expr.getChild(_).(Generated::QualifiedRhs).getChild(index)
      |
        e order by index
      )
  }

  Expr getBase() { toGenerated(result) = expr.getChild(0) }
}

class NoneCall extends TNoneCall, Call, Formula {
  Generated::SpecialCall call;

  NoneCall() { this = TNoneCall(call) }

  override string getAPrimaryQlClass() { result = "NoneCall" }
}

class AnyCall extends TAnyCall, Call {
  Generated::Aggregate agg;

  AnyCall() { this = TAnyCall(agg) }

  override string getAPrimaryQlClass() { result = "AnyCall" }
}

class InlineCast extends TInlineCast, Expr {
  Generated::QualifiedExpr expr;

  InlineCast() { this = TInlineCast(expr) }

  override string getAPrimaryQlClass() { result = "InlineCast" }

  Type getType() { toGenerated(result) = expr.getChild(_).(Generated::QualifiedRhs).getChild(_) }

  Expr getBase() { toGenerated(result) = expr.getChild(0) }
}

/** An entity that resolves to a module. */
class ModuleRef extends AstNode, TModuleRef {
  /** Gets the module that this entity resolves to. */
  FileOrModule getResolvedModule() { none() }
}

/**
 * An import statement.
 */
class Import extends TImport, ModuleMember, ModuleRef {
  Generated::ImportDirective imp;

  Import() { this = TImport(imp) }

  override string getAPrimaryQlClass() { result = "Import" }

  /**
   * Gets the name under which this import is imported, if such a name exists.
   * E.g. the `Flow` in:
   * ```
   * import semmle.javascript.dataflow.Configuration as Flow
   * ```
   */
  string importedAs() { result = imp.getChild(1).(Generated::ModuleName).getChild().getValue() }

  /**
   * Gets the `i`th selected name from the imported module.
   * E.g. for
   * `import foo.bar::Baz::Qux`
   * It is true that `getSelectionName(0) = "Baz"` and `getSelectionName(1) = "Qux"`.
   */
  string getSelectionName(int i) {
    result = imp.getChild(0).(Generated::ImportModuleExpr).getName(i).getValue()
  }

  /**
   * Gets the `i`th imported module.
   * E.g. for
   * `import foo.bar::Baz::Qux`
   * It is true that `getQualifiedName(0) = "foo"` and `getQualifiedName(1) = "bar"`.
   */
  string getQualifiedName(int i) {
    result = imp.getChild(0).(Generated::ImportModuleExpr).getChild().getName(i).getValue()
  }

  final override predicate isPrivate() {
    exists(Generated::ModuleMember member |
      imp = member.getChild(_) and
      member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
    )
  }

  final override FileOrModule getResolvedModule() { resolve(this, result) }
}

/** A formula, such as `x = 6 and y < 5`. */
class Formula extends TFormula, AstNode {
  override AstNode getParent() {
    result = super.getParent()
    or
    result.(Predicate).getBody() = this
    or
    result.(Aggregate).getRange() = this
    or
    result.(NewTypeBranch).getBody() = this
  }
}

/** An `and` formula, with 2 or more operands. */
class Conjunction extends TConjunction, AstNode, Formula {
  Generated::Conjunction conj;

  Conjunction() { this = TConjunction(conj) }

  override string getAPrimaryQlClass() { result = "Conjunction" }

  /** Gets an operand to this formula. */
  Formula getAnOperand() { toGenerated(result) in [conj.getLeft(), conj.getRight()] }
}

/** An `or` formula, with 2 or more operands. */
class Disjunction extends TDisjunction, AstNode {
  Generated::Disjunction disj;

  Disjunction() { this = TDisjunction(disj) }

  override string getAPrimaryQlClass() { result = "Disjunction" }

  /** Gets an operand to this formula. */
  Formula getAnOperand() { toGenerated(result) in [disj.getLeft(), disj.getRight()] }
}

/**
 * A comparison operator, such as `<` or `=`.
 */
class ComparisonOp extends TComparisonOp, AstNode {
  Generated::Compop op;

  ComparisonOp() { this = TComparisonOp(op) }

  ComparisonSymbol getSymbol() { result = op.getValue() }

  override string getAPrimaryQlClass() { result = "ComparisonOp" }
}

/**
 * A literal expression, such as `6` or `true` or `"foo"`.
 */
class Literal extends TLiteral, Expr {
  Generated::Literal lit;

  Literal() { this = TLiteral(lit) }

  override string getAPrimaryQlClass() { result = "??Literal??" }
}

/** A string literal. */
class String extends Literal {
  String() { lit.getChild() instanceof Generated::String }

  override string getAPrimaryQlClass() { result = "String" }

  /** Gets the string value of this literal. */
  string getValue() { result = lit.getChild().(Generated::String).getValue() }
}

/** An integer literal. */
class Integer extends Literal {
  Integer() { lit.getChild() instanceof Generated::Integer }

  override string getAPrimaryQlClass() { result = "Integer" }

  /** Gets the integer value of this literal. */
  int getValue() { result = lit.getChild().(Generated::Integer).getValue().toInt() }
}

/** A comparison symbol, such as `"<"` or `"="`. */
class ComparisonSymbol extends string {
  ComparisonSymbol() {
    this = "=" or
    this = "!=" or
    this = "<" or
    this = ">" or
    this = "<=" or
    this = ">="
  }
}

/** A comparison formula, such as `x < 3` or `y = true`. */
class ComparisonFormula extends TComparisonFormula, Formula {
  Generated::CompTerm comp;

  ComparisonFormula() { this = TComparisonFormula(comp) }

  /** Gets the left operand of this comparison. */
  Expr getLeftOperand() { toGenerated(result) = comp.getLeft() }

  /** Gets the right operand of this comparison. */
  Expr getRightOperand() { toGenerated(result) = comp.getRight() }

  /** Gets an operand of this comparison. */
  Expr getAnOperand() { result in [getLeftOperand(), getRightOperand()] }

  /** Gets the operator of this comparison. */
  ComparisonOp getOperator() { toGenerated(result) = comp.getChild() }

  /** Gets the symbol of this comparison (as a string). */
  ComparisonSymbol getSymbol() { result = this.getOperator().getSymbol() }

  override string getAPrimaryQlClass() { result = "ComparisonFormula" }
}

/** A quantifier formula, such as `exists` or `forall`. */
class Quantifier extends TQuantifier, Formula {
  Generated::Quantified quant;
  string kind;

  Quantifier() {
    this = TQuantifier(quant) and kind = quant.getChild(0).(Generated::Quantifier).getValue()
  }

  /** Gets the ith variable declaration of this quantifier. */
  VarDecl getArgument(int i) {
    i >= 1 and
    toGenerated(result) = quant.getChild(i - 1)
  }

  /** Gets an argument of this quantifier. */
  VarDecl getAnArgument() { result = this.getArgument(_) }

  /** Gets the formula restricting the range of this quantifier, if any. */
  Formula getRange() { toGenerated(result) = quant.getRange() }

  /** Holds if this quantifier has a range formula. */
  predicate hasRange() { exists(this.getRange()) }

  /** Gets the main body of the quantifier. */
  Formula getFormula() { toGenerated(result) = quant.getFormula() }

  /**
   * Gets the expression of this quantifier, if the quantifier is
   * of the form `exists( expr )`.
   */
  Expr getExpr() { toGenerated(result) = quant.getExpr() }

  /**
   * Holds if this is the "expression only" form of an exists quantifier.
   * In other words, the quantifier is of the form `exists( expr )`.
   */
  predicate hasExpr() { exists(getExpr()) }

  override string getAPrimaryQlClass() { result = "Quantifier" }
}

/** An `exists` quantifier. */
class Exists extends Quantifier {
  Exists() { kind = "exists" }

  override string getAPrimaryQlClass() { result = "Exists" }
}

/** A `forall` quantifier. */
class Forall extends Quantifier {
  Forall() { kind = "forall" }

  override string getAPrimaryQlClass() { result = "Forall" }
}

/** A `forex` quantifier. */
class Forex extends Quantifier {
  Forex() { kind = "forex" }

  override string getAPrimaryQlClass() { result = "Forex" }
}

class IfFormula extends TIfFormula, Formula {
  Generated::IfTerm ifterm;

  IfFormula() { this = TIfFormula(ifterm) }

  /** Gets the condition of this if formula. */
  Formula getCondition() { toGenerated(result) = ifterm.getCond() }

  /** Gets the then part of this if formula. */
  Formula getThenPart() { toGenerated(result) = ifterm.getFirst() }

  /** Gets the else part of this if formula. */
  Formula getElsePart() { toGenerated(result) = ifterm.getSecond() }

  override string getAPrimaryQlClass() { result = "IfFormula" }
}

class Implication extends TImplication, Formula {
  Generated::Implication imp;

  Implication() { this = TImplication(imp) }

  /** Gets the left operand of this implication. */
  Formula getLeftOperand() { toGenerated(result) = imp.getLeft() }

  /** Gets the right operand of this implication. */
  Formula getRightOperand() { toGenerated(result) = imp.getRight() }

  override string getAPrimaryQlClass() { result = "Implication" }
}

class InstanceOf extends TInstanceOf, Formula {
  Generated::InstanceOf inst;

  InstanceOf() { this = TInstanceOf(inst) }

  /** Gets the expression being checked. */
  Expr getExpr() { toGenerated(result) = inst.getChild(0) }

  /** Gets the reference to the type being checked. */
  Type getType() { toGenerated(result) = inst.getChild(1) }

  /** Gets the type being checked. */
  //QLType getType() { result = getTypeRef().getType() }
  override string getAPrimaryQlClass() { result = "InstanceOf" }
}

/** An aggregate expression, such as `count` or `sum`. */
class Aggregate extends TAggregate, Expr {
  Generated::Aggregate agg;
  Generated::FullAggregateBody body;
  string kind;

  Aggregate() {
    this = TAggregate(agg) and
    kind = agg.getChild(0).(Generated::AggId).getValue() and
    body = agg.getChild(_)
  }

  string getKind() { result = kind }

  /** Gets the ith declared argument of this quantifier. */
  VarDecl getArgument(int i) { toGenerated(result) = body.getChild(i) }

  /** Gets an argument of this quantifier. */
  VarDecl getAnArgument() { result = this.getArgument(_) }

  /**
   * Gets the formula restricting the range of this quantifier, if any.
   */
  Formula getRange() { toGenerated(result) = body.getGuard() }

  /**
   * Gets the ith "as" expression of this aggregate, if any.
   */
  AsExpr getAsExpr(int i) { toGenerated(result) = body.getAsExprs().getChild(i) }

  /**
   * Gets the ith "order by" expression of this aggregate, if any.
   */
  Expr getOrderBy(int i) { toGenerated(result) = body.getOrderBys().getChild(i).getChild(0) }

  /**
   * Gets the direction (ascending or descending) of the ith "order by" expression of this aggregate.
   */
  string getOrderbyDirection(int i) {
    result = body.getOrderBys().getChild(i).getChild(1).(Generated::Direction).getValue()
  }

  override string getAPrimaryQlClass() { result = "Aggregate[" + kind + "]" }
}

/**
 * A "rank" expression, such as `rank[4](int i | i = [5 .. 15] | i)`.
 */
class Rank extends Aggregate {
  Rank() { kind = "rank" }

  override string getAPrimaryQlClass() { result = "Rank" }

  /**
   * The `i` in `rank[i]( | | )`.
   */
  Expr getRankExpr() { toGenerated(result) = agg.getChild(1) }
}

// TODO: Range and Set.
/**
 * An "as" expression, such as `foo as bar`.
 */
class AsExpr extends TAsExpr, AstNode {
  Generated::AsExpr asExpr;

  AsExpr() { this = TAsExpr(asExpr) }

  override string getAPrimaryQlClass() { result = "AsExpr" }

  /**
   * Gets the name the inner expression gets "saved" under, if it exists.
   * For example this is `bar` in the expression `foo as bar`.
   */
  string getAsName() { result = asExpr.getChild(1).(Generated::VarName).getChild().getValue() }

  /**
   * Gets the inner expression of the "as" expression. For example, this is `foo` in
   * the expression `foo as bar`.
   */
  Expr getInnerExpr() { toGenerated(result) = asExpr.getChild(0) }

  override AstNode getParent() {
    result = super.getParent()
    or
    result.(Aggregate).getAsExpr(_) = this
  }
}

class Identifier extends TIdentifier, Expr {
  Generated::Variable id;

  Identifier() { this = TIdentifier(id) }

  string getName() { result = id.getChild().(Generated::VarName).getChild().getValue() }

  override string getAPrimaryQlClass() { result = "Identifier" }
}

/** A `not` formula. */
class Negation extends TNegation, Formula {
  Generated::Negation neg;

  Negation() { this = TNegation(neg) }

  /** Gets the formula being negated. */
  Formula getFormula() { toGenerated(result) = neg.getChild() }

  override string getAPrimaryQlClass() { result = "Negation" }
}

/** An expression, such as `x+4`. */
class Expr extends TExpr, AstNode {
  override AstNode getParent() {
    result = super.getParent()
    or
    result.(Call).getArgument(_) = this
    or
    result.(Aggregate).getOrderBy(_) = this
  }
}

class ExprAnnotation extends TExprAnnotation, Expr {
  Generated::ExprAnnotation expr_anno;

  ExprAnnotation() { this = TExprAnnotation(expr_anno) }

  string getName() { result = expr_anno.getName().getValue() }

  string getAnnotationArgument() { result = expr_anno.getAnnotArg().getValue() }

  Expr getExpression() { toGenerated(result) = expr_anno.getChild() }

  override string getAPrimaryQlClass() { result = "ExprAnnotation" }
}

/** A function symbol, such as `+` or `*`. */
class FunctionSymbol extends string {
  FunctionSymbol() { this = "+" or this = "-" or this = "*" or this = "/" or this = "%" }
}

/** A binary operation expression, such as `x+3` or `y/2` */
class BinOpExpr extends TBinOpExpr, Expr { }

class AddExpr extends TAddExpr, BinOpExpr {
  Generated::AddExpr addexpr;

  AddExpr() { this = TAddExpr(addexpr) }

  Expr getLeftOperand() { toGenerated(result) = addexpr.getLeft() }

  Expr getRightOperand() { toGenerated(result) = addexpr.getRight() }

  Expr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }

  FunctionSymbol getOperator() { result = addexpr.getChild().getValue() }
}

/** A unary operation expression, such as `-(x*y)` */
class UnaryExpr extends TUnaryExpr, Expr {
  Generated::UnaryExpr unaryexpr;

  UnaryExpr() { this = TUnaryExpr(unaryexpr) }

  /** Gets the operand of the unary expression. */
  Expr getOperand() { toGenerated(result) = unaryexpr.getChild(1) }

  /** Gets the operator of the unary expression as a string. */
  FunctionSymbol getOperator() { result = unaryexpr.getChild(0).toString() }
}

/** A "don't care" expression, denoted by `_`. */
class DontCare extends TDontCare, Expr {
  Generated::Underscore dontcare;

  DontCare() { this = TDontCare(dontcare) }

  override string getAPrimaryQlClass() { result = "DontCare" }
}

/** A module expression. */
class ModuleExpr extends TModuleExpr, ModuleRef {
  Generated::ModuleExpr me;

  ModuleExpr() { this = TModuleExpr(me) }

  /**
   * Gets the name of this module expression. For example, the name of
   *
   * ```ql
   * Foo::Bar
   * ```
   *
   * is `Bar`.
   */
  string getName() {
    result = me.getName().getValue()
    or
    not exists(me.getName()) and result = me.getChild().(Generated::SimpleId).getValue()
  }

  /**
   * Gets the qualifier of this module expression. For example, the qualifier of
   *
   * ```ql
   * Foo::Bar::Baz
   * ```
   *
   * is `Foo::Bar`.
   */
  ModuleExpr getQualifier() { result = TModuleExpr(me.getChild()) }

  final override FileOrModule getResolvedModule() { resolveModuleExpr(this, result) }

  final override string toString() { result = this.getName() }
}
