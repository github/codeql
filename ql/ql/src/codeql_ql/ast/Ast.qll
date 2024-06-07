import ql
private import codeql_ql.ast.internal.AstNodes
private import codeql_ql.ast.internal.Module
private import codeql_ql.ast.internal.Predicate
import codeql_ql.ast.internal.Type
private import codeql_ql.ast.internal.Variable
private import codeql_ql.ast.internal.Builtins
private import internal.AstMocks as Mocks

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
  string toString() { result = this.getAPrimaryQlClass() }

  /** Gets the location of the AST node. */
  cached
  Location getLocation() { result = this.getFullLocation() } // overridden in some subclasses

  /** Gets the file containing this AST node. */
  cached
  File getFile() { result = this.getFullLocation().getFile() }

  /** Gets the location that spans the entire AST node. */
  cached
  final Location getFullLocation() {
    exists(QL::AstNode node | not node instanceof QL::ParExpr |
      node = toQL(this) and
      result = node.getLocation()
    )
    or
    result = toDbscheme(this).getLocation()
  }

  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    if exists(this.getLocation())
    then this.getLocation().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    else (
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    )
  }

  /**
   * Gets the parent in the AST for this node.
   */
  cached
  AstNode getParent() { result.getAChild(_) = this }

  /**
   * Gets a child of this node, which can also be retrieved using a predicate
   * named `pred`.
   */
  cached
  AstNode getAChild(string pred) {
    pred = directMember("getAnAnnotation") and result = this.getAnAnnotation()
    or
    pred = directMember("getQLDoc") and result = this.getQLDoc()
  }

  /** Gets any child of this node. */
  AstNode getAChild() { result = this.getAChild(_) }

  /**
   * Gets the primary QL class for the ast node.
   */
  string getAPrimaryQlClass() { result = "???" }

  /** Gets the QLDoc comment for this AST node, if any. */
  QLDoc getQLDoc() { none() }

  /** Holds if `node` has an annotation with `name`. */
  predicate hasAnnotation(string name) { this.getAnAnnotation().getName() = name }

  /** Gets an annotation of this AST node. */
  Annotation getAnAnnotation() {
    not this instanceof Annotation and // avoid cyclic parent-child relationship
    toQL(this).getParent() = pragma[only_bind_out](toQL(result)).getParent() and
    // special case that is handled in `NewTypeBranch`
    not any(QL::DatatypeBranch branch) = pragma[only_bind_out](toQL(result)).getParent()
  }

  /**
   * Gets the predicate that contains this AST node.
   */
  cached
  Predicate getEnclosingPredicate() { this = getANodeInPredicate(result) }
}

private AstNode getANodeInPredicate(Predicate pred) {
  result = pred.getAChild(_)
  or
  result = getANodeInPredicate(pred).getAChild(_)
}

/** A toplevel QL program, i.e. a file. */
class TopLevel extends TTopLevel, AstNode {
  QL::Ql file;

  TopLevel() { this = TTopLevel(file) }

  /**
   * Gets a member from contained in this top-level module.
   * Includes private members.
   */
  ModuleMember getAMember() { result = this.getMember(_) }

  /** Gets the `i`'th member of this top-level module. */
  ModuleMember getMember(int i) { toQL(result) = file.getChild(i).getChild(_) }

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

  /** Gets a `select` clause in the top-level of this module. */
  Select getASelect() { result = this.getAMember() }

  override ModuleMember getAChild(string pred) {
    pred = directMember("getAnImport") and result = this.getAnImport()
    or
    pred = directMember("getAClass") and result = this.getAClass()
    or
    pred = directMember("getAPredicate") and result = this.getAPredicate()
    or
    pred = directMember("getAModule") and result = this.getAModule()
    or
    pred = directMember("getANewType") and result = this.getANewType()
    or
    pred = directMember("getQLDoc") and result = this.getQLDoc()
    or
    pred = directMember("getASelect") and result = this.getASelect()
  }

  QLDoc getQLDocFor(ModuleMember m) {
    exists(int i | result = this.getMember(i) and m = this.getMember(i + 1)) and
    (
      m instanceof ClasslessPredicate
      or
      m instanceof Class
      or
      m instanceof Module
    )
  }

  override string getAPrimaryQlClass() { result = "TopLevel" }

  override QLDoc getQLDoc() {
    result = this.getMember(0) and
    // it's not the QLDoc for a module member
    not this.getQLDocFor(_) = result and
    result.getLocation().getStartLine() = 1 // this might not hold if there is a block comment above, and that's the point.
  }
}

abstract class Comment extends AstNode, TComment {
  abstract string getContents();
}

class QLDoc extends TQLDoc, Comment {
  QL::Qldoc qldoc;

  QLDoc() { this = TQLDoc(qldoc) }

  override string getContents() { result = qldoc.getValue() }

  override string getAPrimaryQlClass() { result = "QLDoc" }

  override AstNode getParent() { result.getQLDoc() = this }
}

/** The QLDoc for a query (i.e. the top comment in a .ql file). */
class QueryDoc extends QLDoc {
  QueryDoc() {
    this.getLocation().getFile().getExtension() = "ql" and
    this = any(TopLevel t).getQLDoc()
  }

  override string getAPrimaryQlClass() { result = "QueryDoc" }

  /** Gets the @kind for the query */
  string getQueryKind() {
    result = this.getContents().regexpCapture("(?s).*@kind ([\\w-]+)\\s.*", 1)
  }

  /** Gets the @name for the query */
  string getQueryName() {
    result = this.getContents().regexpCapture("(?s).*@name (.+?)(?=\\n).*", 1)
  }

  /** Gets the id part (without language) of the @id */
  string getQueryId() {
    result = this.getContents().regexpCapture("(?s).*@id (\\w+)/([\\w\\-/]+)\\s.*", 2)
  }

  /** Gets the language of the @id */
  string getQueryLanguage() {
    result = this.getContents().regexpCapture("(?s).*@id (\\w+)/([\\w\\-/]+)\\s.*", 1)
  }
}

class BlockComment extends TBlockComment, Comment {
  QL::BlockComment comment;

  BlockComment() { this = TBlockComment(comment) }

  override string getContents() { result = comment.getValue() }

  override string getAPrimaryQlClass() { result = "BlockComment" }
}

class LineComment extends TLineComment, Comment {
  QL::LineComment comment;

  LineComment() { this = TLineComment(comment) }

  override string getContents() { result = comment.getValue() }

  override string getAPrimaryQlClass() { result = "LineComment" }
}

/**
 * The `from, where, select` part of a QL query.
 */
class Select extends TSelect, AstNode {
  QL::Select sel;

  Select() { this = TSelect(sel) }

  /**
   * Gets the `i`th variable in the `from` clause.
   */
  VarDecl getVarDecl(int i) { toQL(result) = sel.getChild(i) }

  /**
   * Gets the formula in the `where`.
   */
  Formula getWhere() { toQL(result) = sel.getChild(_) }

  /**
   * Gets the `i`th expression in the `select` clause.
   */
  Expr getExpr(int i) { toQL(result) = sel.getChild(_).(QL::AsExprs).getChild(i) }

  Expr getMessage() {
    if this.getQueryDoc().getQueryKind() = "path-problem"
    then result = this.getExpr(3)
    else result = this.getExpr(1)
  }

  // TODO: This gets the `i`th order-by, but some expressions might not have an order-by.
  Expr getOrderBy(int i) { toQL(result) = sel.getChild(_).(QL::OrderBys).getChild(i).getChild(0) }

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

  QueryDoc getQueryDoc() { result.getLocation().getFile() = this.getLocation().getFile() }
}

class PredicateOrBuiltin extends TPredOrBuiltin, AstNode {
  string getName() { none() }

  Type getDeclaringType() { none() }

  Type getParameterType(int i) { none() }

  Type getReturnType() { none() }

  int getArity() { result = count(int i | exists(this.getParameterType(i))) }

