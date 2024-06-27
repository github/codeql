/**
 * Provides classes for working with scopes and declared objects.
 */

import go

/**
 * A scope.
 */
class Scope extends @scope {
  /** Gets the enclosing scope of this scope, if any. */
  Scope getOuterScope() { scopenesting(this, result) }

  /** Gets a scope nested inside this scope. */
  Scope getAnInnerScope() { this = result.getOuterScope() }

  /** Looks up the entity with the given name in this scope. */
  Entity getEntity(string name) {
    result.getName() = name and
    result.getScope() = this
  }

  /** Gets a textual representation of this scope. */
  string toString() { result = "scope" }
}

/** Provides helper predicates for working with scopes. */
module Scope {
  /** Gets the universe scope. */
  UniverseScope universe() { any() }
}

/**
 * The universe scope.
 */
class UniverseScope extends @universescope, Scope {
  override string toString() { result = "universe scope" }
}

/** A package scope. */
class PackageScope extends @packagescope, Scope {
  /** Gets the package whose scope this is. */
  Package getPackage() { this = result.getScope() }

  override string toString() { result = "package scope" }
}

/** A local scope. */
class LocalScope extends @localscope, Scope, Locatable {
  /** Gets the AST node inducing this scope. */
  ScopeNode getNode() { this = result.getScope() }

  /**
   * Gets the function scope in which this scope is nested.
   *
   * For function scopes, this is the scope itself.
   */
  FunctionScope getEnclosingFunctionScope() {
    result = this.getOuterScope().(LocalScope).getEnclosingFunctionScope()
  }

  override string toString() { result = "local scope" }
}

/** A local scope induced by a file. */
class FileScope extends LocalScope {
  FileScope() { this.getNode() instanceof File }
}

/** A local scope induced by a function definition. */
class FunctionScope extends LocalScope {
  FuncDef f;

  FunctionScope() { this.getNode() = f.getTypeExpr() }

  /** Gets the function inducing this scope. */
  FuncDef getFunction() { result = f }

  override FunctionScope getEnclosingFunctionScope() { result = this }

  override string toString() { result = "function scope" }
}

/**
 * A declared or built-in entity (that is, package, type, constant, variable, function or label)
 */
class Entity extends @object {
  /**
   * Gets the name of this entity.
   *
   * Anonymous entities (such as the receiver variables of interface methods) have the empty string as their name.
   */
  string getName() { objects(this, _, result) }

  /** Gets the package in which this entity is declared, if any. */
  Package getPackage() { result.getScope() = this.getScope() }

  /**
   * Holds if this entity is declared in a package with path `pkg` and has the given `name`.
   *
   * Note that for methods `pkg` is the package path followed by `.` followed
   * by the name of the receiver type, for example `io.Writer`.
   */
  pragma[nomagic]
  predicate hasQualifiedName(string pkg, string name) {
    (
      pkg = this.getPackage().getPath()
      or
      not exists(this.getPackage()) and pkg = ""
    ) and
    name = this.getName()
  }

  /** Gets the qualified name of this entity, if any. */
  string getQualifiedName() {
    exists(string pkg, string name | this.hasQualifiedName(pkg, name) |
      if pkg = "" then result = name else result = pkg + "." + name
    )
  }

  /**
   * Gets the scope in which this entity is declared, if any.
   *
   * Entities corresponding to fields and methods do not have a scope.
   */
  Scope getScope() { objectscopes(this, result) }

  /**
   * Gets the declaring identifier for this entity, if any.
   *
   * Note that type switch statements which declare a new variable in the guard
   * actually have a new variable (of the right type) implicitly declared at
   * the beginning of each case clause, and these do not have a syntactic
   * declaration.
   */
  Ident getDeclaration() { result.declares(this) }

  /** Gets a reference to this entity. */
  Name getAReference() { result.getTarget() = this }

  /** Gets the type of this entity. */
  Type getType() { objecttypes(this, result) }

  /** Gets a textual representation of this entity. */
  string toString() { result = this.getName() }

