/**
 * Provides classes for working with declarations.
 */

import go

/**
 * A declaration.
 */
class Decl extends @decl, ExprParent, StmtParent, FieldParent {
  /**
   * Gets the kind of this declaration, which is an integer value representing the declaration's
   * node type.
   *
   * Note that the mapping from node types to integer kinds is considered an implementation detail
   * and subject to change without notice.
   */
  int getKind() { decls(this, result, _, _) }

  /**
   * Holds if the execution of this statement may produce observable side effects.
   *
   * Memory allocation is not considered an observable side effect.
   */
  predicate mayHaveSideEffects() { none() }
}

/**
 * A bad declaration, that is, a declaration that cannot be parsed.
 */
class BadDecl extends @baddecl, Decl {
  override string toString() { result = "bad declaration" }

  override string getAPrimaryQlClass() { result = "BadDecl" }
}

/**
 * A generic declaration.
 */
class GenDecl extends @gendecl, Decl, Documentable {
  /** Gets the `i`th declaration specifier in this declaration (0-based). */
  Spec getSpec(int i) { specs(result, _, this, i) }

  /** Gets a declaration specifier in this declaration. */
  Spec getASpec() { result = this.getSpec(_) }

  /** Gets the number of declaration specifiers in this declaration. */
  int getNumSpec() { result = count(this.getASpec()) }

  override predicate mayHaveSideEffects() { this.getASpec().mayHaveSideEffects() }

  override string getAPrimaryQlClass() { result = "GenDecl" }
}

/**
 * An import declaration.
 */
class ImportDecl extends @importdecl, GenDecl {
  override string toString() { result = "import declaration" }

  override string getAPrimaryQlClass() { result = "ImportDecl" }
}

/**
 * A constant declaration.
 */
class ConstDecl extends @constdecl, GenDecl {
  override string toString() { result = "constant declaration" }

  override string getAPrimaryQlClass() { result = "ConstDecl" }
}

/**
 * A type declaration.
 */
class TypeDecl extends @typedecl, GenDecl {
  override string toString() { result = "type declaration" }

  override string getAPrimaryQlClass() { result = "TypeDecl" }
}

/**
 * A variable declaration.
 */
class VarDecl extends @vardecl, GenDecl {
  override string toString() { result = "variable declaration" }

  override string getAPrimaryQlClass() { result = "VarDecl" }
}

/**
 * A function definition, that is, either a function declaration or
 * a function literal.
 */
class FuncDef extends @funcdef, StmtParent, ExprParent {
  /** Gets the body of the defined function, if any. */
  BlockStmt getBody() { none() }

  /** Gets the name of the defined function, if any. */
  string getName() { none() }

  /** Gets the expression denoting the type of this function. */
  FuncTypeExpr getTypeExpr() { none() }

  /** Gets the type of this function. */
  SignatureType getType() { none() }

  /** Gets the scope induced by this function. */
  FunctionScope getScope() { result.getFunction() = this }

  /** Gets a `defer` statement in this function. */
  DeferStmt getADeferStmt() { result.getEnclosingFunction() = this }

  /** Gets the `i`th result variable of this function. */
  ResultVariable getResultVar(int i) { result.isResultOf(this, i) }

  /** Gets a result variable of this function. */
  ResultVariable getAResultVar() { result.getFunction() = this }

  /**
   * Gets the `i`th parameter of this function.
   *
   * The receiver variable, if any, is considered to be the -1st parameter.
   */
  Parameter getParameter(int i) { result.isParameterOf(this, i) }

  /** Gets a parameter of this function. */
  Parameter getAParameter() { result.getFunction() = this }

  /**
   * Gets the number of parameters of this function.
   */
  int getNumParameter() { result = count(this.getAParameter()) }

  /**
   * Gets a call to this function.
   */
  DataFlow::CallNode getACall() { result.getACallee() = this }

  /** Holds if this function is variadic. */
  predicate isVariadic() { this.getType().isVariadic() }

  override string getAPrimaryQlClass() { result = "FuncDef" }
}

/**
 * A function declaration.
 */
class FuncDecl extends @funcdecl, Decl, Documentable, FuncDef {
  /** Gets the identifier denoting the name of this function. */
  Ident getNameExpr() { result = this.getChildExpr(0) }

  override string getName() { result = this.getNameExpr().getName() }

