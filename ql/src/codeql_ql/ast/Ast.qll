import ql
private import codeql_ql.ast.internal.AstNodes
private import codeql_ql.ast.internal.Module
private import codeql_ql.ast.internal.Predicate
import codeql_ql.ast.internal.Type
private import codeql_ql.ast.internal.Variable

bindingset[name]
private string directMember(string name) { result = name + "()" }

bindingset[name, i]
private string indexedMember(string name, int i) { result = name + "(_)" and exists(i) }

bindingset[name, index]
private string stringIndexedMember(string name, string index) {
  result = name + "(_)" and exists(index)
}

/** An AST node of a QL program */
class AstNode extends TAstNode {
  string toString() { result = getAPrimaryQlClass() }

  /**
   * Gets the location of the AST node.
   */
  cached
  Location getLocation() {
    exists(Generated::AstNode node | not node instanceof Generated::ParExpr |
      node = toGenerated(this) and
      result = node.getLocation()
    )
  }

  /**
   * Gets the parent in the AST for this node.
   */
  AstNode getParent() { result.getAChild(_) = this }

  /**
   * Gets a child of this node, which can also be retrieved using a predicate
   * named `pred`.
   */
  cached
  AstNode getAChild(string pred) { none() }

  /**
   * Gets the primary QL class for the ast node.
   */
  string getAPrimaryQlClass() { result = "???" }

  /** Gets the QLDoc comment for this AST node, if any. */
  QLDoc getQLDoc() { none() }

  /** Holds if `node` has an annotation with `name`. */
  predicate hasAnnotation(string name) { this.getAnAnnotation().getName() = name }

  /** Gets an annotation of this AST node. */
  Annotation getAnAnnotation() { toGenerated(this).getParent() = toGenerated(result).getParent() }

  /**
   * Gets the predicate that contains this AST node.
   */
  pragma[noinline]
  Predicate getEnclosingPredicate() {
    not this instanceof Predicate and
    toGenerated(result) = toGenerated(this).getParent+()
  }
}

/** A toplevel QL program, i.e. a file. */
class TopLevel extends TTopLevel, AstNode {
  Generated::Ql file;

  TopLevel() { this = TTopLevel(file) }

  /**
   * Gets a member from contained in this top-level module.
   * Includes private members.
   */
  ModuleMember getAMember() { result = getMember(_) }

  /** Gets the `i`'th member of this top-level module. */
  ModuleMember getMember(int i) {
    toGenerated(result) = file.getChild(i).(Generated::ModuleMember).getChild(_)
  }

  /** Gets a top-level import in this module. */
  Import getAnImport() { result = this.getAMember() }

  /** Gets a top-level class in this module. */
  Class getAClass() { result = this.getAMember() }

  /** Gets a top-level predicate in this module. */
  ClasslessPredicate getAPredicate() { result = this.getAMember() }

  /** Gets a module defined at the top-level of this module. */
  Module getAModule() { result = this.getAMember() }

  /** Gets a `newtype` defined at the top-level of this module. */
  NewType getANewType() { result = this.getAMember() }

  override ModuleMember getAChild(string pred) {
    pred = directMember("getQLDoc") and result = this.getQLDoc()
    or
    pred = directMember("getAnImport") and result = this.getAnImport()
    or
    pred = directMember("getAClass") and result = this.getAClass()
    or
    pred = directMember("getAPredicate") and result = this.getAPredicate()
    or
    pred = directMember("getAModule") and result = this.getAModule()
    or
    pred = directMember("getANewType") and result = this.getANewType()
  }

  QLDoc getQLDocFor(ModuleMember m) {
    exists(int i | i > 0 and result = this.getMember(i) and m = this.getMember(i + 1))
  }

  override string getAPrimaryQlClass() { result = "TopLevel" }

  override QLDoc getQLDoc() { result = this.getMember(0) }
}

class QLDoc extends TQLDoc, AstNode {
  Generated::Qldoc qldoc;

  QLDoc() { this = TQLDoc(qldoc) }

  string getContents() { result = qldoc.getValue() }

  override string getAPrimaryQlClass() { result = "QLDoc" }
}

/**
 * The `from, where, select` part of a QL query.
 */
class Select extends TSelect, AstNode {
  Generated::Select sel;

  Select() { this = TSelect(sel) }

  /**
   * Gets the `i`th variable in the `from` clause.
   */
  VarDecl getVarDecl(int i) { toGenerated(result) = sel.getChild(i) }

  /**
   * Gets the formula in the `where`.
   */
  Formula getWhere() { toGenerated(result) = sel.getChild(_) }

  /**
   * Gets the `i`th expression in the `select` clause.
   */
  Expr getExpr(int i) { toGenerated(result) = sel.getChild(_).(Generated::AsExprs).getChild(i) }

  // TODO: This gets the `i`th order-by, but some expressions might not have an order-by.
  Expr getOrderBy(int i) {
    toGenerated(result) = sel.getChild(_).(Generated::OrderBys).getChild(i).getChild(0)
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getWhere") and result = this.getWhere()
    or
    exists(int i |
      pred = indexedMember("getVarDecl", i) and result = this.getVarDecl(i)
      or
      pred = indexedMember("getExpr", i) and result = this.getExpr(i)
      or
      pred = indexedMember("getOrderBy", i) and result = this.getOrderBy(i)
    )
  }

  override string getAPrimaryQlClass() { result = "Select" }
}

/**
 * A QL predicate.
 * Either a classless predicate, a class predicate, or a characteristic predicate.
 */
class Predicate extends TPredicate, AstNode, Declaration {
  /**
   * Gets the body of the predicate.
   */
  Formula getBody() { none() }

  /**
   * Gets the name of the predicate.
   */
  override string getName() { none() }

  /**
   * Gets the `i`th parameter of the predicate.
   */
  VarDecl getParameter(int i) { none() }

  /**
   * Gets the number of parameters.
   */
  int getArity() {
    not this.(ClasslessPredicate).getAlias() instanceof PredicateExpr and
    result = count(getParameter(_))
    or
    exists(PredicateExpr alias | alias = this.(ClasslessPredicate).getAlias() |
      result = alias.getArity()
    )
  }

  /**
   * Gets the return type (if any) of the predicate.
   */
  TypeExpr getReturnTypeExpr() { none() }

  Type getReturnType() { result = this.getReturnTypeExpr().getResolvedType() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getBody") and result = this.getBody()
    or
    exists(int i | pred = indexedMember("getParameter", i) and result = this.getParameter(i))
    or
    pred = directMember("getReturnTypeExpr") and result = this.getReturnTypeExpr()
  }

  override string getAPrimaryQlClass() { result = "Predicate" }
}

/**
 * A relation in the database.
 */
class Relation extends TDBRelation, AstNode, Declaration {
  Generated::DbTable table;

  Relation() { this = TDBRelation(table) }

  /**
   * Gets the name of the relation.
   */
  override string getName() { result = table.getTableName().getChild().getValue() }

  private Generated::DbColumn getColumn(int i) {
    result =
      rank[i + 1](Generated::DbColumn column, int child |
        table.getChild(child) = column
      |
        column order by child
      )
  }

  /** Gets the `i`th parameter name */
  string getParameterName(int i) { result = getColumn(i).getColName().getValue() }

