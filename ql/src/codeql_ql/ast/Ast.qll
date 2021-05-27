import ql
private import codeql_ql.ast.internal.AstNodes

/** An AST node of a QL program */
class AstNode extends TAstNode {
  string toString() { result = getAPrimaryQlClass() }

  Location getLocation() { result = toGenerated(this).getLocation() }

  AstNode getParent() { toGenerated(result) = toGenerated(this).getParent() }

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

class Predicate extends TPredicate, AstNode {
  /**
   * Gets the body of the predicate.
   */
  Formula getBody() { none() }

  /**
   * Gets the name of the predicate
   */
  string getName() { none() }

  /**
   * Gets the `i`th parameter of the predicate.
   */
  VarDecl getParameter(int i) { none() }
  // TODO: ReturnType.
}

/**
 * A classless predicate.
 */
class ClasslessPredicate extends TClasslessPredicate, Predicate, ModuleMember {
  Generated::ModuleMember member;
  Generated::ClasslessPredicate pred;

  ClasslessPredicate() { this = TClasslessPredicate(member, pred) }

  predicate isPrivate() {
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
   * Gets the module name of the type, if it exists.
   * E.g. `DataFlow` in `DataFlow::Node`.
   */
  string getModuleName() { result = type.getChild().(Generated::ModuleExpr).getName().getValue() }
}

/**
 * A QL module.
 */
class Module extends TModule, AstNode, ModuleMember {
  Generated::Module mod;

  Module() { this = TModule(mod) }

  override string getAPrimaryQlClass() { result = "Module" }

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
}

/**
 * Something that can be member of a module.
 */
class ModuleMember extends TModuleMember, AstNode {
  override AstNode getParent() { result.(Module).getAMember() = this }
}

/**
 * A QL class.
 */
class Class extends TClass, AstNode, ModuleMember {
  Generated::Dataclass cls;

  Class() { this = TClass(cls) }

  override string getAPrimaryQlClass() { result = "Class" }

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
}

/**
 * A `newtype Foo` declaration.
 */
class NewType extends TNewType, ModuleMember {
  Generated::Datatype type;

  NewType() { this = TNewType(type) }

  string getName() { result = type.getName().getValue() }

  override string getAPrimaryQlClass() { result = "DataType" }

  NewTypeBranch getABranch() { toGenerated(result) = type.getChild().getChild(_) }
}

/**
 * A branch in a `newtype`.
 */
class NewTypeBranch extends TNewTypeBranch, AstNode {
  Generated::DatatypeBranch branch;

  NewTypeBranch() { this = TNewTypeBranch(branch) }

  override string getAPrimaryQlClass() { result = "NewTypeBranch" }

  string getName() { result = branch.getName().getValue() }

  VarDecl getField(int i) {
    toGenerated(result) =
      rank[i](Generated::VarDecl var | var = branch.getChild(i) | var order by i)
  }

  Formula getBody() { toGenerated(result) = branch.getChild(_).(Generated::Body).getChild() }
}

/**
 * An import statement.
 */
class Import extends TImport, ModuleMember {
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
  // TODO: private modifier.
}

/** A formula, such as `x = 6 and y < 5`. */
class Formula extends TFormula, AstNode {
  override AstNode getParent() {
    result = super.getParent()
    or
    result.(Predicate).getBody() = this
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

class ComparisonOp extends TComparisonOp, AstNode {
  Generated::Compop op;

  ComparisonOp() { this = TComparisonOp(op) }

  ComparisonSymbol getSymbol() { result = op.getValue() }

  override string getAPrimaryQlClass() { result = "ComparisonOp" }
}

class Literal extends TLiteral, Expr {
  Generated::Literal lit;

  Literal() { this = TLiteral(lit) }

  override string getAPrimaryQlClass() { result = "??Literal??" }
}

class String extends Literal {
  String() { lit.getChild() instanceof Generated::String }

  override string getAPrimaryQlClass() { result = "String" }

  string getValue() { result = lit.getChild().(Generated::String).getValue() }
}

class Integer extends Literal {
  Integer() { lit.getChild() instanceof Generated::Integer }

  override string getAPrimaryQlClass() { result = "Integer" }

  int getValue() { result = lit.getChild().(Generated::Integer).getValue().toInt() }
}

/** A comparison symbol, such as `<` or `=`. */
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

class ComparisonFormula extends TComparisonFormula, Formula {
  Generated::CompTerm comp;

  ComparisonFormula() { this = TComparisonFormula(comp) }

  Expr getLeftOperand() { toGenerated(result) = comp.getLeft() }

  Expr getRightOperand() { toGenerated(result) = comp.getRight() }

  Expr getAnOperand() { result in [getLeftOperand(), getRightOperand()] }

  ComparisonOp getOperator() { toGenerated(result) = comp.getChild() }

  ComparisonSymbol getSymbol() { result = this.getOperator().getSymbol() }

  override string getAPrimaryQlClass() { result = "ComparisonFormula" }
}

class Quantifier extends TQuantifier, Formula {
  Generated::Quantified quant;
  string kind;

  Quantifier() {
    this = TQuantifier(quant) and kind = quant.getChild(0).(Generated::Quantifier).getValue()
  }

  /** Gets the ith declared argument of this quantifier. */
  VarDecl getArgument(int i) {
    i >= 1 and
    toGenerated(result) = quant.getChild(i - 1) and
    exists()
  }

  /** Gets an argument of this quantifier. */
  VarDecl getAnArgument() { result = this.getArgument(_) }

  /** Gets the formula restricting the range of this quantifier, if any. */
  Formula getRange() { toGenerated(result) = quant.getRange() }

  /** Holds if this quantifier has a range formula. */
  predicate hasRange() { exists(this.getRange()) }

  /** Gets the main body of the quantifier. */
  Formula getFormula() { toGenerated(result) = quant.getFormula() }

  /** Gets the expression of this quantifier, if it is of the expression only form of an exists. */
  Expr getExpr() { toGenerated(result) = quant.getExpr() }

  /** Holds if this is the expression only form of an exists quantifier. */
  predicate hasExpr() { exists(getExpr()) }

  override string getAPrimaryQlClass() { result = "Quantifier" }
}

class Exists extends Quantifier {
  Exists() { kind = "exists" }

  override string getAPrimaryQlClass() { result = "Exists" }
}

class Forall extends Quantifier {
  Forall() { kind = "forall" }

  override string getAPrimaryQlClass() { result = "Forall" }
}

class Forex extends Quantifier {
  Forex() { kind = "forex" }

  override string getAPrimaryQlClass() { result = "Forex" }
}

class Negation extends TNegation, Formula {
  Generated::Negation neg;

  Negation() { this = TNegation(neg) }

  Formula getFormula() { toGenerated(result) = neg.getChild() }

  override string getAPrimaryQlClass() { result = "Negation" }
}

/** An expression, such as `x+4`. */
class Expr extends TExpr, AstNode { }

/** A function symbol, such as `+` or `*`. */
class FunctionSymbol extends string {
  FunctionSymbol() { this = "+" or this = "-" or this = "*" or this = "/" or this = "%" }
}

/** A binary operation, such as `x+3` or `y/2` */
class BinOpExpr extends TBinOpExpr, Expr { }

class AddExpr extends TAddExpr, BinOpExpr {
  Generated::AddExpr addexpr;

  AddExpr() { this = TAddExpr(addexpr) }

  Expr getLeftOperand() { toGenerated(result) = addexpr.getLeft() }

  Expr getRightOperand() { toGenerated(result) = addexpr.getRight() }

  Expr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }

  FunctionSymbol getOperator() { result = addexpr.getChild().getValue() }
}
