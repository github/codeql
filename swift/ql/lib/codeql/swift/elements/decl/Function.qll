private import codeql.swift.generated.decl.Function
private import codeql.swift.elements.decl.Method
private import codeql.swift.elements.type.Type
private import codeql.swift.elements.type.FunctionType
private import codeql.swift.elements.decl.TypeDecl

/**
 * A function.
 */
class Function extends Generated::Function, Callable {
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

  /**
   * Gets the return type of this function.
   */
  Type getResultType() {
    if this.hasSelfParam()
    then result = this.getInterfaceType().(FunctionType).getResult().(FunctionType).getResult()
    else result = this.getInterfaceType().(FunctionType).getResult()
  }
}

/**
 * A free (non-member) function.
 */
class FreeFunction extends Function {
  FreeFunction() { not this instanceof Method }
}