  /** Gets the `i`th parameter type */
  string getParameterType(int i) {
    // TODO: This is just using the name of the type, not the actual type. Checkout Type.qll
    result = getColumn(i).getColType().getChild().(Generated::Token).getValue()
  }

  /**
   * Gets the number of parameters.
   */
  int getArity() { result = count(getColumn(_)) }

  override string getAPrimaryQlClass() { result = "Relation" }
}

/**
 * An expression that refers to a predicate, e.g. `BasicBlock::succ/2`.
 */
class PredicateExpr extends TPredicateExpr, AstNode {
  Generated::PredicateExpr pe;

  PredicateExpr() { this = TPredicateExpr(pe) }

  override string toString() { result = "predicate" }

  /**
   * Gets the name of the predicate.
   * E.g. for `BasicBlock::succ/2` the result is "succ".
   */
  string getName() {
    exists(Generated::AritylessPredicateExpr ape, Generated::LiteralId id |
      ape.getParent() = pe and
      id.getParent() = ape and
      result = id.getValue()
    )
  }

  /**
   * Gets the arity of the predicate.
   * E.g. for `BasicBlock::succ/2` the result is 2.
   */
  int getArity() {
    exists(Generated::Integer i |
      i.getParent() = pe and
      result = i.getValue().toInt()
    )
  }

  /**
   * Gets the module containing the predicate.
   * E.g. for `BasicBlock::succ/2` the result is a `ModuleExpr` representing "BasicBlock".
   */
  ModuleExpr getQualifier() {
    exists(Generated::AritylessPredicateExpr ape |
      ape.getParent() = pe and
      toGenerated(result).getParent() = ape
    )
  }

  /**
   * Gets the predicate that this expression refers to.
   */
  Predicate getResolvedPredicate() { resolvePredicateExpr(this, result) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getQualifier") and result = this.getQualifier()
  }

  override string getAPrimaryQlClass() { result = "PredicateExpr" }
}

/**
 * A classless predicate.
 */
class ClasslessPredicate extends TClasslessPredicate, Predicate, ModuleDeclaration {
  Generated::ClasslessPredicate pred;

  ClasslessPredicate() { this = TClasslessPredicate(pred) }

  /**
   * If this predicate is an alias, gets the aliased value.
   * E.g. for `predicate foo = Module::bar/2;` gets `Module::bar/2`.
   * The result is either a `PredicateExpr` or `HigherOrderFormula`.
   */
  final AstNode getAlias() {
    exists(Generated::PredicateAliasBody alias |
      alias.getParent() = pred and
      toGenerated(result).getParent() = alias
    )
    or
    toGenerated(result) = pred.getChild(_).(Generated::HigherOrderTerm)
  }

  override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

  override Formula getBody() { toGenerated(result) = pred.getChild(_).(Generated::Body).getChild() }

  override string getName() { result = pred.getName().getValue() }

  override VarDecl getParameter(int i) {
    toGenerated(result) =
      rank[i + 1](Generated::VarDecl decl, int index |
        decl = pred.getChild(index)
      |
        decl order by index
      )
  }

  override TypeExpr getReturnTypeExpr() { toGenerated(result) = pred.getReturnType() }

  override AstNode getAChild(string pred_name) {
    result = Predicate.super.getAChild(pred_name)
    or
    pred_name = directMember("getAlias") and result = this.getAlias()
    or
    pred_name = directMember("getBody") and result = this.getBody()
    or
    exists(int i | pred_name = indexedMember("getParameter", i) and result = this.getParameter(i))
    or
    pred_name = directMember("getReturnTypeExpr") and result = this.getReturnTypeExpr()
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

  /**
   * Holds if this predicate is private.
   */
  predicate isPrivate() { hasAnnotation("private") }

  /**
   * Holds if this predicate is annotated as overriding another predicate.
   */
  predicate isOverride() { hasAnnotation("override") }

  override VarDecl getParameter(int i) {
    toGenerated(result) =
      rank[i + 1](Generated::VarDecl decl, int index |
        decl = pred.getChild(index)
      |
        decl order by index
      )
  }

  /**
   * Gets the type representing this class.
   */
  ClassType getDeclaringType() { result.getDeclaration() = getParent() }

  predicate overrides(ClassPredicate other) { predOverrides(this, other) }

  override TypeExpr getReturnTypeExpr() { toGenerated(result) = pred.getReturnType() }

  override AstNode getAChild(string pred_name) {
    result = super.getAChild(pred_name)
    or
    pred_name = directMember("getBody") and result = this.getBody()
    or
    exists(int i | pred_name = indexedMember("getParameter", i) and result = this.getParameter(i))
    or
    pred_name = directMember("getReturnTypeExpr") and result = this.getReturnTypeExpr()
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

  override string getName() { result = getParent().(Class).getName() }

  override AstNode getAChild(string pred_name) {
    result = super.getAChild(pred_name)
    or
    pred_name = directMember("getBody") and result = this.getBody()
  }

  ClassType getDeclaringType() { result.getDeclaration() = getParent() }
}

/**
 * A variable definition. This is either a variable declaration or
 * an `as` expression.
 */
class VarDef extends TVarDef, AstNode {
  /** Gets the name of the declared variable. */
  string getName() { none() }

  Type getType() { none() }

  override string getAPrimaryQlClass() { result = "VarDef" }

  override string toString() { result = this.getName() }
}

/**
 * A variable declaration, with a type and a name.
 */
class VarDecl extends TVarDecl, VarDef, Declaration {
  Generated::VarDecl var;

  VarDecl() { this = TVarDecl(var) }

  override string getName() { result = var.getChild(1).(Generated::VarName).getChild().getValue() }

  override Type getType() { result = this.getTypeExpr().getResolvedType() }

  override string getAPrimaryQlClass() { result = "VarDecl" }

  /**
   * Gets the type part of this variable declaration.
   */
  TypeExpr getTypeExpr() { toGenerated(result) = var.getChild(0) }

  /**
   * Holds if this variable declaration is a private field on a class.
   */
  predicate isPrivate() {
    exists(Generated::ClassMember member |
      var = member.getChild(_).(Generated::Field).getChild() and
      member.getAFieldOrChild().(Generated::Annotation).getName().getValue() = "private"
    )
  }

  /** If this is a field, returns the class type that declares it. */
  ClassType getDeclaringType() { result.getDeclaration().getAField() = this }

  /**
   * Holds if this is a class field that overrides the field `other`.
   */
  predicate overrides(VarDecl other) { fieldOverrides(this, other) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getTypeExpr") and result = this.getTypeExpr()
  }

  override string toString() { result = this.getName() }
}

/**
 * A type reference, such as `DataFlow::Node`.
 */
class TypeExpr extends TType, AstNode {
  Generated::TypeExpr type;

  TypeExpr() { this = TType(type) }

  override string getAPrimaryQlClass() { result = "TypeExpr" }

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

  /**
   * Gets the type that this type reference refers to.
   */
  Type getResolvedType() { resolveTypeExpr(this, result) }

  override ModuleExpr getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getModule") and result = this.getModule()
  }
}

/**
 * A QL module.
 */
class Module extends TModule, ModuleDeclaration {
  Generated::Module mod;

