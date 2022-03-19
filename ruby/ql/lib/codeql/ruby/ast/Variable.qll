/** Provides classes for modeling program variables. */

private import codeql.ruby.AST
private import codeql.Locations
private import internal.AST
private import internal.TreeSitter
private import internal.Variable
private import internal.Parameter

/** A variable declared in a scope. */
class Variable instanceof VariableImpl {
  /** Gets the name of this variable. */
  final string getName() { result = super.getNameImpl() }

  /** Holds if the name of this variable is `name`. */
  final predicate hasName(string name) { this.getName() = name }

  /** Gets a textual representation of this variable. */
  final string toString() { result = this.getName() }

  /** Gets the location of this variable. */
  final Location getLocation() { result = super.getLocationImpl() }

  /** Gets the scope this variable is declared in. */
  final Scope getDeclaringScope() {
    toGenerated(result) = this.(VariableReal).getDeclaringScopeImpl()
  }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A local variable. */
class LocalVariable extends Variable, TLocalVariable {
  override LocalVariableAccess getAnAccess() { result.getVariable() = this }

  /** Gets the access where this local variable is first introduced. */
  VariableAccess getDefiningAccess() {
    result = this.(LocalVariableReal).getDefiningAccessImpl() or
    synthChild(any(BlockParameter p | this = p.getVariable()), 0, result)
  }

  /**
   * Holds if this variable is captured. For example in
   *
   * ```rb
   * def m x
   *   x.times do |y|
   *     puts x
   *   end
   *   puts x
   * end
   * ```
   *
   * `x` is a captured variable, whereas `y` is not.
   */
  final predicate isCaptured() { this.getAnAccess().isCapturedAccess() }
}

/** A global variable. */
class GlobalVariable extends Variable instanceof GlobalVariableImpl {
  final override GlobalVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An instance variable. */
class InstanceVariable extends Variable instanceof InstanceVariableImpl {
  /** Holds is this variable is a class instance variable. */
  final predicate isClassInstanceVariable() { super.isClassInstanceVariable() }

  final override InstanceVariableAccess getAnAccess() { result.getVariable() = this }
}

/** A class variable. */
class ClassVariable extends Variable instanceof ClassVariableImpl {
  final override ClassVariableAccess getAnAccess() { result.getVariable() = this }
}

/** A `self` variable. */
class SelfVariable extends LocalVariable instanceof SelfVariableImpl { }

/** An access to a variable. */
class VariableAccess extends Expr instanceof VariableAccessImpl {
  /** Gets the variable this identifier refers to. */
  final Variable getVariable() { result = super.getVariableImpl() }

  /**
   * Holds if this access is a write access belonging to the explicit
   * assignment `assignment`. For example, in
   *
   * ```rb
   * a, b = foo
   * ```
   *
   * both `a` and `b` are write accesses belonging to the same assignment.
   */
  predicate isExplicitWrite(AstNode assignment) {
    explicitWriteAccess(toGenerated(this), toGenerated(assignment))
    or
    this = assignment.(AssignExpr).getLeftOperand()
  }

  /**
   * Holds if this access is a write access belonging to an implicit assignment.
   * For example, in
   *
   * ```rb
   * def m elements
   *   for e in elements do
   *     puts e
   *   end
   * end
   * ```
   *
   * the access to `elements` in the parameter list is an implicit assignment,
   * as is the first access to `e`.
   */
  predicate isImplicitWrite() {
    implicitWriteAccess(toGenerated(this))
    or
    this = any(SimpleParameterSynthImpl p).getDefininingAccess()
    or
    this = any(HashPattern p).getValue(_)
    or
    synthChild(any(BlockParameter p), 0, this)
  }

  final override string toString() { result = VariableAccessImpl.super.toString() }
}

/** An access to a variable where the value is updated. */
class VariableWriteAccess extends VariableAccess {
  VariableWriteAccess() {
    this.isExplicitWrite(_) or
    this.isImplicitWrite()
  }
}

/** An access to a variable where the value is read. */
class VariableReadAccess extends VariableAccess {
  VariableReadAccess() { not this instanceof VariableWriteAccess }
}

/** An access to a local variable. */
class LocalVariableAccess extends VariableAccess instanceof LocalVariableAccessImpl {
  override string getAPrimaryQlClass() { result = "LocalVariableAccess" }

  /**
   * Holds if this access is a captured variable access. For example in
   *
   * ```rb
   * def m x
   *   x.times do |y|
   *     puts x
   *   end
   *   puts x
   * end
   * ```
   *
   * the access to `x` in the first `puts x` is a captured access, while
   * the access to `x` in the second `puts x` is not.
   */
  final predicate isCapturedAccess() { isCapturedAccess(this) }
}

/** An access to a local variable where the value is updated. */
class LocalVariableWriteAccess extends LocalVariableAccess, VariableWriteAccess { }

/** An access to a local variable where the value is read. */
class LocalVariableReadAccess extends LocalVariableAccess, VariableReadAccess { }

/** An access to a global variable. */
class GlobalVariableAccess extends VariableAccess instanceof GlobalVariableAccessImpl {
  final override string getAPrimaryQlClass() { result = "GlobalVariableAccess" }
}

/** An access to a global variable where the value is updated. */
class GlobalVariableWriteAccess extends GlobalVariableAccess, VariableWriteAccess { }

/** An access to a global variable where the value is read. */
class GlobalVariableReadAccess extends GlobalVariableAccess, VariableReadAccess { }

/** An access to an instance variable. */
class InstanceVariableAccess extends VariableAccess instanceof InstanceVariableAccessImpl {
  final override string getAPrimaryQlClass() { result = "InstanceVariableAccess" }
}

/** An access to an instance variable where the value is updated. */
class InstanceVariableWriteAccess extends InstanceVariableAccess, VariableWriteAccess { }

/** An access to an instance variable where the value is read. */
class InstanceVariableReadAccess extends InstanceVariableAccess, VariableReadAccess { }

/** An access to a class variable. */
class ClassVariableAccess extends VariableAccess instanceof ClassVariableAccessRealImpl {
  final override string getAPrimaryQlClass() { result = "ClassVariableAccess" }
}

/** An access to a class variable where the value is updated. */
class ClassVariableWriteAccess extends ClassVariableAccess, VariableWriteAccess { }

/** An access to a class variable where the value is read. */
class ClassVariableReadAccess extends ClassVariableAccess, VariableReadAccess { }

/**
 * An access to the `self` variable. For example:
 * - `self == other`
 * - `self.method_name`
 * - `def self.method_name ... end`
 *
 * This also includes implicit references to the current object in method
 * calls.  For example, the method call `foo(123)` has an implicit `self`
 * receiver, and is equivalent to the explicit `self.foo(123)`.
 */
class SelfVariableAccess extends LocalVariableAccess instanceof SelfVariableAccessImpl {
  final override string getAPrimaryQlClass() { result = "SelfVariableAccess" }
}

/** An access to the `self` variable where the value is read. */
class SelfVariableReadAccess extends SelfVariableAccess, VariableReadAccess { }
