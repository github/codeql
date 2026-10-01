/**
 * Provides logic for synthesizing callables and parameters.
 */

private import unified
private import CallableExPlugin
private import NameBinding

private predicate mayHaveImplicitConstructor(ClassLikeDeclaration cls, string name) {
  mayHaveConstructor(cls, name) and
  forall(ConstructorDeclaration c | c = cls.getAMember() | not constructorPreventsImplicit(c))
}

private predicate mayInheritConstructorFrom(ClassLikeDeclaration cls, ClassLikeDeclaration base) {
  mayInheritConstructor(cls) and
  mayHaveImplicitConstructor(cls, _) and
  base.getNameNode() = getStaticBindingTargetFromRef(cls.getABaseType().getType()) and
  mayHaveConstructor(base, _)
}

private newtype TCallableEx =
  TAstCallableEx(Callable c) or
  TDefaultConstructor(ClassLikeDeclaration cls, string name) {
    mayHaveImplicitConstructor(cls, name) and
    forall(ClassLikeDeclaration base | mayInheritConstructorFrom(cls, base) |
      not mayHaveConstructor(cls, _)
    )
  }

private newtype TParameterEx =
  TAstParameter(Parameter p) or
  TImplicitReceiverParameter(Callable c) {
    exists(LocalVariable v | v.isImplicitReceiverParameter(c))
  } or
  TDefaultConstructorParameter(ClassLikeDeclaration cls, int i, string name) {
    defaultConstructorParameter(cls, i, name)
  }

final class CallableEx = CallableExImpl;

/**
 * A callable from source code or a synthesized callable.
 */
abstract private class CallableExImpl extends TCallableEx {
  /**
   * Gets the source code callable that this entity represents, if any.
   */
  Callable asCallable() { this = TAstCallableEx(result) }

  /**
   * Holds if this entity represents a default constructor for `cls`, for example a
   * parameterless Swift `class` constructor or a Swift `struct` constructor
   * with parameters for relevant fields.
   */
  predicate isDefaultConstructor(ClassLikeDeclaration cls) { this = TDefaultConstructor(cls, _) }

  /**
   * Holds if this entity represents a constructor for `cls`.
   */
  predicate isConstructor(ClassLikeDeclaration cls, boolean inheritable) {
    exists(ConstructorDeclaration c |
      c = this.asCallable() and
      c = cls.getAMember() and
      if isInheritableMember(c) then inheritable = true else inheritable = false
    )
    or
    this.isDefaultConstructor(cls) and inheritable = true
  }

  /**
   * Holds if this entity is a direct member of `cls`.
   */
  predicate isMemberOf(ClassLikeDeclaration cls) {
    this.asCallable() = cls.getAMember()
    or
    this.isConstructor(cls, _)
  }

  /** Gets the `i`-th type parameter of this callable. */
  abstract TypeParameter getTypeParameter(int i);

  /**
   * Gets the `i`-th parameter of this callable. Implicit receiver parameters are
   * at index `0`, and all other parameters start at index `1`.
   */
  abstract ParameterEx getParameter(int i);

  /** Gets a parameter of this callable. */
  final ParameterEx getAParameter() { result = this.getParameter(_) }

  /** Gets the declared return type of this callable, if any. */
  abstract Expr getReturnType();

  /** Gets the body of this callable, if any. */
  abstract AstNode getBody();

  /** Gets the name node of this callable, if any. */
  abstract Identifier getNameNode();

  /** Gets the name of this callable. */
  abstract string getName();

  /** Gets a textual representation of this callable. */
  abstract string toString();

  /** Gets the location of this callable. */
  abstract Location getLocation();
}

private class AstCallableEx extends CallableExImpl, TAstCallableEx {
  Callable c;

  AstCallableEx() { this = TAstCallableEx(c) }

  override TypeParameter getTypeParameter(int i) {
    result = c.(FunctionDeclaration).getTypeParameter(i)
  }