  private predicate hasRealLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    // take the location of the declaration if there is one
    this.getDeclaration().hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn) or
    any(CaseClause cc | this = cc.getImplicitlyDeclaredVariable())
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    // take the location of the declaration if there is one
    if this.hasRealLocationInfo(_, _, _, _, _)
    then this.hasRealLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    else (
      // otherwise fall back on dummy location
      filepath = "" and
      startline = 0 and
      startcolumn = 0 and
      endline = 0 and
      endcolumn = 0
    )
  }
}

/** A declared entity (that is, type, constant, variable or function). */
class DeclaredEntity extends Entity, @declobject {
  /** Gets the expression to which this entity is initialized, if any. */
  Expr getInit() {
    exists(ValueSpec spec, int i |
      spec.getNameExpr(i) = this.getDeclaration() and
      spec.getInit(i) = result
    )
  }
}

/** A built-in entity (that is, type, constant or function). */
class BuiltinEntity extends Entity, @builtinobject { }

/** An imported package. */
class PackageEntity extends Entity, @pkgobject { }

/** A built-in or declared named type. */
class TypeEntity extends Entity, @typeobject { }

/** A declared named type. */
class DeclaredType extends TypeEntity, DeclaredEntity, @decltypeobject {
  /** Gets the declaration specifier declaring this type. */
  TypeSpec getSpec() { result.getNameExpr() = this.getDeclaration() }
}

/** A built-in named type. */
class BuiltinType extends TypeEntity, BuiltinEntity, @builtintypeobject { }

/** A built-in or declared constant, variable, field, method or function. */
class ValueEntity extends Entity, @valueobject {
  /** Gets a data-flow node that reads the value of this entity. */
  Read getARead() { result.reads(this) }

  /** Gets a control-flow node that updates the value of this entity. */
  Write getAWrite() { result.writes(this, _) }
}

/** A built-in or declared constant. */
class Constant extends ValueEntity, @constobject { }

/** A declared constant. */
class DeclaredConstant extends Constant, DeclaredEntity, @declconstobject {
  /** Gets the declaration specifier declaring this constant. */
  ValueSpec getSpec() { result.getANameExpr() = this.getDeclaration() }
}

/** A built-in constant. */
class BuiltinConstant extends Constant, BuiltinEntity, @builtinconstobject { }

/**
 * A built-in or declared variable.
 *
 * Note that Go currently does not have any built-in variables, so this class is effectively
 * an alias for `DeclaredVariable`.
 */
class Variable extends ValueEntity, @varobject { }

/** A declared variable. */
class DeclaredVariable extends Variable, DeclaredEntity, @declvarobject {
  /** Gets the declaration specifier declaring this variable. */
  ValueSpec getSpec() { result.getANameExpr() = this.getDeclaration() }
}

/** A variable declared in a local scope (as opposed to a package scope or the universal scope). */
class LocalVariable extends DeclaredVariable {
  LocalVariable() { this.getScope() instanceof LocalScope }

  /** Gets the innermost function containing the scope of this variable, if any. */
  FuncDef getDeclaringFunction() {
    result = this.getScope().(LocalScope).getEnclosingFunctionScope().getFunction()
  }

  /** Holds if this variable is referenced inside a nested function. */
  predicate isCaptured() {
    this.getDeclaringFunction() != this.getAReference().getEnclosingFunction()
  }
}

/**
 * A (named) function parameter.
 *
 * Note that receiver variables are considered parameters.
 */
class Parameter extends DeclaredVariable {
  FuncDef f;
  int index;

  Parameter() {
    f.(MethodDecl).getReceiverDecl().getNameExpr() = this.getDeclaration() and
    index = -1
    or
    exists(FuncTypeExpr tp | tp = f.getTypeExpr() |
      this =
        rank[index + 1](DeclaredVariable parm, int j, int k |
          parm.getDeclaration() = tp.getParameterDecl(j).getNameExpr(k)
        |
          parm order by j, k
        )
    )
  }

  /** Gets the function to which this parameter belongs. */
  FuncDef getFunction() { result = f }