  predicate isPrivate() { none() }
}

class BuiltinPredicate extends PredicateOrBuiltin, TBuiltin {
  override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "BuiltinPredicate" }
}

class BuiltinClassless extends BuiltinPredicate, TBuiltinClassless {
  string name;
  string ret;
  string args;

  BuiltinClassless() { this = TBuiltinClassless(ret, name, args) }

  override string getName() { result = name }

  override PrimitiveType getReturnType() { result.getName() = ret }

  override PrimitiveType getParameterType(int i) { result.getName() = getArgType(args, i) }
}

class BuiltinMember extends BuiltinPredicate, TBuiltinMember {
  string name;
  string qual;
  string ret;
  string args;

  BuiltinMember() { this = TBuiltinMember(qual, ret, name, args) }

  override string getName() { result = name }

  override PrimitiveType getReturnType() { result.getName() = ret }

  override PrimitiveType getParameterType(int i) { result.getName() = getArgType(args, i) }

  override PrimitiveType getDeclaringType() { result.getName() = qual }
}

/**
 * A QL predicate.
 * Either a classless predicate, a class predicate, or a characteristic predicate.
 */
class Predicate extends TPredicate, AstNode, PredicateOrBuiltin, Declaration {
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
  override int getArity() {
    not this.(ClasslessPredicate).getAlias() instanceof PredicateExpr and
    result = count(this.getParameter(_))
    or
    exists(PredicateExpr alias | alias = this.(ClasslessPredicate).getAlias() |
      result = alias.getArity()
    )
  }

  /**
   * Holds if this predicate is private.
   */
  override predicate isPrivate() { this.hasAnnotation("private") }

  /**
   * Gets the return type (if any) of the predicate.
   */
  TypeExpr getReturnTypeExpr() { none() }

  override Type getReturnType() { result = this.getReturnTypeExpr().getResolvedType() }

  override Type getParameterType(int i) { result = this.getParameter(i).getType() }

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
  Dbscheme::Table table;

  Relation() { this = TDBRelation(table) }

  /**
   * Gets the name of the relation.
   */
  override string getName() { result = table.getTableName().getChild().getValue() }

  private Dbscheme::Column getColumn(int i) {
    result =
      rank[i + 1](Dbscheme::Column column, int child |
        table.getChild(child) = column
      |
        column order by child
      )
  }

  /** Gets the `i`th parameter name */
  string getParameterName(int i) { result = this.getColumn(i).getColName().getValue() }

  /** Gets the `i`th parameter type */
  string getParameterType(int i) {
    // TODO: This is just using the name of the type, not the actual type. Checkout Type.qll
    result = this.getColumn(i).getColType().getChild().(Dbscheme::Token).getValue()
  }

  /**
   * Gets the number of parameters.
   */
  int getArity() { result = count(this.getColumn(_)) }

  override string getAPrimaryQlClass() { result = "Relation" }
}

/**
 * An expression that refers to a predicate, e.g. `BasicBlock::succ/2`.
 */
class PredicateExpr extends TPredicateExpr, AstNode {
  QL::PredicateExpr pe;

  PredicateExpr() { this = TPredicateExpr(pe) }

  override string toString() { result = "predicate" }