  Module() { this = TModule(mod) }

  override string getAPrimaryQlClass() { result = "Module" }

  override string getName() { result = mod.getName().(Generated::ModuleName).getChild().getValue() }

  /**
   * Gets a member of the module.
   */
  AstNode getAMember() {
    toGenerated(result) = mod.getChild(_).(Generated::ModuleMember).getChild(_)
  }

  AstNode getMember(int i) {
    toGenerated(result) = mod.getChild(i).(Generated::ModuleMember).getChild(_)
  }

  QLDoc getQLDocFor(AstNode m) {
    exists(int i | result = this.getMember(i) and m = this.getMember(i + 1))
  }

  /** Gets the module expression that this module is an alias for, if any. */
  ModuleExpr getAlias() {
    toGenerated(result) = mod.getAFieldOrChild().(Generated::ModuleAliasBody).getChild()
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAlias") and result = this.getAlias()
    or
    pred = directMember("getAMember") and result = this.getAMember()
  }
}

/**
 * Something that can be member of a module.
 */
class ModuleMember extends TModuleMember, AstNode {
  /** Holds if this member is declared as `private`. */
  predicate isPrivate() { hasAnnotation("private") }
}

/** A declaration. E.g. a class, type, predicate, newtype... */
class Declaration extends TDeclaration, AstNode {
  /** Gets the name of this declaration. */
  string getName() { none() }

  override string toString() { result = this.getAPrimaryQlClass() + " " + this.getName() }

  override QLDoc getQLDoc() {
    result = any(TopLevel m).getQLDocFor(this)
    or
    result = any(Module m).getQLDocFor(this)
    or
    result = any(Class c).getQLDocFor(this)
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getQLDoc") and result = this.getQLDoc()
  }
}

/** An entity that can be declared in a module. */
class ModuleDeclaration extends TModuleDeclaration, Declaration, ModuleMember { }

/** An type declaration. Either a `class` or a `newtype`. */
class TypeDeclaration extends TTypeDeclaration, Declaration { }

/**
 * A QL class.
 */
class Class extends TClass, TypeDeclaration, ModuleDeclaration {
  Generated::Dataclass cls;

  Class() { this = TClass(cls) }

  override string getAPrimaryQlClass() { result = "Class" }

  override string getName() { result = cls.getName().getValue() }

  /**
   * Gets the charateristic predicate for this class.
   */
  CharPred getCharPred() {
    toGenerated(result) = cls.getChild(_).(Generated::ClassMember).getChild(_)
  }

  AstNode getMember(int i) {
    toGenerated(result) = cls.getChild(i).(Generated::ClassMember).getChild(_) or
    toGenerated(result) =
      cls.getChild(i).(Generated::ClassMember).getChild(_).(Generated::Field).getChild()
  }

  QLDoc getQLDocFor(AstNode m) {
    exists(int i | result = this.getMember(i) and m = this.getMember(i + 1))
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
   * Gets a super-type referenced in the `extends` part of the class declaration.
   */
  TypeExpr getASuperType() { toGenerated(result) = cls.getExtends(_) }

  /** Gets the type that this class is defined to be an alias of. */
  TypeExpr getAliasType() {
    toGenerated(result) = cls.getChild(_).(Generated::TypeAliasBody).getChild()
  }

  /** Gets the type of one of the members that this class is defined to be a union of. */
  TypeExpr getUnionMember() {
    toGenerated(result) = cls.getChild(_).(Generated::TypeUnionBody).getChild(_)
  }

  /** Gets the class type defined by this class declaration. */
  Type getType() { result.getDeclaration() = this }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAliasType") and result = this.getAliasType()
    or
    pred = directMember("getUnionMember") and result = this.getUnionMember()
    or
    pred = directMember("getAField") and result = this.getAField()
    or
    pred = directMember("getCharPred") and result = this.getCharPred()
    or
    pred = directMember("getASuperType") and result = this.getASuperType()
    or
    exists(string name |
      pred = stringIndexedMember("getClassPredicate", name) and
      result = this.getClassPredicate(name)
    )
  }
}

/**
 * A `newtype Foo` declaration.
 */
class NewType extends TNewType, TypeDeclaration, ModuleDeclaration {
  Generated::Datatype type;

  NewType() { this = TNewType(type) }

  override string getName() { result = type.getName().getValue() }

  override string getAPrimaryQlClass() { result = "NewType" }

  /**
   * Gets a branch in this `newtype`.
   */
  NewTypeBranch getABranch() { toGenerated(result) = type.getChild().getChild(_) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getABranch") and result = this.getABranch()
  }
}

/**
 * A branch in a `newtype`.
 * E.g. `Bar()` or `Baz()` in `newtype Foo = Bar() or Baz()`.
 */
class NewTypeBranch extends TNewTypeBranch, TypeDeclaration {
  Generated::DatatypeBranch branch;

  NewTypeBranch() { this = TNewTypeBranch(branch) }

  override string getAPrimaryQlClass() { result = "NewTypeBranch" }

  override string getName() { result = branch.getName().getValue() }

  /** Gets a field in this branch. */
  VarDecl getField(int i) {
    toGenerated(result) =
      rank[i + 1](Generated::VarDecl var, int index |
        var = branch.getChild(index)
      |
        var order by index
      )
  }

  /** Gets the body of this branch. */
  Formula getBody() { toGenerated(result) = branch.getChild(_).(Generated::Body).getChild() }

  override QLDoc getQLDoc() { toGenerated(result) = branch.getChild(_) }

  NewType getNewType() { result.getABranch() = this }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getBody") and result = this.getBody()
    or
    exists(int i | pred = indexedMember("getField", i) and result = this.getField(i))
    or
    pred = directMember("getQLDoc") and result = this.getQLDoc()
  }
}

/**
 * A call to a predicate.
 * Either a predicate call `foo()`,
 * or a member call `foo.bar()`,
 * or a special call to `none()` or `any()`.
 */
class Call extends TCall, Expr, Formula {
  /** Gets the `i`th argument of this call. */
  Expr getArgument(int i) {
    none() // overriden in sublcasses.
  }

  /** Gets an argument of this call, if any. */
  final Expr getAnArgument() { result = getArgument(_) }

  PredicateOrBuiltin getTarget() { resolveCall(this, result) }

  override Type getType() { result = this.getTarget().getReturnType() }

  final int getNumberOfArguments() { result = count(this.getArgument(_)) }

  /** Holds if this call is a transitive closure of `kind` either `+` or `*`. */
  predicate isClosure(string kind) { none() }

  /**
   * Gets the module that contains the predicate.
   * E.g. for `Foo::bar()` the result is `Foo`.
   */
  ModuleExpr getQualifier() { none() }
}

/**
 * A call to a non-member predicate.
 * E.g. `foo()` or `Foo::bar()`.
 */
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

  override predicate isClosure(string kind) {
    kind = expr.getChild(_).(Generated::Closure).getValue()
  }

  /**
   * Gets the name of the predicate called.
   * E.g. for `foo()` the result is "foo".
   */
  string getPredicateName() {
    result = expr.getChild(0).(Generated::AritylessPredicateExpr).getName().getValue()
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i | pred = indexedMember("getArgument", i) and result = this.getArgument(i))
    or
    pred = directMember("getQualifier") and result = this.getQualifier()
  }
}