  override FuncTypeExpr getTypeExpr() { result = this.getChildExpr(1) }

  override SignatureType getType() { result = this.getNameExpr().getType() }

  /** Gets the body of this function, if any. */
  override BlockStmt getBody() { result = this.getChildStmt(2) }

  /** Gets the function declared by this function declaration. */
  DeclaredFunction getFunction() { this = result.getFuncDecl() }

  override string toString() { result = "function declaration" }

  override string getAPrimaryQlClass() { result = "FuncDecl" }
}

/**
 * A method declaration.
 */
class MethodDecl extends FuncDecl {
  ReceiverDecl recv;

  MethodDecl() { recv.getFunction() = this }

  /**
   * Gets the receiver declaration of this method.
   *
   * For example, the receiver declaration of
   *
   * ```
   * func (p *Rectangle) Area() float64 { ... }
   * ```
   *
   * is `p *Rectangle`.
   */
  ReceiverDecl getReceiverDecl() { result = recv }

  /**
   * Gets the receiver type of this method.
   *
   * For example, the receiver type of
   *
   * ```
   * func (p *Rectangle) Area() float64 { ... }
   * ```
   *
   * is `*Rectangle`.
   */
  Type getReceiverType() { result = this.getReceiverDecl().getType() }

  /**
   * Gets the receiver base type of this method.
   *
   * For example, the receiver base type of
   *
   * ```
   * func (p *Rectangle) Area() float64 { ... }
   * ```
   *
   * is `Rectangle`.
   */
  NamedType getReceiverBaseType() {
    result = this.getReceiverType() or
    result = this.getReceiverType().(PointerType).getBaseType()
  }

  /**
   * Gets the receiver variable of this method.
   *
   * For example, the receiver variable of
   *
   * ```
   * func (p *Rectangle) Area() float64 { ... }
   * ```
   *
   * is the variable `p`.
   */
  ReceiverVariable getReceiver() { result.getFunction() = this }

  override string getAPrimaryQlClass() { result = "MethodDecl" }
}

/**
 * A declaration specifier.
 */
class Spec extends @spec, ExprParent, Documentable {
  /** Gets the declaration to which this specifier belongs */
  Decl getParentDecl() { specs(this, _, result, _) }

  /**
   * Gets the kind of this specifier, which is an integer value representing the specifier's
   * node type.
   *
   * Note that the mapping from node types to integer kinds is considered an implementation detail
   * and subject to change without notice.
   */
  int getKind() { specs(this, result, _, _) }

  /**
   * Holds if the execution of this specifier may produce observable side effects.
   *
   * Memory allocation is not considered an observable side effect.
   */
  predicate mayHaveSideEffects() { none() }

  override string getAPrimaryQlClass() { result = "Spec" }
}

/**
 * An import specifier.
 */
class ImportSpec extends @importspec, Spec {
  /** Gets the identifier denoting the imported name. */
  Ident getNameExpr() { result = this.getChildExpr(0) }

  /** Gets the imported name. */
  string getName() { result = this.getNameExpr().getName() }

  /** Gets the string literal denoting the imported path. */
  StringLit getPathExpr() { result = this.getChildExpr(1) }

  /** Gets the imported path. */
  string getPath() { result = this.getPathExpr().getValue() }

  override string toString() { result = "import specifier" }

  override string getAPrimaryQlClass() { result = "ImportSpec" }
}

/**
 * A constant or variable declaration specifier.
 */
class ValueSpec extends @valuespec, Spec {
  /** Gets the identifier denoting the `i`th name declared by this specifier (0-based). */
  Ident getNameExpr(int i) {
    i >= 0 and
    result = this.getChildExpr(-(i + 1))
  }

  /** Holds if this specifier is a part of a constant declaration. */
  predicate isConstSpec() { this.getParentDecl() instanceof ConstDecl }

  /** Gets an identifier denoting a name declared by this specifier. */
  Ident getANameExpr() { result = this.getNameExpr(_) }

  /** Gets the `i`th name declared by this specifier (0-based). */
  string getName(int i) { result = this.getNameExpr(i).getName() }

  /** Gets a name declared by this specifier. */
  string getAName() { result = this.getName(_) }

  /** Gets the number of names declared by this specifier. */
  int getNumName() { result = count(this.getANameExpr()) }

