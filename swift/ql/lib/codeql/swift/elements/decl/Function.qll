private import swift
private import codeql.swift.generated.decl.Function

/**
 * A function.
 */
class Function extends Generated::Function, Callable {
  override string toString() { result = this.getName() }

  /**
   * Holds if this is a throwing function.
   *
   * For example, this function is a throwing function:
   *
   * ```swift
   * func myFunc() throws -> String {
   *   // ...
   * }
   * ```
   */
  predicate isThrowing() { this.getInterfaceType().(AnyFunctionType).isThrowing() }
}

/**
 * A free (non-member) function.
 */
class FreeFunction extends Function {
  FreeFunction() { not this instanceof Method }
}