/**
 * A member call to a predicate.
 * E.g. `foo.bar()`.
 */
class MemberCall extends TMemberCall, Call {
  Generated::QualifiedExpr expr;

  MemberCall() { this = TMemberCall(expr) }

  override string getAPrimaryQlClass() { result = "MemberCall" }

  /**
   * Gets the name of the member called.
   * E.g. for `foo.bar()` the result is "bar".
   */
  string getMemberName() {
    result = expr.getChild(_).(Generated::QualifiedRhs).getName().getValue()
  }

  override predicate isClosure(string kind) {
    kind = expr.getChild(_).(Generated::QualifiedRhs).getChild(_).(Generated::Closure).getValue()
  }

  /**
   * Gets the supertype referenced in this call, that is the `Foo` in `Foo.super.bar(...)`.
   *
   * Only yields a result if this is actually a `super` call.
   */
  TypeExpr getSuperType() {
    toGenerated(result) = expr.getChild(_).(Generated::SuperRef).getChild(0)
  }

  override Expr getArgument(int i) {
    result =
      rank[i + 1](Expr e, int index |
        toGenerated(e) = expr.getChild(_).(Generated::QualifiedRhs).getChild(index)
      |
        e order by index
      )
  }

  /**
   * Gets the base of the member call.
   * E.g. for `foo.(Bar).baz()` the result is `foo.(Bar)`.
   */
  Expr getBase() { toGenerated(result) = expr.getChild(0) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getBase") and result = this.getBase()
    or
    pred = directMember("getSuperType") and result = this.getSuperType()
    or
    exists(int i | pred = indexedMember("getArgument", i) and result = this.getArgument(i))
  }
}

/**
 * A call to the special `none()` predicate.
 */
class NoneCall extends TNoneCall, Call, Formula {
  Generated::SpecialCall call;

  NoneCall() { this = TNoneCall(call) }

  override string getAPrimaryQlClass() { result = "NoneCall" }

  override AstNode getParent() { result = Call.super.getParent() }
}

/**
 * A call to the special `any()` predicate.
 */
class AnyCall extends TAnyCall, Call {
  Generated::Aggregate agg;

  AnyCall() { this = TAnyCall(agg) }

  override string getAPrimaryQlClass() { result = "AnyCall" }
}

/**
 * An inline cast, e.g. `foo.(Bar)`.
 */
class InlineCast extends TInlineCast, Expr {
  Generated::QualifiedExpr expr;

  InlineCast() { this = TInlineCast(expr) }

  override string getAPrimaryQlClass() { result = "InlineCast" }

  /**
   * Gets the type being cast to.
   * E.g. for `foo.(Bar)` the result is `Bar`.
   */
  TypeExpr getTypeExpr() {
    toGenerated(result) = expr.getChild(_).(Generated::QualifiedRhs).getChild(_)
  }

  override Type getType() { result = this.getTypeExpr().getResolvedType() }

  /**
   * Gets the expression being cast.
   * E.g. for `foo.(Bar)` the result is `foo`.
   */
  Expr getBase() { toGenerated(result) = expr.getChild(0) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getTypeExpr") and result = this.getTypeExpr()
    or
    pred = directMember("getBase") and result = this.getBase()
  }
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

  final override FileOrModule getResolvedModule() { resolve(this, result) }
}

/** A formula, such as `x = 6 and y < 5`. */
class Formula extends TFormula, AstNode { }

/** An `and` formula, with 2 or more operands. */
class Conjunction extends TConjunction, AstNode, Formula {
  Generated::Conjunction conj;

  Conjunction() { this = TConjunction(conj) }

  override string getAPrimaryQlClass() { result = "Conjunction" }

  /** Gets an operand to this formula. */
  Formula getAnOperand() { toGenerated(result) in [conj.getLeft(), conj.getRight()] }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAnOperand") and result = this.getAnOperand()
  }
}

/** An `or` formula, with 2 or more operands. */
class Disjunction extends TDisjunction, AstNode, Formula {
  Generated::Disjunction disj;

  Disjunction() { this = TDisjunction(disj) }

  override string getAPrimaryQlClass() { result = "Disjunction" }

  /** Gets an operand to this formula. */
  Formula getAnOperand() { toGenerated(result) in [disj.getLeft(), disj.getRight()] }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAnOperand") and result = this.getAnOperand()
  }
}

/**
 * A comparison operator, such as `<` or `=`.
 */
class ComparisonOp extends TComparisonOp, AstNode {
  Generated::Compop op;

  ComparisonOp() { this = TComparisonOp(op) }

  /**
   * Gets a string representing the operator.
   * E.g. "<" or "=".
   */
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

  override PrimitiveType getType() { result.getName() = "string" }

  /** Gets the string value of this literal. */
  string getValue() {
    exists(string raw | raw = lit.getChild().(Generated::String).getValue() |
      result = raw.substring(1, raw.length() - 1)
    )
  }
}

/** An integer literal. */
class Integer extends Literal {
  Integer() { lit.getChild() instanceof Generated::Integer }

  override string getAPrimaryQlClass() { result = "Integer" }

  override PrimitiveType getType() { result.getName() = "int" }

  /** Gets the integer value of this literal. */
  int getValue() { result = lit.getChild().(Generated::Integer).getValue().toInt() }
}

/** A float literal. */
class Float extends Literal {
  Float() { lit.getChild() instanceof Generated::Float }

  override string getAPrimaryQlClass() { result = "Float" }

  override PrimitiveType getType() { result.getName() = "float" }

  /** Gets the float value of this literal. */
  float getValue() { result = lit.getChild().(Generated::Float).getValue().toFloat() }
}

/** A boolean literal */
class Boolean extends Literal {
  Generated::Bool bool;

  Boolean() { lit.getChild() = bool }

  /** Holds if the value is `true` */
  predicate isTrue() { bool.getChild() instanceof Generated::True }

  /** Holds if the value is `false` */
  predicate isFalse() { bool.getChild() instanceof Generated::False }

  override PrimitiveType getType() { result.getName() = "boolean" }

  override string getAPrimaryQlClass() { result = "Boolean" }
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

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getLeftOperand") and result = this.getLeftOperand()
    or
    pred = directMember("getRightOperand") and result = this.getRightOperand()
    or
    pred = directMember("getOperator") and result = this.getOperator()
  }
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

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i | pred = indexedMember("getArgument", i) and result = this.getArgument(i))
    or
    pred = directMember("getRange") and result = this.getRange()
    or
    pred = directMember("getFormula") and result = this.getFormula()
    or
    pred = directMember("getExpr") and result = this.getExpr()
  }
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

/** A conditional formula, of the form  `if a then b else c`. */
class IfFormula extends TIfFormula, Formula {
  Generated::IfTerm ifterm;

  IfFormula() { this = TIfFormula(ifterm) }

  /** Gets the condition (the `if` part) of this formula. */
  Formula getCondition() { toGenerated(result) = ifterm.getCond() }

  /** Gets the `then` part of this formula. */
  Formula getThenPart() { toGenerated(result) = ifterm.getFirst() }

