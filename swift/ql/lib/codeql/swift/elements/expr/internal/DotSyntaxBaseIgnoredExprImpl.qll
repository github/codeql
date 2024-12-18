private import codeql.swift.generated.expr.DotSyntaxBaseIgnoredExpr
private import codeql.swift.elements.expr.AutoClosureExpr
private import codeql.swift.elements.expr.CallExpr
private import codeql.swift.elements.expr.TypeExpr
private import codeql.swift.elements.decl.Method

module Impl {
  /**
   * An expression representing a partially applied lookup of an instance property via the receiver's type object.
   *
   * An example is the sub-expression `SomeClass.instanceMethod` of
   * `SomeClass.instanceMethod(someInstance)(arg, ...)`.
   *
   * Internally, the Swift compiler desugars this AST node type into a closure expression of the form
   * `{ (someInstance: SomeClass) in { (arg, ...) in someInstance.instanceMethod(arg, ...) } }`,
   * which in turn can be accessed using the `getSubExpr/0` predicate.
   */
  class DotSyntaxBaseIgnoredExpr extends Generated::DotSyntaxBaseIgnoredExpr {
    override string toString() {
      result =
        any(string base |
            if exists(this.getQualifier().(TypeExpr).getTypeRepr().toString())
            then base = this.getQualifier().(TypeExpr).getTypeRepr().toString() + "."
            else base = "."
          ) + this.getMethod()
    }

    /**
     * Gets the underlying instance method that is called when the result of this
     * expression is fully applied.
     */
    Method getMethod() {
      result =
        this.getSubExpr()
            .(AutoClosureExpr)
            .getExpr()
            .(AutoClosureExpr)
            .getExpr()
            .(CallExpr)
            .getStaticTarget()
    }
  }
}
