/** Provides classes for modeling program variables. */

private import codeql_ruby.AST
private import codeql.Locations
private import internal.Variable

/** A scope in which variables can be declared. */
class VariableScope extends Scope {
  /** Gets a variable that is declared in this scope. */
  final Variable getAVariable() { result.getDeclaringScope() = this }

  /** Gets the variable with the given name that is declared in this scope. */
  final Variable getVariable(string name) {
    result = this.getAVariable() and
    result.getName() = name
  }
}

/** A variable declared in a scope. */
class Variable extends TVariable {
  Variable::Range range;

  Variable() { range = this }

  /** Gets the name of this variable. */
  final string getName() { result = range.getName() }

  /** Gets a textual representation of this variable. */
  final string toString() { result = this.getName() }

  /** Gets the location of this variable. */
  final Location getLocation() { result = range.getLocation() }

  /** Gets the scope this variable is declared in. */
  final VariableScope getDeclaringScope() { result = range.getDeclaringScope() }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A local variable. */
class LocalVariable extends Variable, TLocalVariable {
  override LocalVariable::Range range;

  final override LocalVariableAccess getAnAccess() { result.getVariable() = this }

  /** Gets the access where this local variable is first introduced. */
  VariableAccess getDefiningAccess() { result = range.getDefiningAccess() }

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
class GlobalVariable extends Variable, TGlobalVariable {
  override GlobalVariable::Range range;

  final override GlobalVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An instance variable. */
class InstanceVariable extends Variable, TInstanceVariable {
  override InstanceVariable::Range range;

  /** Holds is this variable is a class instance variable. */
  final predicate isClassInstanceVariable() { range.isClassInstanceVariable() }

  final override InstanceVariableAccess getAnAccess() { result.getVariable() = this }
}

/** A class variable. */
class ClassVariable extends Variable, TClassVariable {
  override ClassVariable::Range range;

  final override ClassVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An access to a variable. */
class VariableAccess extends Expr {
  override VariableAccess::Range range;

  /** Gets the variable this identifier refers to. */
  Variable getVariable() { result = range.getVariable() }

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
  predicate isExplicitWrite(AstNode assignment) { range.isExplicitWrite(assignment) }

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
  predicate isImplicitWrite() { range.isImplicitWrite() }
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
  VariableReadAccess() {
    not this instanceof VariableWriteAccess
    or
    // `x` in `x += y` is considered both a read and a write
    this = any(AssignOperation a).getLeftOperand()
  }
}

/** An access to a local variable. */
class LocalVariableAccess extends VariableAccess, LocalVariableAccess::LocalVariableRange {
  final override LocalVariableAccess::Range range;

  final override LocalVariable getVariable() { result = range.getVariable() }

  final override string getAPrimaryQlClass() {
    not this instanceof NamedParameter and result = "LocalVariableAccess"
  }

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
class GlobalVariableAccess extends VariableAccess, @token_global_variable {
  final override GlobalVariableAccess::Range range;

  final override GlobalVariable getVariable() { result = range.getVariable() }

  final override string getAPrimaryQlClass() { result = "GlobalVariableAccess" }
}

/** An access to a global variable where the value is updated. */
class GlobalVariableWriteAccess extends GlobalVariableAccess, VariableWriteAccess { }

/** An access to a global variable where the value is read. */
class GlobalVariableReadAccess extends GlobalVariableAccess, VariableReadAccess { }

/** An access to an instance variable. */
class InstanceVariableAccess extends VariableAccess, @token_instance_variable {
  final override InstanceVariableAccess::Range range;

  final override InstanceVariable getVariable() { result = range.getVariable() }

  final override string getAPrimaryQlClass() { result = "InstanceVariableAccess" }
}

/** An access to a class variable. */
class ClassVariableAccess extends VariableAccess, @token_class_variable {
  final override ClassVariableAccess::Range range;

  final override ClassVariable getVariable() { result = range.getVariable() }

  final override string getAPrimaryQlClass() { result = "ClassVariableAccess" }
}