  /** Gets the `else` part of this formula. */
  Formula getElsePart() { toGenerated(result) = ifterm.getSecond() }

  override string getAPrimaryQlClass() { result = "IfFormula" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getCondition") and result = this.getCondition()
    or
    pred = directMember("getThenPart") and result = this.getThenPart()
    or
    pred = directMember("getElsePart") and result = this.getElsePart()
  }
}

/**
 * An implication formula, of the form `foo implies bar`.
 */
class Implication extends TImplication, Formula {
  Generated::Implication imp;

  Implication() { this = TImplication(imp) }

  /** Gets the left operand of this implication. */
  Formula getLeftOperand() { toGenerated(result) = imp.getLeft() }

  /** Gets the right operand of this implication. */
  Formula getRightOperand() { toGenerated(result) = imp.getRight() }

  override string getAPrimaryQlClass() { result = "Implication" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getLeftOperand") and result = this.getLeftOperand()
    or
    pred = directMember("getRightOperand") and result = this.getRightOperand()
  }
}

/**
 * A type check formula, of the form `foo instanceof bar`.
 */
class InstanceOf extends TInstanceOf, Formula {
  Generated::InstanceOf inst;

  InstanceOf() { this = TInstanceOf(inst) }

  /** Gets the expression being checked. */
  Expr getExpr() { toGenerated(result) = inst.getChild(0) }

  /** Gets the reference to the type being checked. */
  TypeExpr getType() { toGenerated(result) = inst.getChild(1) }

  override string getAPrimaryQlClass() { result = "InstanceOf" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getExpr") and result = this.getExpr()
    or
    pred = directMember("getType") and result = this.getType()
  }
}

/**
 * A in formula, such as `foo in [2, 3]`.
 * The formula holds if the lhs is in the rhs.
 */
class InFormula extends TInFormula, Formula {
  Generated::InExpr inexpr;

  InFormula() { this = TInFormula(inexpr) }

  /**
   * Gets the expression that is checked for membership.
   * E.g. for `foo in [2, 3]` the result is `foo`.
   */
  Expr getExpr() { toGenerated(result) = inexpr.getLeft() }

  /**
   * Gets the range for this in formula.
   * E.g. for `foo in [2, 3]` the result is `[2, 3]`.
   */
  Expr getRange() { toGenerated(result) = inexpr.getRight() }

  override string getAPrimaryQlClass() { result = "InFormula" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getExpr") and result = this.getExpr()
    or
    pred = directMember("getRange") and result = this.getRange()
  }
}

/**
 * A "call" to a high-order formula.
 * E.g. `fastTC(pathSucc/2)(n1, n2)`.
 */
class HigherOrderFormula extends THigherOrderFormula, Formula {
  Generated::HigherOrderTerm hop;

  HigherOrderFormula() { this = THigherOrderFormula(hop) }

  /**
   * Gets the `i`th input to this higher-order formula.
   * E.g. for `fastTC(pathSucc/2)(n1, n2)` the result is `pathSucc/2`.
   */
  PredicateExpr getInput(int i) { toGenerated(result) = hop.getChild(i).(Generated::PredicateExpr) }

  /**
   * Gets the number of inputs.
   */
  private int getNumInputs() { result = 1 + max(int i | exists(this.getInput(i))) }

  /**
   * Gets the `i`th argument to this higher-order formula.
   * E.g. for `fastTC(pathSucc/2)(n1, n2)` the result is `n1` and `n2`.
   */
  Expr getArgument(int i) { toGenerated(result) = hop.getChild(i + getNumInputs()) }

  /**
   * Gets the name of this higher-order predicate.
   * E.g. for `fastTC(pathSucc/2)(n1, n2)` the result is "fastTC".
   */
  string getName() { result = hop.getName().getValue() }

  override string getAPrimaryQlClass() { result = "HigherOrderFormula" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i |
      pred = indexedMember("getInput", i) and result = this.getInput(i)
      or
      pred = indexedMember("getArgument", i) and result = this.getArgument(i)
    )
  }
}

class Aggregate extends TAggregate, Expr {
  string getKind() { none() }

  Generated::Aggregate getAggregate() { none() }
}

/**
 * An aggregate containing an expression.
 * E.g. `min(getAPredicate().getArity())`.
 */
class ExprAggregate extends TExprAggregate, Aggregate {
  Generated::Aggregate agg;
  Generated::ExprAggregateBody body;
  string kind;

  ExprAggregate() {
    this = TExprAggregate(agg) and
    kind = agg.getChild(0).(Generated::AggId).getValue() and
    body = agg.getChild(_)
  }

  /**
   * Gets the kind of aggregate.
   * E.g. for `min(foo())` the result is "min".
   */
  override string getKind() { result = kind }

  override Generated::Aggregate getAggregate() { result = agg }

  /**
   * Gets the ith "as" expression of this aggregate, if any.
   */
  Expr getExpr(int i) { toGenerated(result) = body.getAsExprs().getChild(i) }

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

  override string getAPrimaryQlClass() { result = "ExprAggregate[" + kind + "]" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i |
      pred = indexedMember("getExpr", i) and result = this.getExpr(i)
      or
      pred = indexedMember("getOrderBy", i) and result = this.getOrderBy(i)
    )
  }

  override Type getType() {
    exists(PrimitiveType prim | prim = result |
      kind.regexpMatch("(strict)?count|sum|min|max|rank") and
      result.getName() = "int"
      or
      kind.regexpMatch("(strict)?concat") and
      result.getName() = "string"
    )
    or
    not kind = ["count", "strictcount"] and
    result = getExpr(0).getType()
  }
}

/** An aggregate expression, such as `count` or `sum`. */
class FullAggregate extends TFullAggregate, Aggregate {
  Generated::Aggregate agg;
  string kind;
  Generated::FullAggregateBody body;

  FullAggregate() {
    this = TFullAggregate(agg) and
    kind = agg.getChild(0).(Generated::AggId).getValue() and
    body = agg.getChild(_)
  }

  /**
   * Gets the kind of aggregate.
   * E.g. for `min(int i | foo(i))` the result is "foo".
   */
  override string getKind() { result = kind }

  override Generated::Aggregate getAggregate() { result = agg }

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
  Expr getExpr(int i) { toGenerated(result) = body.getAsExprs().getChild(i) }

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

  override string getAPrimaryQlClass() { kind != "rank" and result = "FullAggregate[" + kind + "]" }

  override Type getType() {
    exists(PrimitiveType prim | prim = result |
      kind.regexpMatch("(strict)?(count|sum|min|max|rank)") and
      result.getName() = "int"
      or
      kind.regexpMatch("(strict)?concat") and
      result.getName() = "string"
    )
    or
    kind = ["any", "min", "max", "unique"] and
    not exists(getExpr(_)) and
    result = getArgument(0).getTypeExpr().getResolvedType()
    or
    not kind = ["count", "strictcount"] and
    result = getExpr(0).getType()
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i |
      pred = indexedMember("getArgument", i) and result = this.getArgument(i)
      or
      pred = indexedMember("getExpr", i) and result = this.getExpr(i)
      or
      pred = indexedMember("getOrderBy", i) and result = this.getOrderBy(i)
    )
    or
    pred = directMember("getRange") and result = this.getRange()
  }
}

