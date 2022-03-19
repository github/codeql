import python

/** A variable, either a global or local variable (including parameters) */
class Variable extends @py_variable {
  Variable() {
    exists(string name |
      variable(this, _, name) and
      not name = "*" and
      not name = "$"
    )
  }

  /** Gets the identifier (name) of this variable */
  string getId() { variable(this, _, result) }

  /** Gets a textual representation of this element. */
  string toString() { result = "Variable " + this.getId() }

  /** Gets an access (load or store) of this variable */
  Name getAnAccess() {
    result = this.getALoad()
    or
    result = this.getAStore()
  }

  /** Gets a load of this variable */
  Name getALoad() { result.uses(this) }

  /** Gets a store of this variable */
  Name getAStore() { result.defines(this) }

  /** Gets a use of this variable */
  NameNode getAUse() { result.uses(this) }

  /** Gets the scope of this variable */
  Scope getScope() { variable(this, result, _) }

  /**
   * Whether there is an access to this variable outside
   * of its own scope. Usually occurs in nested functions
   * or for global variables.
   */
  predicate escapes() { exists(Name n | n = this.getAnAccess() | n.getScope() != this.getScope()) }

  /** Whether this variable is a parameter */
  predicate isParameter() { none() }

  predicate isSelf() { none() }
}

/** A local (function or class) variable */
class LocalVariable extends Variable {
  LocalVariable() {
    exists(Scope s | s = this.getScope() | s instanceof Function or s instanceof Class)
  }

  override string toString() { result = "Local Variable " + this.getId() }

  /** Whether this variable is a parameter */
  override predicate isParameter() { this.getAnAccess() instanceof Parameter }

  /** Holds if this variable is the first parameter of a method. It is not necessarily called "self" */
  override predicate isSelf() {
    exists(Function f, Parameter self |
      this.getAnAccess() = self and
      f.isMethod() and
      f.getArg(0) = self
    )
  }
}

/**
 * A local variable that uses "load fast" semantics, for lookup:
 * If the variable is undefined, then raise an exception.
 */
class FastLocalVariable extends LocalVariable {
  FastLocalVariable() { this.getScope() instanceof FastLocalsFunction }
}

/**
 * A local variable that uses "load name" semantics, for lookup:
 * If the variable is undefined, then lookup the value in globals().
 */
class NameLocalVariable extends LocalVariable {
  NameLocalVariable() { not this instanceof FastLocalVariable }
}

/** A global (module-level) variable */
class GlobalVariable extends Variable {
  GlobalVariable() { this.getScope() instanceof Module }

  override string toString() { result = "Global Variable " + this.getId() }
}
