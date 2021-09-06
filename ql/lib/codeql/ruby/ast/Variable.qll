/** Provides classes for modeling program variables. */

private import codeql.ruby.AST
private import codeql.Locations
private import internal.AST
private import internal.TreeSitter
private import internal.Variable

/** A variable declared in a scope. */
class Variable extends TVariable {
  /** Gets the name of this variable. */
  string getName() { none() }

  /** Holds if the name of this variable is `name`. */
  final predicate hasName(string name) { this.getName() = name }

  /** Gets a textual representation of this variable. */
  final string toString() { result = this.getName() }

  /** Gets the location of this variable. */
  Location getLocation() { none() }

  /** Gets the scope this variable is declared in. */
  Scope getDeclaringScope() { none() }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A local variable. */
class LocalVariable extends Variable, TLocalVariable {
  override LocalVariableAccess getAnAccess() { none() }

  /** Gets the access where this local variable is first introduced. */
  VariableAccess getDefiningAccess() { none() }

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
  predicate isCaptured() { this.getAnAccess().isCapturedAccess() }
}

/** A global variable. */
class GlobalVariable extends VariableReal, TGlobalVariable instanceof GlobalVariable::Range {
  final override GlobalVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An instance variable. */
class InstanceVariable extends VariableReal, TInstanceVariable instanceof InstanceVariable::Range {
  /** Holds is this variable is a class instance variable. */
  final predicate isClassInstanceVariable() { super.isClassInstanceVariable() }

  final override InstanceVariableAccess getAnAccess() { result.getVariable() = this }
}

/** A class variable. */
class ClassVariable extends VariableReal, TClassVariable instanceof ClassVariable::Range {
  final override ClassVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An access to a variable. */
class VariableAccess extends Expr, TVariableAccess {
  /** Gets the variable this identifier refers to. */
  final Variable getVariable() { result = this.(VariableAccessImpl).getVariableImpl() }

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
  predicate isImplicitWrite() { implicitWriteAccess(toGenerated(this)) }
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
class LocalVariableAccess extends VariableAccess, TLocalVariableAccess {
  final override string getAPrimaryQlClass() { result = "LocalVariableAccess" }

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
class GlobalVariableAccess extends VariableAccess, TGlobalVariableAccess {
  final override string getAPrimaryQlClass() { result = "GlobalVariableAccess" }
}

/** An access to a global variable where the value is updated. */
class GlobalVariableWriteAccess extends GlobalVariableAccess, VariableWriteAccess { }

/** An access to a global variable where the value is read. */
class GlobalVariableReadAccess extends GlobalVariableAccess, VariableReadAccess { }

/** An access to an instance variable. */
class InstanceVariableAccess extends VariableAccess, TInstanceVariableAccess {
  final override string getAPrimaryQlClass() { result = "InstanceVariableAccess" }
}

/** An access to an instance variable where the value is updated. */
class InstanceVariableWriteAccess extends InstanceVariableAccess, VariableWriteAccess { }

/** An access to an instance variable where the value is read. */
class InstanceVariableReadAccess extends InstanceVariableAccess, VariableReadAccess { }

/** An access to a class variable. */
class ClassVariableAccess extends VariableAccess, TClassVariableAccess {
  final override string getAPrimaryQlClass() { result = "ClassVariableAccess" }
}

/** An access to a class variable where the value is updated. */
class ClassVariableWriteAccess extends ClassVariableAccess, VariableWriteAccess { }

/** An access to a class variable where the value is read. */
class ClassVariableReadAccess extends ClassVariableAccess, VariableReadAccess { }