/**
 * A "rank" expression, such as `rank[4](int i | i = [5 .. 15] | i)`.
 */
class Rank extends Aggregate {
  Rank() { this.getKind() = "rank" }

  override string getAPrimaryQlClass() { result = "Rank" }

  /**
   * The `i` in `rank[i]( | | )`.
   */
  Expr getRankExpr() { toGenerated(result) = this.getAggregate().getChild(1) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getRankExpr") and result = this.getRankExpr()
  }
}

/**
 * An "as" expression, such as `foo as bar`.
 */
class AsExpr extends TAsExpr, VarDef, Expr {
  Generated::AsExpr asExpr;

  AsExpr() { this = TAsExpr(asExpr) }

  override string getAPrimaryQlClass() { result = "AsExpr" }

  final override string getName() { result = this.getAsName() }

  final override Type getType() { result = this.getInnerExpr().getType() }

  /**
   * Gets the name the inner expression gets "saved" under.
   * For example this is `bar` in the expression `foo as bar`.
   */
  string getAsName() { result = asExpr.getChild(1).(Generated::VarName).getChild().getValue() }

  /**
   * Gets the inner expression of the "as" expression. For example, this is `foo` in
   * the expression `foo as bar`.
   */
  Expr getInnerExpr() { toGenerated(result) = asExpr.getChild(0) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getInnerExpr") and result = this.getInnerExpr()
  }
}

/**
 * An identifier, such as `foo`.
 */
class Identifier extends TIdentifier, Expr {
  Generated::Variable id;

  Identifier() { this = TIdentifier(id) }

  string getName() { none() }

  final override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "Identifier" }
}

/** An access to a variable. */
class VarAccess extends Identifier {
  private VarDef decl;

  VarAccess() { resolveVariable(this, decl) }

  /** Gets the accessed variable. */
  VarDef getDeclaration() { result = decl }

  override string getName() { result = id.getChild().(Generated::VarName).getChild().getValue() }

  override Type getType() { result = this.getDeclaration().getType() }

  override string getAPrimaryQlClass() { result = "VarAccess" }
}

/** An access to a field. */
class FieldAccess extends Identifier {
  private VarDecl decl;

  FieldAccess() { resolveField(this, decl) }

  /** Gets the accessed field. */
  VarDecl getDeclaration() { result = decl }

  override string getName() { result = id.getChild().(Generated::VarName).getChild().getValue() }

  override Type getType() { result = this.getDeclaration().getType() }

  override string getAPrimaryQlClass() { result = "FieldAccess" }
}

/** An access to `this`. */
class ThisAccess extends Identifier {
  ThisAccess() { any(Generated::This t).getParent() = id }

  override Type getType() { result = this.getParent+().(Class).getType() }

  override string getName() { result = "this" }

  override string getAPrimaryQlClass() { result = "ThisAccess" }
}

/** A use of `super`. */
class Super extends TSuper, Expr {
  Super() { this = TSuper(_) }

  override string getAPrimaryQlClass() { result = "Super" }
}

/** An access to `result`. */
class ResultAccess extends Identifier {
  ResultAccess() { any(Generated::Result r).getParent() = id }

  override Type getType() { result = this.getParent+().(Predicate).getReturnType() }

  override string getName() { result = "result" }

  override string getAPrimaryQlClass() { result = "ResultAccess" }
}

/** A `not` formula. */
class Negation extends TNegation, Formula {
  Generated::Negation neg;

  Negation() { this = TNegation(neg) }

  /** Gets the formula being negated. */
  Formula getFormula() { toGenerated(result) = neg.getChild() }

  override string getAPrimaryQlClass() { result = "Negation" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getFormula") and result = this.getFormula()
  }
}

/** An expression, such as `x+4`. */
class Expr extends TExpr, AstNode {
  Type getType() { none() }
}

/** An expression annotation, such as `pragma[only_bind_into](config)`. */
class ExprAnnotation extends TExprAnnotation, Expr {
  Generated::ExprAnnotation expr_anno;

  ExprAnnotation() { this = TExprAnnotation(expr_anno) }

  /**
   * Gets the name of the annotation.
   * E.g. for `pragma[only_bind_into](config)` the result is "pragma".
   */
  string getName() { result = expr_anno.getName().getValue() }

  /**
   * Gets the argument to this annotation.
   * E.g. for `pragma[only_bind_into](config)` the result is "only_bind_into".
   */
  string getAnnotationArgument() { result = expr_anno.getAnnotArg().getValue() }

  /**
   * Gets the inner expression.
   * E.g. for `pragma[only_bind_into](config)` the result is `config`.
   */
  Expr getExpression() { toGenerated(result) = expr_anno.getChild() }

  override Type getType() { result = this.getExpression().getType() }

  override string getAPrimaryQlClass() { result = "ExprAnnotation" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getExpression") and result = this.getExpression()
  }
}

/** A function symbol, such as `+` or `*`. */
class FunctionSymbol extends string {
  FunctionSymbol() { this = "+" or this = "-" or this = "*" or this = "/" or this = "%" }
}

/**
 * A binary operation expression, such as `x + 3` or `y / 2`.
 */
class BinOpExpr extends TBinOpExpr, Expr {
  /** Gets the left operand of the binary expression. */
  Expr getLeftOperand() { none() } // overriden in subclasses

  /* Gets the right operand of the binary expression. */
  Expr getRightOperand() { none() } // overriden in subclasses

  /** Gets the operator of the binary expression. */
  FunctionSymbol getOperator() { none() } // overriden in subclasses

  /* Gets an operand of the binary expression. */
  final Expr getAnOperand() { result = getLeftOperand() or result = getRightOperand() }
}

/**
 * An addition or subtraction expression.
 */
class AddSubExpr extends TAddSubExpr, BinOpExpr {
  Generated::AddExpr expr;
  FunctionSymbol operator;

  AddSubExpr() { this = TAddSubExpr(expr) and operator = expr.getChild().getValue() }

  override Expr getLeftOperand() { toGenerated(result) = expr.getLeft() }

  override Expr getRightOperand() { toGenerated(result) = expr.getRight() }

  override FunctionSymbol getOperator() { result = operator }

  override PrimitiveType getType() {
    // Both operands are the same type
    result = this.getLeftOperand().getType() and
    result = this.getRightOperand().getType()
    or
    // Both operands are subtypes of `int`
    result.getName() = "int" and
    result = this.getLeftOperand().getType().getASuperType*() and
    result = this.getRightOperand().getType().getASuperType*()
    or
    // Coercion to from `int` to `float`
    exists(PrimitiveType i | result.getName() = "float" and i.getName() = "int" |
      this.getAnOperand().getType() = result and
      this.getAnOperand().getType().getASuperType*() = i
    )
    or
    // Coercion to `string`
    result.getName() = "string" and
    this.getAnOperand().getType() = result
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getLeftOperand") and result = this.getLeftOperand()
    or
    pred = directMember("getRightOperand") and result = this.getRightOperand()
  }
}

/**
 * An addition expression, such as `x + y`.
 */
class AddExpr extends AddSubExpr {
  AddExpr() { operator = "+" }

  override string getAPrimaryQlClass() { result = "AddExpr" }
}