  /** Gets the expression denoting the type of the symbols declared by this specifier. */
  Expr getTypeExpr() { result = this.getChildExpr(0) }

  /** Gets the `i`th initializer of this specifier (0-based). */
  Expr getInit(int i) {
    i >= 0 and
    result = this.getChildExpr(i + 1)
  }

  /** Gets an initializer of this specifier. */
  Expr getAnInit() { result = this.getInit(_) }

  /** Gets the number of initializers of this specifier. */
  int getNumInit() { result = count(this.getAnInit()) }

  /** Gets the unique initializer of this specifier, if there is only one. */
  Expr getInit() { this.getNumInit() = 1 and result = this.getInit(0) }

  /**
   * Gets the specifier that contains the initializers for this specifier.
   * If this valuespec has initializers, the result is itself. Otherwise, it is the
   * last specifier declared before this one that has initializers.
   */
  private ValueSpec getEffectiveSpec() {
    (exists(this.getAnInit()) or not this.isConstSpec()) and
    result = this
    or
    not exists(this.getAnInit()) and
    exists(ConstDecl decl, int idx |
      decl = this.getParentDecl() and
      decl.getSpec(idx) = this
    |
      result = decl.getSpec(idx - 1).(ValueSpec).getEffectiveSpec()
    )
  }

  /**
   * Gets the `i`th effective initializer of this specifier, that is, the expression
   * that the `i`th name will get initialized to. This is the same as `getInit`
   * if it exists, or `getInit` on the last specifier in the declaration that this
   * is a child of.
   */
  private Expr getEffectiveInit(int i) { result = this.getEffectiveSpec().getInit(i) }

  /** Holds if this specifier initializes `name` to the value of `init`. */
  predicate initializes(string name, Expr init) {
    exists(int i |
      name = this.getName(i) and
      init = this.getEffectiveInit(i)
    )
  }

  override predicate mayHaveSideEffects() { this.getAnInit().mayHaveSideEffects() }

  override string toString() { result = "value declaration specifier" }

  override string getAPrimaryQlClass() { result = "ValueSpec" }
}

/**
 * A type declaration specifier, which is either a type definition or an alias declaration.
 *
 * Examples:
 *
 * ```
 * type (
 *   status int
 *   intlist = []int
 * )
 * ```
 */
class TypeSpec extends @typespec, Spec {
  /** Gets the identifier denoting the name of the declared type. */
  Ident getNameExpr() { result = this.getChildExpr(0) }

  /** Gets the name of the declared type. */
  string getName() { result = this.getNameExpr().getName() }

  /**
   * Gets the expression denoting the underlying type to which the newly declared type is bound.
   */
  Expr getTypeExpr() { result = this.getChildExpr(1) }

  override string toString() { result = "type declaration specifier" }

  override string getAPrimaryQlClass() { result = "TypeSpec" }
}

/**
 * An alias declaration specifier.
 *
 * Examples:
 *
 * ```
 * type intlist = []int
 * ```
 */
class AliasSpec extends @aliasspec, TypeSpec { }

/**
 * A type definition specifier.
 *
 * Examples:
 *
 * ```
 * type status int
 * ```
 */
class TypeDefSpec extends @typedefspec, TypeSpec { }

/**
 * A field declaration, of a struct, a function (in which case this is a parameter or result variable),
 * or an interface (in which case this is a method or embedding spec).
 */
class FieldBase extends @field, ExprParent {
  /**
   * Gets the expression representing the type of the fields declared in this declaration.
   */
  Expr getTypeExpr() { result = this.getChildExpr(0) }

  /**
   * Gets the type of the fields declared in this declaration.
   */
  Type getType() { result = this.getTypeExpr().getType() }
}

/**
 * A field declaration in a struct type.
 */
class FieldDecl extends FieldBase, Documentable, ExprParent {
  StructTypeExpr st;

  FieldDecl() { this = st.getField(_) }

  /**
   * Gets the expression representing the name of the `i`th field declared in this declaration
   * (0-based).
   */
  Expr getNameExpr(int i) {
    i >= 0 and
    result = this.getChildExpr(i + 1)
  }

  /** Gets the tag expression of this field declaration, if any. */
  Expr getTag() { result = this.getChildExpr(-1) }

  /** Gets the struct type expression to which this field declaration belongs. */
  StructTypeExpr getDeclaringStructTypeExpr() { result = st }

