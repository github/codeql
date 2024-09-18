private import codeql.swift.generated.decl.Function
private import codeql.swift.elements.decl.Method

module Impl {
  /**
   * A function.
   */
  class Function extends Generated::Function {
    override string toString() { result = this.getName() }

    /**
     * Gets the name of this function, without the argument list. For example
     * a function with name `myFunction(arg:)` has short name `myFunction`.
     */
    string getShortName() {
      // match as many characters as possible that are not `(`.
      // (`*+` is possessive matching)
      result = this.getName().regexpCapture("([^(]*+).*", 1)
    }
  }

  /**
   * A free (non-member) function.
   */
  class FreeFunction extends Function {
    FreeFunction() { not this instanceof Method }
  }
}