/**
 * A subtraction expression, such as `x - y`.
 */
class SubExpr extends AddSubExpr {
  SubExpr() { operator = "-" }

  override string getAPrimaryQlClass() { result = "SubExpr" }
}

/**
 * A multiplication, division, or modulo expression.
 */
class MulDivModExpr extends TMulDivModExpr, BinOpExpr {
  Generated::MulExpr expr;
  FunctionSymbol operator;

  MulDivModExpr() { this = TMulDivModExpr(expr) and operator = expr.getChild().getValue() }

  /** Gets the left operand of the binary expression. */
  override Expr getLeftOperand() { toGenerated(result) = expr.getLeft() }

  /** Gets the right operand of the binary expression. */
  override Expr getRightOperand() { toGenerated(result) = expr.getRight() }

  override FunctionSymbol getOperator() { result = operator }

  override PrimitiveType getType() {
    // Both operands are of the same type
    this.getLeftOperand().getType() = result and
    this.getRightOperand().getType() = result
    or
    // Both operands are subtypes of `int`
    result.getName() = "int" and
    result = this.getLeftOperand().getType().getASuperType*() and
    result = this.getRightOperand().getType().getASuperType*()
    or
    // Coercion from `int` to `float`
    exists(PrimitiveType i | result.getName() = "float" and i.getName() = "int" |
      this.getAnOperand().getType() = result and
      this.getAnOperand().getType().getASuperType*() = i
    )
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getLeftOperand") and result = this.getLeftOperand()
    or
    pred = directMember("getRightOperand") and result = this.getRightOperand()
  }
}

/**
 * A division expression, such as `x / y`.
 */
class DivExpr extends MulDivModExpr {
  DivExpr() { operator = "/" }

  override string getAPrimaryQlClass() { result = "DivExpr" }
}

/**
 * A multiplication expression, such as `x * y`.
 */
class MulExpr extends MulDivModExpr {
  MulExpr() { operator = "*" }

  override string getAPrimaryQlClass() { result = "MulExpr" }
}

/**
 * A modulo expression, such as `x % y`.
 */
class ModExpr extends MulDivModExpr {
  ModExpr() { operator = "%" }

  override string getAPrimaryQlClass() { result = "ModExpr" }
}

/**
 * A range expression, such as `[1 .. 10]`.
 */
class Range extends TRange, Expr {
  Generated::Range range;

  Range() { this = TRange(range) }

  /**
   * Gets the lower bound of the range.
   */
  Expr getLowEndpoint() { toGenerated(result) = range.getLower() }

  /**
   * Gets the upper bound of the range.
   */
  Expr getHighEndpoint() { toGenerated(result) = range.getUpper() }

  /**
   * Gets the lower and upper bounds of the range.
   */
  Expr getAnEndpoint() { result = [getLowEndpoint(), getHighEndpoint()] }

  override PrimitiveType getType() { result.getName() = "int" }

  override string getAPrimaryQlClass() { result = "Range" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getLowEndpoint") and result = this.getLowEndpoint()
    or
    pred = directMember("getHighEndpoint") and result = this.getHighEndpoint()
  }
}

/**
 * A set literal expression, such as `[1,3,5,7]`.
 */
class Set extends TSet, Expr {
  Generated::SetLiteral set;

  Set() { this = TSet(set) }

  /**
   * Gets the `i`th element in this set literal expression.
   */
  Expr getElement(int i) { toGenerated(result) = set.getChild(i) }

  /**
   * Gets an element in this set literal expression, if any.
   */
  Expr getAnElement() { result = getElement(_) }

  /**
   * Gets the number of elements in this set literal expression.
   */
  int getNumberOfElements() { result = count(getAnElement()) }

  override Type getType() { result = this.getElement(0).getType() }

  override string getAPrimaryQlClass() { result = "Set" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i | pred = indexedMember("getElement", i) and result = getElement(i))
  }
}

/** A unary operation expression, such as `-(x*y)` */
class UnaryExpr extends TUnaryExpr, Expr {
  Generated::UnaryExpr unaryexpr;

  UnaryExpr() { this = TUnaryExpr(unaryexpr) }

  /** Gets the operand of the unary expression. */
  Expr getOperand() { toGenerated(result) = unaryexpr.getChild(1) }

  /** Gets the operator of the unary expression as a string. */
  FunctionSymbol getOperator() { result = unaryexpr.getChild(0).toString() }

  override Type getType() { result = this.getOperand().getType() }

  override string getAPrimaryQlClass() { result = "UnaryExpr" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getOperand") and result = this.getOperand()
  }
}

/** A "don't care" expression, denoted by `_`. */
class DontCare extends TDontCare, Expr {
  Generated::Underscore dontcare;

  DontCare() { this = TDontCare(dontcare) }

  override DontCareType getType() { any() }

  override string getAPrimaryQlClass() { result = "DontCare" }
}

/** A module expression. Such as `DataFlow` in `DataFlow::Node` */
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

  override string getAPrimaryQlClass() { result = "ModuleExpr" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getQualifier") and result = this.getQualifier()
  }
}

/** An argument to an annotation. */
private class AnnotationArg extends TAnnotationArg, AstNode {
  Generated::AnnotArg arg;

  AnnotationArg() { this = TAnnotationArg(arg) }

  /** Gets the name of this argument. */
  string getValue() {
    result =
      [
        arg.getChild().(Generated::SimpleId).getValue(),
        arg.getChild().(Generated::Result).getValue(), arg.getChild().(Generated::This).getValue()
      ]
  }

  override string toString() { result = this.getValue() }
}

private class NoInlineArg extends AnnotationArg {
  NoInlineArg() { this.getValue() = "noinline" }
}

private class NoMagicArg extends AnnotationArg {
  NoMagicArg() { this.getValue() = "nomagic" }
}

private class InlineArg extends AnnotationArg {
  InlineArg() { this.getValue() = "inline" }
}

private class NoOptArg extends AnnotationArg {
  NoOptArg() { this.getValue() = "noopt" }
}

private class MonotonicAggregatesArg extends AnnotationArg {
  MonotonicAggregatesArg() { this.getValue() = "monotonicAggregates" }
}

/** An annotation on an element. */
class Annotation extends TAnnotation, AstNode {
  Generated::Annotation annot;

  Annotation() { this = TAnnotation(annot) }

  override string toString() { result = "annotation" }

  override string getAPrimaryQlClass() { result = "Annotation" }

  override Location getLocation() { result = annot.getLocation() }

  /** Gets the node corresponding to the field `args`. */
  AnnotationArg getArgs(int i) { toGenerated(result) = annot.getArgs(i) }

  /** Gets the node corresponding to the field `name`. */
  string getName() { result = annot.getName().getValue() }
}

/** A `pragma[noinline]` annotation. */
class NoInline extends Annotation {
  NoInline() { this.getArgs(0) instanceof NoInlineArg }

  override string toString() { result = "noinline" }
}

/** A `pragma[inline]` annotation. */
class Inline extends Annotation {
  Inline() { this.getArgs(0) instanceof InlineArg }

  override string toString() { result = "inline" }
}

/** A `pragma[nomagic]` annotation. */
class NoMagic extends Annotation {
  NoMagic() { this.getArgs(0) instanceof NoMagicArg }