  /** Gets the struct type to which this field declaration belongs. */
  StructType getDeclaringType() { result = this.getDeclaringStructTypeExpr().getType() }

  override string toString() { result = "field declaration" }

  override string getAPrimaryQlClass() { result = "FieldDecl" }
}

/**
 * An embedded field declaration in a struct.
 */
class EmbeddedFieldDecl extends FieldDecl {
  EmbeddedFieldDecl() { not exists(this.getNameExpr(_)) }

  override string getAPrimaryQlClass() { result = "EmbeddedFieldDecl" }
}

/**
 * A function parameter or result variable declaration.
 */
class ParameterOrResultDecl extends FieldBase, Documentable, ExprParent {
  int rawIndex;
  FuncTypeExpr ft;

  ParameterOrResultDecl() { this = ft.getField(rawIndex) }

  /**
   * Gets the function type expression to which this declaration belongs.
   */
  FuncTypeExpr getFunctionTypeExpr() { result = ft }

  /**
   * Gets the function to which this declaration belongs.
   */
  FuncDef getFunction() { result.getTypeExpr() = this.getFunctionTypeExpr() }

  /**
   * Gets the expression representing the name of the `i`th variable declared in this declaration
   * (0-based).
   */
  Expr getNameExpr(int i) {
    i >= 0 and
    result = this.getChildExpr(i + 1)
  }

  /**
   * Gets an expression representing the name of a variable declared in this declaration.
   */
  Expr getANameExpr() { result = this.getNameExpr(_) }
}

/**
 * A parameter declaration.
 */
class ParameterDecl extends ParameterOrResultDecl {
  ParameterDecl() { rawIndex >= 0 }

  /**
   * Gets the index of this parameter declarations among all parameter declarations of
   * its associated function type.
   */
  int getIndex() { result = rawIndex }

  override string toString() { result = "parameter declaration" }

  override string getAPrimaryQlClass() { result = "ParameterDecl" }
}

/**
 * A receiver declaration in a function declaration.
 */
class ReceiverDecl extends FieldBase, Documentable, ExprParent {
  FuncDecl fd;

  ReceiverDecl() { fd.getField(-1) = this }

  /**
   * Gets the function declaration to which this receiver belongs.
   */
  FuncDecl getFunction() { result = fd }

  /**
   * Gets the expression representing the name of the receiver declared in this declaration.
   */
  Expr getNameExpr() { result = this.getChildExpr(1) }

  override string toString() { result = "receiver declaration" }

  override string getAPrimaryQlClass() { result = "ReceiverDecl" }
}

/**
 * A result variable declaration.
 */
class ResultVariableDecl extends ParameterOrResultDecl {
  ResultVariableDecl() { rawIndex < 0 }

  /**
   * Gets the index of this result variable declaration among all result variable declarations of
   * its associated function type.
   */
  int getIndex() { result = -(rawIndex + 1) }

  override string toString() { result = "result variable declaration" }

  override string getAPrimaryQlClass() { result = "ResultVariableDecl" }
}

/**
 * A method or embedding specification in an interface type expression.
 */
class InterfaceMemberSpec extends FieldBase, Documentable, ExprParent {
  InterfaceTypeExpr ite;
  int idx;

  InterfaceMemberSpec() { this = ite.getField(idx) }

  /**
   * Gets the interface type expression to which this member specification belongs.
   */
  InterfaceTypeExpr getInterfaceTypeExpr() { result = ite }

  /**
   * Gets the index of this member specification among all member specifications of
   * its associated interface type expression.
   */
  int getIndex() { result = idx }
}

/**
 * A method specification in an interface.
 */
class MethodSpec extends InterfaceMemberSpec {
  Expr name;

  MethodSpec() { name = this.getChildExpr(1) }

  /**
   * Gets the expression representing the name of the method declared in this specification.
   */
  Expr getNameExpr() { result = name }

  override string toString() { result = "method declaration" }

  override string getAPrimaryQlClass() { result = "MethodSpec" }
}

/**
 * An embedding specification in an interface.
 */
class EmbeddingSpec extends InterfaceMemberSpec {
  EmbeddingSpec() { not exists(this.getChildExpr(1)) }

  override string toString() { result = "interface embedding" }

  override string getAPrimaryQlClass() { result = "EmbeddingSpec" }
}