  /**
   * Gets the name of the predicate.
   * E.g. for `BasicBlock::succ/2` the result is "succ".
   */
  string getName() {
    exists(QL::AritylessPredicateExpr ape, QL::LiteralId id |
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
    exists(QL::Integer i |
      i.getParent() = pe and
      result = i.getValue().toInt()
    )
  }

  /**
   * Gets the module containing the predicate.
   * E.g. for `BasicBlock::succ/2` the result is a `ModuleExpr` representing "BasicBlock".
   */
  ModuleExpr getQualifier() {
    exists(QL::AritylessPredicateExpr ape |
      ape.getParent() = pe and
      toQL(result).getParent() = ape
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
  Mocks::ClasslessPredicateOrMock pred;

  ClasslessPredicate() { this = TClasslessPredicate(pred) }

  override Location getLocation() { result = pred.asLeft().getName().getLocation() }

  /**
   * Gets the aliased value if this predicate is an alias
   * E.g. for `predicate foo = Module::bar/2;` gets `Module::bar/2`.
   * The result is either a `PredicateExpr` or `HigherOrderFormula`.
   */
  final AstNode getAlias() {
    exists(QL::PredicateAliasBody alias |
      alias.getParent() = pred.asLeft() and
      toQL(result).getParent() = alias
    )
    or
    toQL(result) = pred.asLeft().getChild(_).(QL::HigherOrderTerm)
  }

  override string getAPrimaryQlClass() { result = "ClasslessPredicate" }

  override Formula getBody() { toQL(result) = pred.asLeft().getChild(_).(QL::Body).getChild() }

  override string getName() {
    result = pred.asLeft().getName().getValue()
    or
    result = pred.asRight().getName()
  }

  override VarDecl getParameter(int i) {
    toQL(result) =
      rank[i + 1](QL::VarDecl decl, int index |
        decl = pred.asLeft().getChild(index)
      |
        decl order by index
      )
    or
    toMock(result) = pred.asRight().getParameter(i)
  }

  override TypeExpr getReturnTypeExpr() {
    toQL(result) = pred.asLeft().getReturnType()
    or
    toMock(result) = pred.asRight().getReturnTypeExpr()
  }

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

  override predicate isPrivate() { Predicate.super.isPrivate() }

  /** Holds if this classless predicate is a signature predicate with no body. */
  override predicate isSignature() { not exists(this.getBody()) }

  override QLDoc getQLDoc() {
    result = any(TopLevel m).getQLDocFor(this)
    or
    result = any(Module m).getQLDocFor(this)
  }
}

/**
 * A predicate in a class.
 */
class ClassPredicate extends TClassPredicate, Predicate {
  QL::MemberPredicate pred;

  ClassPredicate() { this = TClassPredicate(pred) }

  override Location getLocation() { result = pred.getName().getLocation() }

  override string getName() { result = pred.getName().getValue() }

  override Formula getBody() { toQL(result) = pred.getChild(_).(QL::Body).getChild() }

  override string getAPrimaryQlClass() { result = "ClassPredicate" }

  override Class getParent() { result.getAClassPredicate() = this }

  /**
   * Holds if this predicate is annotated as overriding another predicate.
   */
  predicate isOverride() { this.hasAnnotation("override") }

  override VarDecl getParameter(int i) {
    toQL(result) =
      rank[i + 1](QL::VarDecl decl, int index | decl = pred.getChild(index) | decl order by index)
  }

  /**
   * Gets the type representing this class.
   */
  override ClassType getDeclaringType() { result.getDeclaration() = this.getParent() }

  predicate overrides(ClassPredicate other) { predOverrides(this, other) }

  predicate shadows(ClassPredicate other) { predShadows(this, other) }

  override TypeExpr getReturnTypeExpr() { toQL(result) = pred.getReturnType() }

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
  QL::Charpred pred;

  CharPred() { this = TCharPred(pred) }

  override string getAPrimaryQlClass() { result = "CharPred" }

  override Formula getBody() { toQL(result) = pred.getBody() }

  override string getName() { result = this.getParent().(Class).getName() }

  override AstNode getAChild(string pred_name) {
    result = super.getAChild(pred_name)
    or
    pred_name = directMember("getBody") and result = this.getBody()
  }

  override ClassType getDeclaringType() { result.getDeclaration() = this.getParent() }
}

/**
 * A variable definition. This is either a variable declaration or
 * an `as` expression.
 */
class VarDef extends TVarDef, AstNode {
  /** Gets the name of the declared variable. */
  string getName() { none() }

  Type getType() { none() }

  /** Gets a variable access to this `VarDef` */
  VarAccess getAnAccess() { result.getDeclaration() = this }

  override string getAPrimaryQlClass() { result = "VarDef" }

  override string toString() { result = this.getName() }
}

/**
 * A variable declaration, with a type and a name.
 */
class VarDecl extends TVarDecl, VarDef, Declaration {
  Mocks::VarDeclOrMock var;

  VarDecl() { this = TVarDecl(var) }

  override string getName() {
    result = var.asLeft().getChild(1).(QL::VarName).getChild().getValue()
    or
    result = var.asRight().getName()
  }

  override Type getType() { result = this.getTypeExpr().getResolvedType() }

  override string getAPrimaryQlClass() { result = "VarDecl" }

  /**
   * Gets the type part of this variable declaration.
   */
  TypeExpr getTypeExpr() {
    toQL(result) = var.asLeft().getChild(0)
    or
    toMock(result) = var.asRight().getType()
  }

  /**
   * Holds if this variable declaration is a private field on a class.
   */
  predicate isPrivate() {
    exists(QL::ClassMember member |
      var.asLeft() = member.getChild(_).(QL::Field).getChild() and
      member.getAFieldOrChild().(QL::Annotation).getName().getValue() = "private"
    )
  }

  /** If this is declared in a field, returns the class type that declares it. */
  ClassType getDeclaringType() {
    exists(FieldDecl f | f.getVarDecl() = this and result = f.getParent().(Class).getType())
  }

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
 * A field declaration;
 */
class FieldDecl extends TFieldDecl, AstNode {
  QL::Field f;

  FieldDecl() { this = TFieldDecl(f) }

  VarDecl getVarDecl() { toQL(result) = f.getChild() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getVarDecl") and result = this.getVarDecl()
  }

  override string getAPrimaryQlClass() { result = "FieldDecl" }

  /** Holds if this field is annotated as overriding another field. */
  predicate isOverride() { this.hasAnnotation("override") }

  string getName() { result = this.getVarDecl().getName() }

  override QLDoc getQLDoc() { result = any(Class c).getQLDocFor(this) }
}

/**
 * A type reference, such as `DataFlow::Node`.
 */
class TypeExpr extends TType, TypeRef {
  Mocks::TypeExprOrMock type;

  TypeExpr() { this = TType(type) }

  override string getAPrimaryQlClass() { result = "TypeExpr" }

  /**
   * Gets the class name for the type.
   * E.g. `Node` in `DataFlow::Node`.
   * Also gets the name for primitive types such as `string` or `int`
   * or db-types such as `@locateable`.
   */
  string getClassName() {
    result = type.asLeft().getName().getValue()
    or
    result = type.asLeft().getChild().(QL::PrimitiveType).getValue()
    or
    result = type.asLeft().getChild().(QL::Dbtype).getValue()
    or
    result = type.asRight().getClassName()
  }

  /**
   * Holds if this type is a primitive such as `string` or `int`.
   */
  predicate isPrimitive() { type.asLeft().getChild() instanceof QL::PrimitiveType }

  /**
   * Holds if this type is a db-type.
   */
  predicate isDBType() { type.asLeft().getChild() instanceof QL::Dbtype }

  /**
   * Gets the module of the type, if it exists.
   * E.g. `DataFlow` in `DataFlow::Node`.
   */
  ModuleExpr getModule() { toQL(result) = type.asLeft().getQualifier() }

  /** Gets the type that this type reference refers to. */
  override Type getResolvedType() {
    // resolve type
    resolveTypeExpr(this, result)
    or
    // if it resolves to a module,
    exists(FileOrModule mod | resolveModuleRef(this, mod) | result = mod.toType())
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getModule") and result = this.getModule()
  }
}

/**
 * A QL module.
 */
class Module extends TModule, ModuleDeclaration {
  Mocks::ModuleOrMock mod;

  Module() { this = TModule(mod) }

  override Location getLocation() { result = mod.asLeft().getName().getLocation() }

  override string getAPrimaryQlClass() { result = "Module" }

  override string getName() {
    result = mod.asLeft().getName().getChild().getValue()
    or
    result = mod.asRight().getName()
  }

  /**
   * Gets a member of the module.
   */
  AstNode getAMember() { result = this.getMember(_) }

  AstNode getMember(int i) {
    toQL(result) = mod.asLeft().getChild(i).(QL::ModuleMember).getChild(_)
    or
    toMock(result) = mod.asRight().getMember(i)
  }

  pragma[nomagic]
  Declaration getDeclaration(string name) {
    result = this.getAMember() and
    name = result.getName()
  }

  QLDoc getQLDocFor(AstNode m) {
    exists(int i | result = this.getMember(i) and m = this.getMember(i + 1))
  }

  /** Gets a ref to the module that this module implements. */
  TypeRef getImplements(int i) {
    exists(SignatureExpr sig | sig.toQL() = mod.asLeft().getImplements(i) | result = sig.asType())
  }

  /** Gets the module expression that this module is an alias for, if any. */
  ModuleExpr getAlias() {
    toQL(result) = mod.asLeft().getAFieldOrChild().(QL::ModuleAliasBody).getChild()
  }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAlias") and result = this.getAlias()
    or
    pred = directMember("getAMember") and result = this.getAMember()
    or
    exists(int i | pred = indexedMember("getImplements", i) and result = this.getImplements(i))
    or
    exists(int i | pred = indexedMember("hasParameter", i) and this.hasParameter(i, _, result))
  }

  /** Holds if the `i`th parameter of this module has `name` and type `sig`. */
  predicate hasParameter(int i, string name, SignatureExpr sig) {
    exists(QL::ModuleParam param |
      param = mod.asLeft().getParameter(i) and
      name = param.getParameter().getValue() and
      sig.toQL() = param.getSignature()
    )
    or
    mod.asRight().hasTypeParam(i, toMock(sig), name)
  }
}

/**
 * A member of a module.
 */
class ModuleMember extends TModuleMember, AstNode {
  /** Holds if this member is declared as `private`. */
  predicate isPrivate() { this.hasAnnotation("private") }

  /** Holds if this member is declared as `final`. */
  predicate isFinal() { this.hasAnnotation("final") }

  /** Holds if this member is declared as `deprecated`. */
  predicate isDeprecated() { this.hasAnnotation("deprecated") }
}

private newtype TDeclarationKind =
  TClassKind() or
  TModuleKind() or
  TPredicateKind(int arity) { arity = any(Predicate p).getArity() }

private TDeclarationKind getDeclarationKind(Declaration d) {
  d instanceof Class and result = TClassKind()
  or
  d instanceof Module and result = TModuleKind()
  or
  d = any(Predicate p | result = TPredicateKind(p.getArity()))
}

/** Holds if module `m` must implement signature declaration `d` with name `name` and kind `kind`. */
pragma[nomagic]
private predicate mustImplement(Module m, string name, TDeclarationKind kind, Declaration d) {
  d = m.getImplements(_).getResolvedType().getDeclaration().(Module).getAMember() and
  name = d.getName() and
  kind = getDeclarationKind(d)
}

pragma[nomagic]
private Declaration getDeclaration(Module m, string name, TDeclarationKind kind) {
  result = m.getDeclaration(name) and
  kind = getDeclarationKind(result)
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

  predicate isSignature() { this.hasAnnotation("signature") }

  /** Holds if this declaration implements `other`. */
  predicate implements(Declaration other) {
    exists(Module m, string name, TDeclarationKind kind |
      this = getDeclaration(m, name, kind) and
      mustImplement(m, name, kind, other)
    )
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
  Mocks::ClassOrMock cls;

  Class() { this = TClass(cls) }

  override Location getLocation() { result = cls.asLeft().getName().getLocation() }

  override string getAPrimaryQlClass() { result = "Class" }

  override string getName() {
    result = cls.asLeft().getName().getValue()
    or
    result = cls.asRight().getName()
  }

  /**
   * Gets the characteristic predicate for this class.
   */
  CharPred getCharPred() { toQL(result) = cls.asLeft().getChild(_).(QL::ClassMember).getChild(_) }

  AstNode getMember(int i) { toQL(result) = cls.asLeft().getChild(i).(QL::ClassMember).getChild(_) }

  QLDoc getQLDocFor(AstNode m) {
    exists(int i | result = this.getMember(i) and m = this.getMember(i + 1))
  }

  /**
   * Gets a predicate in this class.
   */
  ClassPredicate getAClassPredicate() {
    toQL(result) = cls.asLeft().getChild(_).(QL::ClassMember).getChild(_)
  }

  /**
   * Gets predicate `name` implemented in this class.
   */
  ClassPredicate getClassPredicate(string name) {
    result = this.getAClassPredicate() and
    result.getName() = name
  }

  /**
   * Gets a field in this class.
   */
  FieldDecl getAField() { result = this.getMember(_) }

  /**
   * Gets a super-type referenced in the `extends` part of the class declaration.
   */
  TypeExpr getASuperType() { toQL(result) = cls.asLeft().getExtends(_) }

  /**
   * Gets a type referenced in the `instanceof` part of the class declaration.
   */
  TypeExpr getAnInstanceofType() { toQL(result) = cls.asLeft().getInstanceof(_) }

  /** Gets the type that this class is defined to be an alias of. */
  TypeExpr getAliasType() { toQL(result) = cls.asLeft().getChild(_).(QL::TypeAliasBody).getChild() }

  /** Gets the type of one of the members that this class is defined to be a union of. */
  TypeExpr getUnionMember() {
    toQL(result) = cls.asLeft().getChild(_).(QL::TypeUnionBody).getChild(_)
  }

  /** Gets the class type defined by this class declaration. */
  ClassType getType() { result.getDeclaration() = this }

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
    pred = directMember("getAnInstanceofType") and result = this.getAnInstanceofType()
    or
    exists(string name |
      pred = stringIndexedMember("getClassPredicate", name) and
      result = this.getClassPredicate(name)
    )
  }

  /** Holds if this class is abstract. */
  predicate isAbstract() { this.hasAnnotation("abstract") }
}

/**
 * A `newtype Foo` declaration.
 */
class NewType extends TNewType, TypeDeclaration, ModuleDeclaration {
  QL::Datatype type;

  NewType() { this = TNewType(type) }

  override Location getLocation() { result = type.getName().getLocation() }

  override string getName() { result = type.getName().getValue() }

  override string getAPrimaryQlClass() { result = "NewType" }

  /**
   * Gets a branch in this `newtype`.
   */
  NewTypeBranch getABranch() { toQL(result) = type.getChild().getChild(_) }

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
class NewTypeBranch extends TNewTypeBranch, Predicate, TypeDeclaration {
  QL::DatatypeBranch branch;

  NewTypeBranch() { this = TNewTypeBranch(branch) }

  override Location getLocation() { result = branch.getName().getLocation() }

  override string getAPrimaryQlClass() { result = "NewTypeBranch" }

  override string getName() { result = branch.getName().getValue() }

  /** Gets a field in this branch. */
  VarDecl getField(int i) {
    toQL(result) =
      rank[i + 1](QL::VarDecl var, int index | var = branch.getChild(index) | var order by index)
  }

  /** Gets the body of this branch. */
  override Formula getBody() { toQL(result) = branch.getChild(_).(QL::Body).getChild() }

  override NewTypeBranchType getReturnType() { result.getDeclaration() = this }

  override Annotation getAnAnnotation() { toQL(this).getAFieldOrChild() = toQL(result) }

  override Type getParameterType(int i) { result = this.getField(i).getType() }

  override int getArity() { result = count(this.getField(_)) }

  override Type getDeclaringType() { none() }

  override predicate isPrivate() { this.getNewType().isPrivate() }

  override QLDoc getQLDoc() { toQL(result) = branch.getChild(_) }

  NewType getNewType() { result.getABranch() = this }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getBody") and result = this.getBody()
    or
    exists(int i | pred = indexedMember("getField", i) and result = this.getField(i))
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
    none() // overridden in subclasses.
  }

  /** Gets an argument of this call, if any. */
  final Expr getAnArgument() { result = this.getArgument(_) }

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
  QL::CallOrUnqualAggExpr expr;

  PredicateCall() { this = TPredicateCall(expr) }

  override Expr getArgument(int i) {
    exists(QL::CallBody body | body.getParent() = expr | toQL(result) = body.getChild(i))
  }

  final override ModuleExpr getQualifier() {
    exists(QL::AritylessPredicateExpr ape |
      ape.getParent() = expr and
      toQL(result).getParent() = ape
    )
  }

  override string getAPrimaryQlClass() { result = "PredicateCall" }

  override predicate isClosure(string kind) { kind = expr.getChild(_).(QL::Closure).getValue() }

  /**
   * Gets the name of the predicate called.
   * E.g. for `foo()` the result is "foo".
   */
  string getPredicateName() {
    result = expr.getChild(0).(QL::AritylessPredicateExpr).getName().getValue()
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
  QL::QualifiedExpr expr;

  MemberCall() { this = TMemberCall(expr) }

  override string getAPrimaryQlClass() { result = "MemberCall" }

  /**
   * Gets the name of the member called.
   * E.g. for `foo.bar()` the result is "bar".
   */
  string getMemberName() { result = expr.getChild(_).(QL::QualifiedRhs).getName().getValue() }

  override predicate isClosure(string kind) {
    kind = expr.getChild(_).(QL::QualifiedRhs).getChild(_).(QL::Closure).getValue()
  }

  /**
   * Gets the supertype referenced in this call, that is the `Foo` in `Foo.super.bar(...)`.
   *
   * Only yields a result if this is actually a `super` call.
   */
  TypeExpr getSuperType() { toQL(result) = expr.getChild(_).(QL::SuperRef).getChild(0) }

  override Expr getArgument(int i) {
    result =
      rank[i + 1](Expr e, int index |
        toQL(e) = expr.getChild(_).(QL::QualifiedRhs).getChild(index)
      |
        e order by index
      )
  }

  /**
   * Gets the base of the member call.
   * E.g. for `foo.(Bar).baz()` the result is `foo.(Bar)`.
   */
  Expr getBase() { toQL(result) = expr.getChild(0) }

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
  QL::SpecialCall call;

  NoneCall() { this = TNoneCall(call) }

  override string getAPrimaryQlClass() { result = "NoneCall" }
}

/**
 * A call to the special `any()` predicate.
 */
class AnyCall extends TAnyCall, Call {
  QL::Aggregate agg;

  AnyCall() { this = TAnyCall(agg) }

  override string getAPrimaryQlClass() { result = "AnyCall" }
}

/**
 * An inline cast, e.g. `foo.(Bar)`.
 */
class InlineCast extends TInlineCast, Expr {
  QL::QualifiedExpr expr;

  InlineCast() { this = TInlineCast(expr) }

  override string getAPrimaryQlClass() { result = "InlineCast" }

  /**
   * Gets the type being cast to.
   * E.g. for `foo.(Bar)` the result is `Bar`.
   */
  TypeExpr getTypeExpr() { toQL(result) = expr.getChild(_).(QL::QualifiedRhs).getChild(_) }

  override Type getType() { result = this.getTypeExpr().getResolvedType() }

  /**
   * Gets the expression being cast.
   * E.g. for `foo.(Bar)` the result is `foo`.
   */
  Expr getBase() { toQL(result) = expr.getChild(0) }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getTypeExpr") and result = this.getTypeExpr()
    or
    pred = directMember("getBase") and result = this.getBase()
  }
}

/** An entity that resolves to a type. */
class TypeRef extends AstNode, TTypeRef {
  abstract Type getResolvedType();

  /** Gets the module that this entity resolves to, if this reference resolves to a module */
  final FileOrModule getResolvedModule() { result.toType() = this.getResolvedType() }
}

/**
 * An import statement.
 */
class Import extends TImport, ModuleMember, TypeRef {
  QL::ImportDirective imp;

  Import() { this = TImport(imp) }

  override string getAPrimaryQlClass() { result = "Import" }

  /**
   * Gets the name under which this import is imported, if such a name exists.
   * E.g. the `Flow` in:
   * ```
   * import semmle.javascript.dataflow.Configuration as Flow
   * ```
   */
  string importedAs() { result = imp.getChild(1).(QL::ModuleName).getChild().getValue() }

  /**
   * Gets the qualified name of the module selected in the import statement.
   * E.g. for
   * `import foo.bar::Baz::Qux`
   * It is true that `getSelectionName() = "Baz::Qux"`.
   *
   * Does NOT include type arguments!
   */
  string getSelectionName() { result = this.getModuleExpr().getQualifiedName() }

  /**
   * Gets the module expression selected in the import statement.
   * E.g. for
   * `import foo.Bar::Baz::Qux`
   * The module expression is the `Bar::Baz::Qux` part.
   */
  ModuleExpr getModuleExpr() { toQL(result) = imp.getChild(0).(QL::ImportModuleExpr).getChild() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getModuleExpr") and result = this.getModuleExpr()
  }

  /**
   * Gets the `i`th imported module.
   * E.g. for
   * `import foo.bar::Baz::Qux`
   * It is true that `getQualifiedName(0) = "foo"` and `getQualifiedName(1) = "bar"`.
   */
  string getQualifiedName(int i) {
    result = imp.getChild(0).(QL::ImportModuleExpr).getQualName(i).getValue()
  }

  /**
   * Gets a full string specifying the module being imported.
   *
   * Does NOT include type arguments!
   */
  string getImportString() {
    exists(string qual |
      not exists(this.getQualifiedName(_)) and qual = ""
      or
      qual = strictconcat(int i, string q | q = this.getQualifiedName(i) | q, "." order by i) + "."
    |
      result = qual + this.getSelectionName()
    )
  }

  override Type getResolvedType() { result = this.getModuleExpr().getResolvedType() }
}

/** A formula, such as `x = 6 and y < 5`. */
class Formula extends TFormula, AstNode { }

/** An `and` formula, with 2 or more operands. */
class Conjunction extends TConjunction, AstNode, Formula {
  QL::Conjunction conj;

  Conjunction() { this = TConjunction(conj) }

  override string getAPrimaryQlClass() { result = "Conjunction" }

  /** Gets an operand to this conjunction. */
  Formula getAnOperand() { toQL(result) in [conj.getLeft(), conj.getRight()] }

  /** Gets the left operand to this conjunction. */
  Formula getLeft() { toQL(result) = conj.getLeft() }

  /** Gets the right operand to this conjunction. */
  Formula getRight() { toQL(result) = conj.getRight() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAnOperand") and result = this.getAnOperand()
  }
}

/** An `or` formula, with 2 or more operands. */
class Disjunction extends TDisjunction, AstNode, Formula {
  QL::Disjunction disj;

  Disjunction() { this = TDisjunction(disj) }

  override string getAPrimaryQlClass() { result = "Disjunction" }

  /** Gets an operand to this disjunction. */
  Formula getAnOperand() { toQL(result) in [disj.getLeft(), disj.getRight()] }

  /** Gets the left operand to this disjunction */
  Formula getLeft() { toQL(result) = disj.getLeft() }

  /** Gets the right operand to this disjunction */
  Formula getRight() { toQL(result) = disj.getRight() }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getAnOperand") and result = this.getAnOperand()
  }
}

/**
 * A literal expression, such as `6` or `true` or `"foo"`.
 */
class Literal extends TLiteral, Expr {
  QL::Literal lit;

  Literal() { this = TLiteral(lit) }

  override string getAPrimaryQlClass() { result = "??Literal??" }
}

/** A string literal. */
class String extends Literal {
  String() { lit.getChild() instanceof QL::String }

  override string getAPrimaryQlClass() { result = "String" }

  override PrimitiveType getType() { result.getName() = "string" }

  /** Gets the string value of this literal. */
  string getValue() {
    exists(string raw | raw = lit.getChild().(QL::String).getValue() |
      result = raw.substring(1, raw.length() - 1)
    )
  }
}

/** An integer literal. */
class Integer extends Literal {
  Integer() { lit.getChild() instanceof QL::Integer }

  override string getAPrimaryQlClass() { result = "Integer" }

  override PrimitiveType getType() { result.getName() = "int" }

  /** Gets the integer value of this literal. */
  int getValue() { result = lit.getChild().(QL::Integer).getValue().toInt() }
}

/** A float literal. */
class Float extends Literal {
  Float() { lit.getChild() instanceof QL::Float }

  override string getAPrimaryQlClass() { result = "Float" }

  override PrimitiveType getType() { result.getName() = "float" }

  /** Gets the float value of this literal. */
  float getValue() { result = lit.getChild().(QL::Float).getValue().toFloat() }
}

/** A boolean literal */
class Boolean extends Literal {
  QL::Bool bool;

  Boolean() { lit.getChild() = bool }

  /** Holds if the value is `true` */
  predicate isTrue() { bool.getChild() instanceof QL::True }

  /** Holds if the value is `false` */
  predicate isFalse() { bool.getChild() instanceof QL::False }

  override PrimitiveType getType() { result.getName() = "boolean" }

  override string getAPrimaryQlClass() { result = "Boolean" }
}

/** A comparison symbol, such as `"<"` or `"="`. */
class ComparisonSymbol extends string {
  ComparisonSymbol() { this = ["=", "!=", "<", ">", "<=", ">="] }
}

/** A comparison formula, such as `x < 3` or `y = true`. */
class ComparisonFormula extends TComparisonFormula, Formula {
  QL::CompTerm comp;

  ComparisonFormula() { this = TComparisonFormula(comp) }

  /** Gets the left operand of this comparison. */
  Expr getLeftOperand() { toQL(result) = comp.getLeft() }

  /** Gets the right operand of this comparison. */
  Expr getRightOperand() { toQL(result) = comp.getRight() }

  /** Gets an operand of this comparison. */
  Expr getAnOperand() { result in [this.getLeftOperand(), this.getRightOperand()] }

  /** Gets the operator of this comparison. */
  ComparisonSymbol getOperator() { result = comp.getChild().getValue() }

  override string getAPrimaryQlClass() { result = "ComparisonFormula" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getLeftOperand") and result = this.getLeftOperand()
    or
    pred = directMember("getRightOperand") and result = this.getRightOperand()
  }

  /** Holds if this comparison has the operands `a` and `b` (in any order). */
  pragma[noinline]
  predicate hasOperands(Expr a, Expr b) {
    this.getLeftOperand() = a and this.getRightOperand() = b
    or
    this.getLeftOperand() = b and this.getRightOperand() = a
  }
}

/** A quantifier formula, such as `exists` or `forall`. */
class Quantifier extends TQuantifier, Formula {
  QL::Quantified quant;
  string kind;

  Quantifier() {
    this = TQuantifier(quant) and kind = quant.getChild(0).(QL::Quantifier).getValue()
  }

  /** Gets the ith variable declaration of this quantifier. */
  VarDecl getArgument(int i) { toQL(result) = quant.getChild(i + 1) }

  /** Gets an argument of this quantifier. */
  VarDecl getAnArgument() { result = this.getArgument(_) }

  /** Gets the formula restricting the range of this quantifier, if any. */
  Formula getRange() { toQL(result) = quant.getRange() }

  /** Holds if this quantifier has a range formula. */
  predicate hasRange() { exists(this.getRange()) }

  /** Gets the main body of the quantifier. */
  Formula getFormula() { toQL(result) = quant.getFormula() }

  /**
   * Gets the expression of this quantifier, if the quantifier is
   * of the form `exists( expr )`.
   */
  Expr getExpr() { toQL(result) = quant.getExpr() }

  /**
   * Holds if this is the "expression only" form of an exists quantifier.
   * In other words, the quantifier is of the form `exists( expr )`.
   */
  predicate hasExpr() { exists(this.getExpr()) }

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
  QL::IfTerm ifterm;

  IfFormula() { this = TIfFormula(ifterm) }

  /** Gets the condition (the `if` part) of this formula. */
  Formula getCondition() { toQL(result) = ifterm.getCond() }

  /** Gets the `then` part of this formula. */
  Formula getThenPart() { toQL(result) = ifterm.getFirst() }

  /** Gets the `else` part of this formula. */
  Formula getElsePart() { toQL(result) = ifterm.getSecond() }

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
  QL::Implication imp;

  Implication() { this = TImplication(imp) }

  /** Gets the left operand of this implication. */
  Formula getLeftOperand() { toQL(result) = imp.getLeft() }

  /** Gets the right operand of this implication. */
  Formula getRightOperand() { toQL(result) = imp.getRight() }

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
  QL::InstanceOf inst;

  InstanceOf() { this = TInstanceOf(inst) }

  /** Gets the expression being checked. */
  Expr getExpr() { toQL(result) = inst.getChild(0) }

  /** Gets the reference to the type being checked. */
  TypeExpr getType() { toQL(result) = inst.getChild(1) }

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
  QL::InExpr inexpr;

  InFormula() { this = TInFormula(inexpr) }

  /**
   * Gets the expression that is checked for membership.
   * E.g. for `foo in [2, 3]` the result is `foo`.
   */
  Expr getExpr() { toQL(result) = inexpr.getLeft() }

  /**
   * Gets the range for this in formula.
   * E.g. for `foo in [2, 3]` the result is `[2, 3]`.
   */
  Expr getRange() { toQL(result) = inexpr.getRight() }

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
  QL::HigherOrderTerm hop;

  HigherOrderFormula() { this = THigherOrderFormula(hop) }

  /**
   * Gets the `i`th input to this higher-order formula.
   * E.g. for `fastTC(pathSucc/2)(n1, n2)` the result is `pathSucc/2`.
   */
  PredicateExpr getInput(int i) { toQL(result) = hop.getChild(i).(QL::PredicateExpr) }

  /**
   * Gets the number of inputs.
   */
  private int getNumInputs() { result = 1 + max(int i | exists(this.getInput(i))) }

  /**
   * Gets the `i`th argument to this higher-order formula.
   * E.g. for `fastTC(pathSucc/2)(n1, n2)` the result is `n1` and `n2`.
   */
  Expr getArgument(int i) { toQL(result) = hop.getChild(i + this.getNumInputs()) }

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

  QL::Aggregate getAggregate() { none() }
}

/**
 * An aggregate containing an expression.
 * E.g. `min(getAPredicate().getArity())`.
 */
class ExprAggregate extends TExprAggregate, Aggregate {
  QL::Aggregate agg;
  QL::ExprAggregateBody body;
  string kind;

  ExprAggregate() {
    this = TExprAggregate(agg) and
    kind = agg.getChild(0).(QL::AggId).getValue() and
    body = agg.getChild(_)
  }

  /**
   * Gets the kind of aggregate.
   * E.g. for `min(foo())` the result is "min".
   */
  override string getKind() { result = kind }

  override QL::Aggregate getAggregate() { result = agg }

  /**
   * Gets the ith "as" expression of this aggregate, if any.
   */
  Expr getExpr(int i) { toQL(result) = body.getAsExprs().getChild(i) }

  /**
   * Gets the ith "order by" expression of this aggregate, if any.
   */
  Expr getOrderBy(int i) { toQL(result) = body.getOrderBys().getChild(i).getChild(0) }

  /**
   * Gets the direction (ascending or descending) of the ith "order by" expression of this aggregate.
   */
  string getOrderbyDirection(int i) {
    result = body.getOrderBys().getChild(i).getChild(1).(QL::Direction).getValue()
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
      kind.regexpMatch("(strict)?count") and
      result.getName() = "int"
      or
      kind.regexpMatch("(strict)?concat") and
      result.getName() = "string"
    )
    or
    not kind = ["count", "strictcount"] and
    result = this.getExpr(0).getType()
  }
}

/** An aggregate expression, such as `count` or `sum`. */
class FullAggregate extends TFullAggregate, Aggregate {
  QL::Aggregate agg;
  string kind;
  QL::FullAggregateBody body;