  override string toString() { result = "nomagic" }
}

/** A `pragma[noopt]` annotation. */
class NoOpt extends Annotation {
  NoOpt() { this.getArgs(0) instanceof NoOptArg }

  override string toString() { result = "noopt" }
}

/** A `language[monotonicAggregates]` annotation. */
class MonotonicAggregates extends Annotation {
  MonotonicAggregates() { this.getArgs(0) instanceof MonotonicAggregatesArg }

  override string toString() { result = "monotonicaggregates" }
}

/** A `bindingset` annotation. */
class BindingSet extends Annotation {
  BindingSet() { this.getName() = "bindingset" }

  /** Gets the `index`'th bound name in this bindingset. */
  string getBoundName(int index) { result = this.getArgs(index).getValue() }

  /** Gets a name bound by this bindingset, if any. */
  string getABoundName() { result = getBoundName(_) }

  /** Gets the number of names bound by this bindingset. */
  int getNumberOfBoundNames() { result = count(getABoundName()) }
}

/**
 * Classes modelling YAML AST nodes.
 */
module YAML {
  /** A node in a YAML file */
  class YAMLNode extends TYAMLNode, AstNode {
    /** Holds if the predicate is a root node (has no parent) */
    predicate isRoot() { not exists(getParent()) }
  }

  /** A YAML comment. */
  class YAMLComment extends TYamlCommemt, YAMLNode {
    Generated::YamlComment yamlcomment;

    YAMLComment() { this = TYamlCommemt(yamlcomment) }

    override string getAPrimaryQlClass() { result = "YAMLComment" }
  }

  /** A YAML entry. */
  class YAMLEntry extends TYamlEntry, YAMLNode {
    Generated::YamlEntry yamle;

    YAMLEntry() { this = TYamlEntry(yamle) }

    /** Gets the key of this YAML entry. */
    YAMLKey getKey() {
      exists(Generated::YamlKeyvaluepair pair |
        pair.getParent() = yamle and
        result = TYamlKey(pair.getKey())
      )
    }

    /** Gets the value of this YAML entry. */
    YAMLValue getValue() {
      exists(Generated::YamlKeyvaluepair pair |
        pair.getParent() = yamle and
        result = TYamlValue(pair.getValue())
      )
    }

    override string getAPrimaryQlClass() { result = "YAMLEntry" }
  }

  /** A YAML key. */
  class YAMLKey extends TYamlKey, YAMLNode {
    Generated::YamlKey yamlkey;

    YAMLKey() { this = TYamlKey(yamlkey) }

    /**
     * Gets the value of this YAML key.
     */
    YAMLValue getValue() {
      exists(Generated::YamlKeyvaluepair pair |
        pair.getKey() = yamlkey and result = TYamlValue(pair.getValue())
      )
    }

    override string getAPrimaryQlClass() { result = "YAMLKey" }

    /** Gets the value of this YAML value. */
    string getNamePart(int i) {
      i = 0 and result = yamlkey.getChild(0).(Generated::SimpleId).getValue()
      or
      exists(YAMLKey child |
        child = TYamlKey(yamlkey.getChild(1)) and
        result = child.getNamePart(i - 1)
      )
    }

    /**
     * Gets all the name parts of this YAML key concatenated with `/`.
     * Dashes are replaced with `/` (because we don't have that information in the generated AST).
     */
    string getQualifiedName() {
      result = concat(string part, int i | part = getNamePart(i) | part, "/" order by i)
    }
  }

  /** A YAML list item. */
  class YAMLListItem extends TYamlListitem, YAMLNode {
    Generated::YamlListitem yamllistitem;

    YAMLListItem() { this = TYamlListitem(yamllistitem) }

    /**
     * Gets the value of this YAML list item.
     */
    YAMLValue getValue() { result = TYamlValue(yamllistitem.getChild()) }

    override string getAPrimaryQlClass() { result = "YAMLListItem" }
  }

  /** A YAML value. */
  class YAMLValue extends TYamlValue, YAMLNode {
    Generated::YamlValue yamlvalue;

    YAMLValue() { this = TYamlValue(yamlvalue) }

    override string getAPrimaryQlClass() { result = "YAMLValue" }

    /** Gets the value of this YAML value. */
    string getValue() { result = yamlvalue.getValue() }
  }

  // to not expose the entire `File` API on `QlPack`.
  private newtype TQLPack = MKQlPack(File file) { file.getBaseName() = "qlpack.yml" }

  YAMLEntry test() { not result.isRoot() }

  /**
   * A `qlpack.yml` file.
   */
  class QLPack extends MKQlPack {
    File file;

    QLPack() { this = MKQlPack(file) }

    private string getProperty(string name) {
      exists(YAMLEntry entry |
        entry.isRoot() and
        entry.getKey().getQualifiedName() = name and
        result = entry.getValue().getValue().trim() and
        entry.getLocation().getFile() = file
      )
    }

    /** Gets the name of this qlpack */
    string getName() { result = getProperty("name") }

    /** Gets the version of this qlpack */
    string getVersion() { result = getProperty("version") }

    /** Gets the extractor of this qlpack */
    string getExtractor() { result = getProperty("extractor") }

    string toString() { result = getName() }

    /** Gets the file that this `QLPack` represents. */
    File getFile() { result = file }

    private predicate isADependency(YAMLEntry entry) {
      exists(YAMLEntry deps |
        deps.getLocation().getFile() = file and entry.getLocation().getFile() = file
      |
        deps.isRoot() and
        deps.getKey().getQualifiedName() = "dependencies" and
        entry.getLocation().getStartLine() = 1 + deps.getLocation().getStartLine() and
        entry.getLocation().getStartColumn() > deps.getLocation().getStartColumn()
      )
      or
      exists(YAMLEntry prev | isADependency(prev) |
        prev.getLocation().getFile() = file and
        entry.getLocation().getFile() = file and
        entry.getLocation().getStartLine() = 1 + prev.getLocation().getStartLine() and
        entry.getLocation().getStartColumn() = prev.getLocation().getStartColumn()
      )
    }

    predicate hasDependency(string name, string version) {
      exists(YAMLEntry entry | isADependency(entry) |
        entry.getKey().getQualifiedName() = name and
        entry.getValue().getValue() = version
      )
    }

    /** Gets the database scheme of this qlpack */
    File getDBScheme() {
      result.getBaseName() = getProperty("dbscheme") and
      result = file.getParentContainer().getFile(any(string s | s.matches("%.dbscheme")))
    }

    pragma[noinline]
    Container getAFileInPack() {
      result.getParentContainer() = file.getParentContainer()
      or
      result = getAFileInPack().(Folder).getAChildContainer()
    }

    /**
     * Gets a QLPack that this QLPack depends on.
     */
    QLPack getADependency() {
      exists(string name | hasDependency(name, _) | result.getName().replaceAll("-", "/") = name)
    }

    Location getLocation() {
      // hacky, just pick the first node in the file.
      result =
        min(YAMLNode entry, Location l, File f |
          entry.getLocation().getFile() = file and
          f = file and
          l = entry.getLocation()
        |
          entry order by l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine()
        ).getLocation()
    }
  }
}
