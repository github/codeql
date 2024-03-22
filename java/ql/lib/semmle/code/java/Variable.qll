/**
 * Provides classes and predicates for working with Java variables and their declarations.
 */

import Element

/** A variable is a field, a local variable or a parameter. */
class Variable extends @variable, Annotatable, Element, Modifiable {
  /** Gets the type of this variable. */
  /*abstract*/ Type getType() { none() }

  /** Gets the Kotlin type of this variable. */
  /*abstract*/ KotlinType getKotlinType() { none() }

  /** Gets an access to this variable. */
  VarAccess getAnAccess() { variableBinding(result, this) }

  /**
   * Gets an expression assigned to this variable, either appearing on the right-hand side of an
   * assignment or bound to it via a binding `instanceof` expression or `switch` block.
   */
  Expr getAnAssignedValue() {
    exists(LocalVariableDeclExpr e | e.getVariable() = this and result = e.getInitOrPatternSource())
    or
    exists(AssignExpr e | e.getDest() = this.getAnAccess() and result = e.getSource())
  }

  /** Gets the initializer expression of this variable. */
  Expr getInitializer() { none() }

  /** Gets a printable representation of this variable together with its type. */
  string pp() { result = this.getType().getName() + " " + this.getName() }
}

/** A locally scoped variable, that is, either a local variable or a parameter. */
class LocalScopeVariable extends Variable, @localscopevariable {
  /** Gets the callable in which this variable is declared. */
  abstract Callable getCallable();
}

/** A local variable declaration */
class LocalVariableDecl extends @localvar, LocalScopeVariable {
  /** Gets the type of this local variable. */
  override Type getType() { localvars(this, _, result, _) }

  /** Gets the Kotlin type of this local variable. */
  override KotlinType getKotlinType() { localvarsKotlinType(this, result) }

  /** Gets the expression declaring this variable. */
  LocalVariableDeclExpr getDeclExpr() { localvars(this, _, _, result) }

  /** Gets the parent of this declaration. */
  Expr getParent() { localvars(this, _, _, result) }

  /** Gets the callable in which this declaration occurs. */
  override Callable getCallable() { result = this.getParent().getEnclosingCallable() }

  /** Gets the callable in which this declaration occurs. */
  Callable getEnclosingCallable() { result = this.getCallable() }

  override string toString() {
    exists(string sourceName |
      if this.getName() = "" then sourceName = "_" else sourceName = this.getName()
    |
      result = this.getType().getName() + " " + sourceName
    )
  }

  /** Gets the initializer expression of this local variable declaration. */
  override Expr getInitializer() { result = this.getDeclExpr().getInit() }

  override string getAPrimaryQlClass() { result = "LocalVariableDecl" }
}

/** A formal parameter of a callable. */
class Parameter extends Element, @param, LocalScopeVariable {
  /** Gets the type of this formal parameter. */
  override Type getType() { params(this, result, _, _, _) }

  /** Gets the Kotlin type of this formal parameter. */
  override KotlinType getKotlinType() { paramsKotlinType(this, result) }

  /** Holds if the parameter is never assigned a value in the body of the callable. */
  predicate isEffectivelyFinal() { not exists(this.getAnAssignedValue()) }

  /** Gets the (zero-based) index of this formal parameter. */
  int getPosition() { params(this, _, result, _, _) }

  /** Gets the callable that declares this formal parameter. */
  override Callable getCallable() { params(this, _, _, result, _) }

  /** Gets the source declaration of this formal parameter. */
  Parameter getSourceDeclaration() { params(this, _, _, _, result) }

  /** Holds if this formal parameter is the same as its source declaration. */
  predicate isSourceDeclaration() { this.getSourceDeclaration() = this }

  /** Holds if this formal parameter is a variable arity parameter. */
  predicate isVarargs() { isVarargsParam(this) }

  /** Holds if this formal parameter is a parameter representing the dispatch receiver in an extension method. */
  predicate isExtensionParameter() {
    this.getPosition() = this.getCallable().(ExtensionMethod).getExtensionReceiverParameterIndex()
  }

  /**
   * Gets an argument for this parameter in any call to the callable that declares this formal
   * parameter.
   *
   * Varargs parameters will have no results for this method.
   */
  Expr getAnArgument() {
    not this.isVarargs() and
    result = this.getACallArgument(this.getPosition())
  }

  pragma[noinline]
  private Expr getACallArgument(int i) {
    exists(Call call |
      result = call.getArgument(i) and
      call.getCallee().getSourceDeclaration().getAParameter() = this
    )
  }

  override string getAPrimaryQlClass() { result = "Parameter" }

  override string toString() {
    if this.getName() = "" then result = "<anonymous parameter>" else result = super.toString()
  }

  /** Holds if this is an anonymous parameter, `_` */
  predicate isAnonymous() { this.getName() = "" }
}