  /**
   * Gets the index of this parameter among all parameters of the function.
   *
   * The receiver is considered to have index -1.
   */
  int getIndex() { result = index }

  /** Holds if this is the `i`th parameter of function `fd`. */
  predicate isParameterOf(FuncDef fd, int i) { fd = f and i = index }
}

/** The receiver variable of a method. */
class ReceiverVariable extends Parameter {
  override MethodDecl f;

  ReceiverVariable() { index = -1 }

  /** Holds if this is the receiver variable of method `m`. */
  predicate isReceiverOf(MethodDecl m) { m = f }
}

/** A (named) function result variable. */
class ResultVariable extends DeclaredVariable {
  FuncDef f;
  int index;

  ResultVariable() {
    exists(FuncTypeExpr tp | tp = f.getTypeExpr() |
      this =
        rank[index + 1](DeclaredVariable parm, int j, int k |
          parm.getDeclaration() = tp.getResultDecl(j).getNameExpr(k)
        |
          parm order by j, k
        )
    )
  }

  /** Gets the function to which this result variable belongs. */
  FuncDef getFunction() { result = f }

  /** Gets the index of this result among all results of the function. */
  int getIndex() { result = index }

  /** Holds if this is the `i`th result of function `fd`. */
  predicate isResultOf(FuncDef fd, int i) { fd = f and i = index }
}

/**
 * A struct field.
 *
 * Note that field identity is determined by type identity: if two struct types are identical in
 * the sense of the Go language specification (https://golang.org/ref/spec#Type_identity), then
 * any of their fields that have the same name are also identical. This, in turn, means that a
 * field can have two or more declarations.
 *
 * For example, consider the following two type declarations:
 *
 * ```go
 * type T1 struct { x int }
 * type T2 struct { x int }
 * ```
 *
 * Types `T1` and `T2` are different, but their underlying struct types are identical. Hence
 * the two declarations of `x` refer to the same field.
 */
class Field extends Variable {
  StructType declaringType;

  Field() { fieldstructs(this, declaringType) }

  /** Gets the struct type declaring this field. */
  StructType getDeclaringType() { result = declaringType }

  override Package getPackage() {
    exists(Type tp | tp.getUnderlyingType() = declaringType | result = tp.getPackage())
  }

  /**
   * Holds if this field has name `f` and it belongs to a type with qualified name `tp`.
   *
   * Note that due to field embedding the same field may have multiple qualified names.
   */
  override predicate hasQualifiedName(string tp, string f) {
    exists(Type base |
      tp = base.getQualifiedName() and
      this = base.getField(f)
    )
  }

  /**
   * Holds if this field has name `f` and it belongs to a type  `tp` declared in package `pkg`.
   *
   * Note that due to field embedding the same field may belong to multiple types.
   */
  predicate hasQualifiedName(string pkg, string tp, string f) {
    exists(Type base |
      base.hasQualifiedName(pkg, tp) and
      this = base.getField(f)
    )
  }
}

/**
 * A field that belongs to a struct that may be embedded within another struct.
 *
 * When a selector addresses such a field, it is possible it is implicitly addressing a nested struct.
 */
class PromotedField extends Field {
  PromotedField() { this = any(StructType t).getFieldOfEmbedded(_, _, _, _) }
}

/** A built-in or declared function. */
class Function extends ValueEntity, @functionobject {
  /**
   * Gets a call to this function.
   *
   * This includes calls that target this function indirectly, by calling an
   * interface method that this function implements.
   */
  pragma[nomagic]
  DataFlow::CallNode getACall() { this = result.getACalleeIncludingExternals().asFunction() }

  /** Gets the declaration of this function, if any. */
  FuncDecl getFuncDecl() { none() }

  /** Holds if this function is variadic. */
  predicate isVariadic() { none() }

  /** Holds if this function has no observable side effects. */
  predicate mayHaveSideEffects() { none() }

