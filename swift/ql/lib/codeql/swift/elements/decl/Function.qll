private import codeql.swift.generated.decl.Function
private import codeql.swift.elements.decl.Method

/**
 * A function.
 */
class Function extends Generated::Function, Callable {
  override string toString() { result = this.getName() }
}

/**
 * A free (non-member) function.
 */
class FreeFunction extends Function {
  FreeFunction() { not this instanceof Method }
}