  FullAggregate() {
    this = TFullAggregate(agg) and
    kind = agg.getChild(0).(QL::AggId).getValue() and
    body = agg.getChild(_)
  }

  /**
   * Gets the kind of aggregate.
   * E.g. for `min(int i | foo(i))` the result is "min".
   */
  override string getKind() { result = kind }

  override QL::Aggregate getAggregate() { result = agg }

  /** Gets the ith declared argument of this quantifier. */
  VarDecl getArgument(int i) { toQL(result) = body.getChild(i) }

  /** Gets an argument of this quantifier. */
  VarDecl getAnArgument() { result = this.getArgument(_) }

  /**
   * Gets the formula restricting the range of this quantifier, if any.
   */
  Formula getRange() { toQL(result) = body.getGuard() }

  /**
   * Gets the ith "as" expression of this aggregate, if any.
   */
  Expr getExpr(int i) { toQL(result) = body.getAsExprs().getChild(i) }

  /**
   * Gets the ith "order by" expression of this aggregate, if any.
   */
  Expr getOrderBy(int i) { toQL(result) = body.getOrderBys().getChild(i).getChild(0) }

  /**
   * Gets the direction (ascending or descending) of the ith "order by" expression of this aggregate.
   */
  string getOrderbyDirection(int i) {
    result = body.getOrderBys().getChild(i).getChild(1).(QL::Direction).getValue()
  }