  /**
   * Holds if this function may return without panicking, exiting the process, or looping forever.
   *
   * This predicate is an over-approximation: it may hold for functions that can never
   * return normally, but it never fails to hold for functions that can.
   *
   * Note this is declared here and not in `DeclaredFunction` so that library models can override this
   * by extending `Function` rather than having to remember to extend `DeclaredFunction`.
   */
  predicate mayReturnNormally() {
    not this.mustPanic() and
    (ControlFlow::mayReturnNormally(this.getFuncDecl()) or not exists(this.getBody()))
  }

  /**
   * Holds if calling this function may cause a runtime panic.
   *
   * This predicate is an over-approximation: it may hold for functions that can never
   * cause a runtime panic, but it never fails to hold for functions that can.
   */
  predicate mayPanic() { any() }

  /**
   * Holds if calling this function always causes a runtime panic.
   *
   * This predicate is an over-approximation: it may not hold for functions that do
   * cause a runtime panic, but it never holds for functions that do not.
   */
  predicate mustPanic() { none() }

  /** Gets the number of parameters of this function. */
  int getNumParameter() { result = this.getType().(SignatureType).getNumParameter() }

  /** Gets the type of the `i`th parameter of this function. */
  Type getParameterType(int i) { result = this.getType().(SignatureType).getParameterType(i) }

  /** Gets the number of results of this function. */
  int getNumResult() { result = this.getType().(SignatureType).getNumResult() }

  /** Gets the type of the `i`th result of this function. */
  Type getResultType(int i) { result = this.getType().(SignatureType).getResultType(i) }

  /** Gets the body of this function, if any. */
  BlockStmt getBody() { result = this.getFuncDecl().getBody() }

  /** Gets the `i`th parameter of this function. */
  Parameter getParameter(int i) { result.isParameterOf(this.getFuncDecl(), i) }

  /** Gets a parameter of this function. */
  Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the `i`th reslt variable of this function. */
  ResultVariable getResult(int i) { result.isResultOf(this.getFuncDecl(), i) }

  /** Gets a result variable of this function. */
  ResultVariable getAResult() { result = this.getResult(_) }
}

/**
 * A method, that is, a function with a receiver variable, or a function declared in an interface.
 *
 * Note that method identity is determined by receiver type identity: if two methods have the same
 * name and their receiver types are identical in the sense of the Go language specification
 * (https://golang.org/ref/spec#Type_identity), then the two methods are identical as well.
 */
class Method extends Function {
  Variable receiver;

  Method() { methodreceivers(this, receiver) }

  override Package getPackage() {
    // a method doesn't have a scope, so manually associate it with its receiver's
    // package.
    result = this.getReceiverType().getPackage()
  }

  /** Holds if this method is declared in an interface. */
  predicate isInterfaceMethod() {
    this.getReceiverType().getUnderlyingType() instanceof InterfaceType
  }

  /** Gets the receiver variable of this method. */
  Variable getReceiver() { result = receiver }

  /** Gets the type of the receiver variable of this method. */
  Type getReceiverType() { result = receiver.getType() }

  /**
   * Gets the receiver base type of this method, that is, either the base type of the receiver type
   * if it is a pointer type, or the receiver type itself if it is not a pointer type.
   */
  Type getReceiverBaseType() {
    exists(Type recv | recv = this.getReceiverType() |
      if recv instanceof PointerType
      then result = recv.(PointerType).getBaseType()
      else result = recv
    )
  }

  /** Holds if this method has name `m` and belongs to the method set of type `tp` or `*tp`. */
  private predicate isIn(NamedType tp, string m) {
    this = tp.getMethod(m) or
    this = tp.getPointerType().getMethod(m)
  }

  /**
   * Holds if this method has name `m` and belongs to the method set of a type `T` or `*T` where
   * `T` has qualified name `tp`.
   *
   * Note that `meth.hasQualifiedName(tp, m)` is almost, but not quite, equivalent to
   * `exists(Type t | tp = t.getQualifiedName() and meth = t.getMethod(m))`: the latter
   * distinguishes between the method sets of `T` and `*T`, while the former does not.
   */
  override predicate hasQualifiedName(string tp, string m) {
    exists(NamedType t |
      this.isIn(t, m) and
      tp = t.getQualifiedName()
    )
  }