  override ParameterEx getParameter(int i) {
    result.isImplicitReceiverParameter(c) and
    i = 0
    or
    exists(int j, Parameter p |
      result.asParameter() = p and
      i = j + 1
    |
      p = c.(FunctionDeclaration).getParameter(j)
      or
      p = c.(ConstructorDeclaration).getParameter(j)
      or
      p = c.(FunctionExpr).getParameter(j)
      or
      p = c.(AccessorDeclaration).getParameter(j)
    )
  }

  override Expr getReturnType() {
    result = c.(FunctionDeclaration).getReturnType()
    or
    result = c.(FunctionExpr).getReturnType()
  }

  override AstNode getBody() { result = c.getBody() }

  override Identifier getNameNode() {
    result = c.(AccessorDeclaration).getNameNode()
    or
    result = c.(ConstructorDeclaration).getNameNode()
    or
    result = c.(FunctionDeclaration).getNameNode()
  }

  override string getName() {
    result = this.getNameNode().getValue()
    or
    c instanceof DestructorDeclaration and
    result = "<destructor>"
    or
    c instanceof InitializerDeclaration and
    result = "<initializer>"
  }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }
}

private class DefaultConstructor extends CallableExImpl, TDefaultConstructor {
  ClassLikeDeclaration c;
  string name;

  DefaultConstructor() { this = TDefaultConstructor(c, name) }

  override TypeParameter getTypeParameter(int i) { none() }

  override ParameterEx getParameter(int i) { result = TDefaultConstructorParameter(c, i, _) }

  override Expr getReturnType() { none() }

  override AstNode getBody() { none() }

  override Identifier getNameNode() { none() }

  override string getName() { result = name }

  override string toString() { result = c.getName() + " [default constructor]" }

  override Location getLocation() { result = c.getLocation() }
}

final class ParameterEx = ParameterExImpl;

/**
 * A parameter from source code or a synthesized parameter.
 */
abstract private class ParameterExImpl extends TParameterEx {
  /**
   * Gets the source code parameter that this entity represents, if any.
   */
  Parameter asParameter() { this = TAstParameter(result) }

  /**
   * Holds if this entity represents a regular parameter from source code.
   */
  predicate isParameter() { exists(this.asParameter()) }

  /**
   * Holds if this entity represents an implicit receiver parameter of `c`.
   */
  predicate isImplicitReceiverParameter(Callable c) { this = TImplicitReceiverParameter(c) }

  /**
   * Holds if this entity represents the `i`th parameter of the default
   * constructor of `cls` with name `name`.
   */
  predicate isDefaultConstructorParameter(ClassLikeDeclaration cls, int i, string name) {
    this = TDefaultConstructorParameter(cls, i, name)
  }

  /** Gets the callable that this parameter belongs to. */
  CallableEx getCallable() { this = result.getAParameter() }

  /** Gets a textual representation of this parameter. */
  abstract string toString();

  /** Gets the location of this parameter. */
  abstract Location getLocation();
}

private class AstParameterEx extends ParameterExImpl, TAstParameter {
  Parameter p;

  AstParameterEx() { this = TAstParameter(p) }

  override string toString() { result = p.toString() }

  override Location getLocation() { result = p.getLocation() }
}

private class ImplicitReceiverParameterEx extends ParameterExImpl, TImplicitReceiverParameter {
  Callable c;

  ImplicitReceiverParameterEx() { this = TImplicitReceiverParameter(c) }

  override string toString() {
    exists(LocalVariable v |
      v.isImplicitReceiverParameter(c) and
      result = v.getName()
    )
  }

  override Location getLocation() { result = c.getLocation() }
}

private class DefaultConstructorParameterEx extends ParameterExImpl, TDefaultConstructorParameter {
  ClassLikeDeclaration c;
  int i;
  string name;

  DefaultConstructorParameterEx() { this = TDefaultConstructorParameter(c, i, name) }

  override string toString() { result = name + " [" + c.getName() + " default constructor]" }

  override Location getLocation() { result = c.getLocation() }
}