  override string getAPrimaryQlClass() { kind != "rank" and result = "FullAggregate[" + kind + "]" }

  override Type getType() {
    exists(PrimitiveType prim | prim = result |
      kind = ["count", "strictcount"] and
      result.getName() = "int"
      or
      kind.regexpMatch("(strict)?concat") and
      result.getName() = "string"
    )
    or
    kind = ["any", "min", "max", "unique", "rank", "sum", "strictsum"] and
    not exists(this.getExpr(_)) and
    result = this.getArgument(0).getType()
    or
    not kind = ["count", "strictcount"] and
    result = this.getExpr(0).getType()
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
 * A "any" expression, such as `any(int i | i > 0).toString()`.
 */
class Any extends FullAggregate {
  Any() { this.getKind() = "any" }

  override string getAPrimaryQlClass() { result = "Any" }
}

/**
 * A "rank" expression, such as `rank[4](int i | i = [5 .. 15] | i)`.
 */
class Rank extends Aggregate {
  Rank() { this.getKind() = "rank" }

  override string getAPrimaryQlClass() { result = "Rank" }

  /**
   * Gets the `i` in `rank[i]( | | )`.
   */
  Expr getRankExpr() { toQL(result) = this.getAggregate().getChild(1) }

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
  QL::AsExpr asExpr;

  AsExpr() { this = TAsExpr(asExpr) }

  override string getAPrimaryQlClass() { result = "AsExpr" }

  final override string getName() { result = this.getAsName() }

  final override Type getType() { result = this.getInnerExpr().getType() }

  /**
   * Gets the name the inner expression gets "saved" under.
   * For example this is `bar` in the expression `foo as bar`.
   */
  string getAsName() { result = asExpr.getChild(1).(QL::VarName).getChild().getValue() }

  /**
   * Gets the inner expression of the "as" expression. For example, this is `foo` in
   * the expression `foo as bar`.
   */
  Expr getInnerExpr() { toQL(result) = asExpr.getChild(0) }

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
  QL::Variable id;

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

  override string getName() { result = id.getChild().(QL::VarName).getChild().getValue() }

  override Type getType() { result = this.getDeclaration().getType() }

  override string getAPrimaryQlClass() { result = "VarAccess" }
}

/** An access to a field. */
class FieldAccess extends Identifier {
  private VarDecl decl;

  FieldAccess() { resolveField(this, decl) }

  /** Gets the accessed field. */
  FieldDecl getDeclaration() { result.getVarDecl() = decl }

  override string getName() { result = id.getChild().(QL::VarName).getChild().getValue() }

  override Type getType() { result = decl.getType() }

  override string getAPrimaryQlClass() { result = "FieldAccess" }
}

/** An access to `this`. */
class ThisAccess extends Identifier {
  ThisAccess() { any(QL::This t).getParent() = id }

  override Type getType() { result = this.getParent+().(Class).getType() }

  override string getName() { result = "this" }

  override string getAPrimaryQlClass() { result = "ThisAccess" }
}

/** A use of `super`. */
class Super extends TSuper, Expr {
  Super() { this = TSuper(_) }

  override string getAPrimaryQlClass() { result = "Super" }

  override Type getType() {
    exists(MemberCall call | call.getBase() = this | result = call.getTarget().getDeclaringType())
  }
}

/** An access to `result`. */
class ResultAccess extends Identifier {
  ResultAccess() { any(QL::Result r).getParent() = id }

  override Type getType() { result = this.getParent+().(Predicate).getReturnType() }

  override string getName() { result = "result" }

  override string getAPrimaryQlClass() { result = "ResultAccess" }
}

/** A `not` formula. */
class Negation extends TNegation, Formula {
  QL::Negation neg;

  Negation() { this = TNegation(neg) }

  /** Gets the formula being negated. */
  Formula getFormula() { toQL(result) = neg.getChild() }

  override string getAPrimaryQlClass() { result = "Negation" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getFormula") and result = this.getFormula()
  }
}

/** An expression, such as `x+4`. */
class Expr extends TExpr, AstNode {
  cached
  Type getType() { none() }
}

/** An expression annotation, such as `pragma[only_bind_into](config)`. */
class ExprAnnotation extends TExprAnnotation, Expr {
  QL::ExprAnnotation expr_anno;

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
  Expr getExpression() { toQL(result) = expr_anno.getChild() }

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
  FunctionSymbol() { this = ["+", "-", "*", "/", "%"] }
}

/**
 * A binary operation expression, such as `x + 3` or `y / 2`.
 */
class BinOpExpr extends TBinOpExpr, Expr {
  /** Gets the left operand of the binary expression. */
  Expr getLeftOperand() { none() } // overridden in subclasses

  /** Gets the right operand of the binary expression. */
  Expr getRightOperand() { none() } // overridden in subclasses

  /** Gets the operator of the binary expression. */
  FunctionSymbol getOperator() { none() } // overridden in subclasses

  /** Gets an operand of the binary expression. */
  final Expr getAnOperand() { result = this.getLeftOperand() or result = this.getRightOperand() }
}

/**
 * An addition or subtraction expression.
 */
class AddSubExpr extends TAddSubExpr, BinOpExpr {
  QL::AddExpr expr;
  FunctionSymbol operator;

  AddSubExpr() { this = TAddSubExpr(expr) and operator = expr.getChild().getValue() }

  override Expr getLeftOperand() { toQL(result) = expr.getLeft() }

  override Expr getRightOperand() { toQL(result) = expr.getRight() }

  override FunctionSymbol getOperator() { result = operator }

  override PrimitiveType getType() {
    // Both operands are the same type
    result = this.getLeftOperand().getType() and
    result = this.getRightOperand().getType()
    or
    // Both operands are subtypes of `int` / `string` / `float`
    exprOfPrimitiveAddType(result) = this.getLeftOperand() and
    exprOfPrimitiveAddType(result) = this.getRightOperand()
    or
    // Coercion to from `int` to `float`
    exists(PrimitiveType i | result.getName() = "float" and i.getName() = "int" |
      this.getAnOperand().getType() = result and
      this.getAnOperand() = exprOfPrimitiveAddType(i)
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

pragma[noinline]
private Expr exprOfPrimitiveAddType(PrimitiveType t) {
  result.getType() = getASubTypeOfAddPrimitive(t)
}

/**
 * Gets a subtype of the given primitive type `prim`.
 * This predicate does not consider float to be a supertype of int.
 */
private Type getASubTypeOfAddPrimitive(PrimitiveType prim) {
  result = prim and
  result.getName() = ["int", "string", "float"]
  or
  exists(Type superType | superType = getASubTypeOfAddPrimitive(prim) |
    result.getASuperType() = superType and
    not (result.getName() = "int" and superType.getName() = "float")
  )
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
  QL::MulExpr expr;
  FunctionSymbol operator;

  MulDivModExpr() { this = TMulDivModExpr(expr) and operator = expr.getChild().getValue() }

  /** Gets the left operand of the binary expression. */
  override Expr getLeftOperand() { toQL(result) = expr.getLeft() }

  /** Gets the right operand of the binary expression. */
  override Expr getRightOperand() { toQL(result) = expr.getRight() }

  override FunctionSymbol getOperator() { result = operator }

  override PrimitiveType getType() {
    // Both operands are of the same type
    this.getLeftOperand().getType() = result and
    this.getRightOperand().getType() = result
    or
    // Both operands are subtypes of `int`/`float`
    result.getName() = ["int", "float"] and
    exprOfPrimitiveAddType(result) = this.getLeftOperand() and
    exprOfPrimitiveAddType(result) = this.getRightOperand()
    or
    // Coercion from `int` to `float`
    exists(PrimitiveType i | result.getName() = "float" and i.getName() = "int" |
      this.getLeftOperand() = exprOfPrimitiveAddType(result) and
      this.getRightOperand() = exprOfPrimitiveAddType(i)
      or
      this.getRightOperand() = exprOfPrimitiveAddType(result) and
      this.getLeftOperand() = exprOfPrimitiveAddType(i)
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
  QL::Range range;

  Range() { this = TRange(range) }

  /**
   * Gets the lower bound of the range.
   */
  Expr getLowEndpoint() { toQL(result) = range.getLower() }

  /**
   * Gets the upper bound of the range.
   */
  Expr getHighEndpoint() { toQL(result) = range.getUpper() }

  /**
   * Gets the lower and upper bounds of the range.
   */
  Expr getAnEndpoint() { result = [this.getLowEndpoint(), this.getHighEndpoint()] }

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
  QL::SetLiteral set;

  Set() { this = TSet(set) }

  /**
   * Gets the `i`th element in this set literal expression.
   */
  Expr getElement(int i) { toQL(result) = set.getChild(i) }

  /**
   * Gets an element in this set literal expression, if any.
   */
  Expr getAnElement() { result = this.getElement(_) }

  /**
   * Gets the number of elements in this set literal expression.
   */
  int getNumberOfElements() { result = count(this.getAnElement()) }

  override Type getType() { result = this.getElement(0).getType() }

  override string getAPrimaryQlClass() { result = "Set" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i | pred = indexedMember("getElement", i) and result = this.getElement(i))
  }
}

/** A unary operation expression, such as `-(x*y)` */
class UnaryExpr extends TUnaryExpr, Expr {
  QL::UnaryExpr unaryexpr;

  UnaryExpr() { this = TUnaryExpr(unaryexpr) }

  /** Gets the operand of the unary expression. */
  Expr getOperand() { toQL(result) = unaryexpr.getChild(1) }

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
  QL::Underscore dontcare;

  DontCare() { this = TDontCare(dontcare) }

  override DontCareType getType() { any() }

  override string getAPrimaryQlClass() { result = "DontCare" }
}

/** A module expression. Such as `DataFlow` in `DataFlow::Node` */
class ModuleExpr extends TModuleExpr, TypeRef {
  QL::ModuleExpr me;

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
    result = me.getName().(QL::SimpleId).getValue()
    or
    not exists(me.getName()) and result = me.getChild().(QL::SimpleId).getValue()
    or
    result = me.getAFieldOrChild().(QL::ModuleInstantiation).getName().getChild().getValue()
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

  override Type getResolvedType() {
    exists(FileOrModule mod | resolveModuleRef(this, mod) | result = mod.toType())
  }

  final override string toString() { result = this.getName() }

  override string getAPrimaryQlClass() { result = "ModuleExpr" }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    pred = directMember("getQualifier") and result = this.getQualifier()
    or
    exists(int i | pred = indexedMember("getArgument", i) and result = this.getArgument(i))
  }

  /**
   * Gets the `i`th type argument if this module is a module instantiation.
   * The result is either a `PredicateExpr`, `TypeExpr`, or `ModuleExpr`.
   */
  SignatureExpr getArgument(int i) {
    result.toQL() = me.getAFieldOrChild().(QL::ModuleInstantiation).getChild(i)
  }

  /**
   * Gets the qualified name for this module expression, which does not include the type arguments.
   */
  string getQualifiedName() {
    exists(string qual |
      not exists(this.getQualifier()) and qual = ""
      or
      qual = this.getQualifier().getQualifiedName() + "::"
    |
      result = qual + this.getName()
    )
  }
}

/** A signature expression, either a `PredicateExpr`, a `TypeExpr`, or a `ModuleExpr`. */
class SignatureExpr extends TSignatureExpr, AstNode {
  Mocks::SignatureExprOrMock sig;

  SignatureExpr() {
    toQL(this) = sig.asLeft().getPredicate()
    or
    toQL(this) = sig.asLeft().getTypeExpr()
    or
    toMock(this) = sig.asRight()
    or
    toQL(this) = sig.asLeft().getModExpr()
  }

  /** Gets the generated AST node that contains this signature expression. */
  QL::SignatureExpr toQL() { result = sig.asLeft() }

  /** Gets this signature expression if it represents a predicate expression. */
  PredicateExpr asPredicate() { result = this }

  /** Gets this signature expression if it represents a type expression (either a `TypeExpr` or a `ModuleExpr`). */
  TypeRef asType() { result = this }
}

/** An argument to an annotation. */
private class AnnotationArg extends TAnnotationArg, AstNode {
  QL::AnnotArg arg;

  AnnotationArg() { this = TAnnotationArg(arg) }

  /** Gets the name of this argument. */
  string getValue() {
    result =
      [
        arg.getChild().(QL::SimpleId).getValue(), arg.getChild().(QL::Result).getValue(),
        arg.getChild().(QL::This).getValue()
      ]
  }

  override string toString() { result = this.getValue() }

  override string getAPrimaryQlClass() { result = "AnnotationArg" }
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
  QL::Annotation annot;

  Annotation() { this = TAnnotation(annot) }

  override string toString() { result = "annotation" }

  override string getAPrimaryQlClass() { result = "Annotation" }

  override Location getLocation() { result = annot.getLocation() }

  /** Gets the node corresponding to the field `args`. */
  AnnotationArg getArgs(int i) { toQL(result) = annot.getArgs(i) }

  /** Gets the node corresponding to the field `name`. */
  string getName() { result = annot.getName().getValue() }

  override AstNode getParent() { result.getAnAnnotation() = this }

  override AstNode getAChild(string pred) {
    result = super.getAChild(pred)
    or
    exists(int i | pred = indexedMember("getArgs", i) and result = this.getArgs(i))
  }
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
  string getABoundName() { result = this.getBoundName(_) }

  /** Gets the number of names bound by this bindingset. */
  int getNumberOfBoundNames() { result = count(this.getABoundName()) }
}

/**
 * Classes modeling YAML AST nodes.
 */
module YAML {
  private import codeql.yaml.Yaml as LibYaml

  private module YamlSig implements LibYaml::InputSig {
    import codeql.Locations

    class LocatableBase extends @yaml_locatable {
      Location getLocation() { yaml_locations(this, result) }

      string toString() { none() }
    }

    class NodeBase extends LocatableBase, @yaml_node {
      NodeBase getChildNode(int i) { yaml(result, _, this, i, _, _) }

      string getTag() { yaml(this, _, _, _, result, _) }

      string getAnchor() { yaml_anchors(this, result) }

      override string toString() { yaml(this, _, _, _, _, result) }
    }

    class ScalarNodeBase extends NodeBase, @yaml_scalar_node {
      int getStyle() { yaml_scalars(this, result, _) }

      string getValue() { yaml_scalars(this, _, result) }
    }

    class CollectionNodeBase extends NodeBase, @yaml_collection_node { }

    class MappingNodeBase extends CollectionNodeBase, @yaml_mapping_node { }

    class SequenceNodeBase extends CollectionNodeBase, @yaml_sequence_node { }

    class AliasNodeBase extends NodeBase, @yaml_alias_node {
      string getTarget() { yaml_aliases(this, result) }
    }

    class ParseErrorBase extends LocatableBase, @yaml_error {
      string getMessage() { yaml_errors(this, result) }
    }
  }

  import LibYaml::Make<YamlSig>

  // to not expose the entire `File` API on `QlPack`.
  private newtype TQLPack = MKQlPack(File file) { file.getBaseName() = "qlpack.yml" }

  /**
   * A `qlpack.yml` file.
   */
  class QLPack extends MKQlPack {
    File file;

    QLPack() { this = MKQlPack(file) }

    private YamlValue get(string name) {
      exists(YamlMapping m |
        m instanceof YamlDocument and
        m.getFile() = file and
        result = m.lookup(name)
      )
    }

    private string getProperty(string name) { result = this.get(name).(YamlScalar).getValue() }

    /** Gets the name of this qlpack */
    string getName() { result = this.getProperty("name") }

    /** Gets the version of this qlpack */
    string getVersion() { result = this.getProperty("version") }

    /** Gets the extractor of this qlpack */
    string getExtractor() { result = this.getProperty("extractor") }

    string toString() { result = this.getName() }

    /** Gets the file that this `QLPack` represents. */
    File getFile() { result = file }

    predicate hasDependency(string name, string version) {
      version = this.get("dependencies").(YamlMapping).lookup(name).(YamlScalar).getValue()
      or
      name =
        this.get("libraryPathDependencies").(YamlCollection).getAChild().(YamlScalar).getValue() and
      version = "\"*\""
      or
      name = this.getProperty("libraryPathDependencies") and
      version = "\"*\""
    }

    /** Gets the database scheme of this qlpack */
    File getDBScheme() {
      result.getAbsolutePath() =
        file.getParentContainer().getAbsolutePath() + "/" + this.getProperty("dbscheme")
    }

    pragma[noinline]
    Container getAFileInPack() {
      result.getParentContainer() = file.getParentContainer()
      or
      result = this.getAFileInPack().(Folder).getAChildContainer()
    }

    /**
     * Gets a QLPack that this QLPack depends on.
     */
    QLPack getADependency() {
      exists(string rawDep, string dep, string name | this.hasDependency(rawDep, _) |
        dep = rawDep.replaceAll("-", "/") and
        name = result.getName().replaceAll("-", "/") and
        (
          name = dep
          or
          name.matches("codeql/%") and
          name = dep + "/all"
        )
      )
    }

    /**
     * Gets the language library file for this QLPack, if any. For example, the
     * language library file for `codeql/cpp-all` is `cpp.qll`.
     */
    File getLanguageLib() {
      exists(string name |
        name = this.getExtractor() and
        result.getParentContainer() = this.getFile().getParentContainer() and
        result.getBaseName() = name + ".qll"
      )
    }

    Location getLocation() {
      // hacky, just pick the first node in the file.
      result =
        min(YamlNode entry, Location l, File f |
          entry.getLocation().getFile() = file and
          f = file and
          l = entry.getLocation()
        |
          entry order by l.getStartLine(), l.getStartColumn(), l.getEndColumn(), l.getEndLine()
        ).getLocation()
    }
  }
}