  /**
   * Holds if this method has name `m` and belongs to the method set of a type `T` or `*T` where
   * `T` is declared in package `pkg` and has name `tp`.
   *
   * Note that `meth.hasQualifiedName(pkg, tp, m)` is almost, but not quite, equivalent to
   * `exists(Type t | t.hasQualifiedName(pkg, tp) and meth = t.getMethod(m))`: the latter
   * distinguishes between the method sets of `T` and `*T`, while the former does not.
   */
  pragma[nomagic]
  predicate hasQualifiedName(string pkg, string tp, string m) {
    exists(NamedType t |
      this.isIn(t, m) and
      t.hasQualifiedName(pkg, tp)
    )
  }

  /**
   * Holds if this method implements the method `m`, that is, if `m` is a method
   * on an interface, and this is a method with the same name on a type that
   * implements that interface.
   *
   * Note that all methods implement themselves, and interface methods _only_
   * implement themselves.
   */
  predicate implements(Method m) {
    if this.isInterfaceMethod() then this = m else this.implementsIncludingInterfaceMethods(m)
  }

  /**
   * Holds if this method implements the method `m`, that is, if `m` is a method
   * on an interface, and this is a method with the same name on a type that
   * implements that interface.
   *
   * Note that all methods implement themselves, and that unlike the predicate `implements`
   * this does allow interface methods to implement other interfaces.
   */
  predicate implementsIncludingInterfaceMethods(Method m) {
    this = m
    or
    exists(Type t |
      this = t.getMethod(m.getName()) and
      t.implements(m.getReceiverType().getUnderlyingType())
    )
  }

  /**
   * Holds if this method implements the method that has qualified name `pkg.tp.name`, that is, if
   * `pkg.tp.name` is a method on an interface, and this is a method with the same name on a type
   * that implements that interface.
   */
  predicate implements(string pkg, string tp, string name) {
    exists(Method m | m.hasQualifiedName(pkg, tp, name) | this.implements(m))
  }
}

/**
 * A method whose receiver may be embedded within a struct.
 *
 * When a selector addresses such a method, it is possible it is implicitly addressing a nested struct.
 */
class PromotedMethod extends Method {
  PromotedMethod() { this = any(StructType t).getMethodOfEmbedded(_, _, _) }
}

/** A declared function. */
class DeclaredFunction extends Function, DeclaredEntity, @declfunctionobject {
  override FuncDecl getFuncDecl() { result.getNameExpr() = this.getDeclaration() }

  override predicate mayHaveSideEffects() {
    not exists(this.getBody())
    or
    exists(BlockStmt body | body = this.getBody() |
      body.mayHaveSideEffects()
      or
      // functions declared in files with build constraints may be defined differently
      // for different platforms, so allow them to avoid false positives
      body.getFile().hasBuildConstraints()
    )
  }

  override predicate isVariadic() { this.getType().(SignatureType).isVariadic() }
}

/** A built-in function. */
class BuiltinFunction extends Function, BuiltinEntity, @builtinfunctionobject {
  override predicate mayHaveSideEffects() { builtinFunction(this.getName(), false, _, _, _) }

  override predicate mayPanic() { builtinFunction(this.getName(), _, true, _, _) }

  override predicate mustPanic() { builtinFunction(this.getName(), _, _, true, _) }

  override predicate isVariadic() { builtinFunction(this.getName(), _, _, _, true) }

  /**
   * Holds if this function is pure, that is, it has no observable side effects and
   * no non-determinism.
   */
  predicate isPure() { not this.mayHaveSideEffects() }
}

private newtype TCallable =
  TFunctionCallable(Function f) or
  TFuncLitCallable(FuncLit l)

/**
 * A `Function` or a `FuncLit`. We do it this way because of limitations of both
 * `Function` and `FuncDef`:
 *   - `Function` is an entity, and therefore does not include function literals, and
 *   - `FuncDef` is an AST node, and so is not extracted for functions from external libraries.
 */
class Callable extends TCallable {
  /** Gets a textual representation of this callable. */
  string toString() { result = [this.asFunction().toString(), this.asFuncLit().toString()] }

  /** Gets this callable as a function, if it is one. */
  Function asFunction() { this = TFunctionCallable(result) }

  /** Gets this callable as a function literal, if it is one. */
  FuncLit asFuncLit() { this = TFuncLitCallable(result) }

  /** Gets this function's definition, if it exists. */
  FuncDef getFuncDef() { result = [this.asFuncLit().(FuncDef), this.asFunction().getFuncDecl()] }

  /** Gets the type of this callable. */
  SignatureType getType() {
    result = this.asFunction().getType() or
    result = this.asFuncLit().getType()
  }

  /** Gets the name of this callable. */
  string getName() {
    result = this.asFunction().getName() or
    result = this.asFuncLit().getName()
  }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `sc` of line `sl` to
   * column `ec` of line `el` in file `fp`.
   * For more information, see
   * [Locations](https://codeql.github.com/docs/writing-codeql-queries/providing-locations-in-codeql-queries/).
   */
  predicate hasLocationInfo(string fp, int sl, int sc, int el, int ec) {
    this.asFunction().hasLocationInfo(fp, sl, sc, el, ec) or
    this.asFuncLit().hasLocationInfo(fp, sl, sc, el, ec)
  }
}

/** A statement label. */
class Label extends Entity, @labelobject { }

/**
 * Holds if `name` is a built-in function, where
 *
 *   - `pure` is true if the function has no observable side effects, and false otherwise;
 *   - `mayPanic` is true if calling this function may cause a panic, and false otherwise;
 *   - `mustPanic` is true if calling this function always causes a panic, and false otherwise;
 *   - `variadic` is true if this function is variadic, and false otherwise.
 *
 * Allocating memory is not considered an observable side effect.
 */
private predicate builtinFunction(
  string name, boolean pure, boolean mayPanic, boolean mustPanic, boolean variadic
) {
  name = "append" and pure = false and mayPanic = false and mustPanic = false and variadic = true
  or
  name = "cap" and pure = true and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "clear" and pure = false and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "close" and pure = false and mayPanic = true and mustPanic = false and variadic = false
  or
  name = "complex" and pure = true and mayPanic = true and mustPanic = false and variadic = false
  or
  name = "copy" and pure = false and mayPanic = true and mustPanic = false and variadic = false
  or
  name = "delete" and pure = false and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "imag" and pure = true and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "len" and pure = true and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "make" and pure = true and mayPanic = true and mustPanic = false and variadic = true
  or
  name = "max" and pure = true and mayPanic = false and mustPanic = false and variadic = true
  or
  name = "min" and pure = true and mayPanic = false and mustPanic = false and variadic = true
  or
  name = "new" and pure = true and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "panic" and pure = false and mayPanic = true and mustPanic = true and variadic = false
  or
  name = "print" and pure = false and mayPanic = false and mustPanic = false and variadic = true
  or
  name = "println" and pure = false and mayPanic = false and mustPanic = false and variadic = true
  or
  name = "real" and pure = true and mayPanic = false and mustPanic = false and variadic = false
  or
  name = "recover" and pure = false and mayPanic = false and mustPanic = false and variadic = false
}

/** Provides helper predicates for working with built-in objects from the universe scope. */
module Builtin {
  // built-in types
  /** Gets the built-in type `bool`. */
  BuiltinType bool() { result.getName() = "bool" }

  /** Gets the built-in type `byte`. */
  BuiltinType byte() { result.getName() = "byte" }

  /** Gets the built-in type `complex64`. */
  BuiltinType complex64() { result.getName() = "complex64" }

  /** Gets the built-in type `complex128`. */
  BuiltinType complex128() { result.getName() = "complex128" }

  /** Gets the built-in type `error`. */
  BuiltinType error() { result.getName() = "error" }

  /** Gets the built-in type `float32`. */
  BuiltinType float32() { result.getName() = "float32" }

  /** Gets the built-in type `float64`. */
  BuiltinType float64() { result.getName() = "float64" }

  /** Gets the built-in type `int`. */
  BuiltinType int_() { result.getName() = "int" }

  /** Gets the built-in type `int8`. */
  BuiltinType int8() { result.getName() = "int8" }

  /** Gets the built-in type `int16`. */
  BuiltinType int16() { result.getName() = "int16" }

  /** Gets the built-in type `int32`. */
  BuiltinType int32() { result.getName() = "int32" }

  /** Gets the built-in type `int64`. */
  BuiltinType int64() { result.getName() = "int64" }

  /** Gets the built-in type `rune`. */
  BuiltinType rune() { result.getName() = "rune" }

  /** Gets the built-in type `string`. */
  BuiltinType string_() { result.getName() = "string" }

  /** Gets the built-in type `uint`. */
  BuiltinType uint() { result.getName() = "uint" }

  /** Gets the built-in type `uint8`. */
  BuiltinType uint8() { result.getName() = "uint8" }

  /** Gets the built-in type `uint16`. */
  BuiltinType uint16() { result.getName() = "uint16" }

  /** Gets the built-in type `uint32`. */
  BuiltinType uint32() { result.getName() = "uint32" }

  /** Gets the built-in type `uint64`. */
  BuiltinType uint64() { result.getName() = "uint64" }

  /** Gets the built-in type `uintptr`. */
  BuiltinType uintptr() { result.getName() = "uintptr" }

  // built-in constants
  /** Gets the built-in constant `true`. */
  BuiltinConstant true_() { result.getName() = "true" }

  /** Gets the built-in constant `false`. */
  BuiltinConstant false_() { result.getName() = "false" }

  /** Gets the built-in constant corresponding to `b`. */
  BuiltinConstant bool(boolean b) {
    b = true and result = true_()
    or
    b = false and result = false_()
  }

  /** Gets the built-in constant `iota`. */
  BuiltinConstant iota() { result.getName() = "iota" }

  // built-in zero value
  /** Gets the built-in zero-value `nil`. */
  BuiltinConstant nil() { result.getName() = "nil" }

  /** Gets the built-in function `append`. */
  BuiltinFunction append() { result.getName() = "append" }

  /** Gets the built-in function `cap`. */
  BuiltinFunction cap() { result.getName() = "cap" }

  /** Gets the built-in function `clear`. */
  BuiltinFunction clear() { result.getName() = "clear" }

  /** Gets the built-in function `close`. */
  BuiltinFunction close() { result.getName() = "close" }

  /** Gets the built-in function `complex`. */
  BuiltinFunction complex() { result.getName() = "complex" }

  /** Gets the built-in function `copy`. */
  BuiltinFunction copy() { result.getName() = "copy" }

  /** Gets the built-in function `delete`. */
  BuiltinFunction delete() { result.getName() = "delete" }

  /** Gets the built-in function `imag`. */
  BuiltinFunction imag() { result.getName() = "imag" }

  /** Gets the built-in function `len`. */
  BuiltinFunction len() { result.getName() = "len" }

  /** Gets the built-in function `make`. */
  BuiltinFunction make() { result.getName() = "make" }

  /** Gets the built-in function `max`. */
  BuiltinFunction max_() { result.getName() = "max" }

  /** Gets the built-in function `min`. */
  BuiltinFunction min_() { result.getName() = "min" }

  /** Gets the built-in function `new`. */
  BuiltinFunction new() { result.getName() = "new" }

  /** Gets the built-in function `panic`. */
  BuiltinFunction panic() { result.getName() = "panic" }

  /** Gets the built-in function `print`. */
  BuiltinFunction print() { result.getName() = "print" }

  /** Gets the built-in function `println`. */
  BuiltinFunction println() { result.getName() = "println" }

  /** Gets the built-in function `real`. */
  BuiltinFunction real() { result.getName() = "real" }

  /** Gets the built-in function `recover`. */
  BuiltinFunction recover() { result.getName() = "recover" }
}
