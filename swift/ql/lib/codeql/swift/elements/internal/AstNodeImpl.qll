private import codeql.swift.generated.AstNode
private import codeql.swift.elements.decl.Function
private import codeql.swift.elements.decl.Decl
private import codeql.swift.elements.expr.ClosureExpr
private import codeql.swift.elements.Callable
private import codeql.swift.generated.ParentChild

module Impl {
  private module Cached {
    private Element getEnclosingDeclStep(Element e) {
      not e instanceof Decl and
      result = getImmediateParent(e)
    }

    cached
    Decl getEnclosingDecl(AstNode ast) { result = getEnclosingDeclStep*(getImmediateParent(ast)) }

    private Element getEnclosingFunctionStep(Element e) {
      not e instanceof Function and
      result = getEnclosingDecl(e)
    }

    cached
    Function getEnclosingFunction(AstNode ast) {
      result = getEnclosingFunctionStep*(getEnclosingDecl(ast))
    }

    private Element getEnclosingClosureStep(Element e) {
      not e instanceof Callable and
      result = getImmediateParent(e)
    }

    cached
    ClosureExpr getEnclosingClosure(AstNode ast) {
      result = getEnclosingClosureStep*(getImmediateParent(ast))
    }
  }

  /**
   * A node in the abstract syntax tree.
   */
  class AstNode extends Generated::AstNode {
    /**
     * Gets the nearest function definition that contains this AST node, if any.
     * This includes functions, methods, (de)initializers, and accessors, but not closures.
     *
     * For example, in the following code, the AST node for `n + 1` has `foo` as its
     * enclosing function (via `getEnclosingFunction`), whereas its enclosing callable is
     * the closure `{(n : Int) in n + 1 }` (via `getEnclosingCallable`):
     *
     * ```swift
     * func foo() {
     *   var f = { (n : Int) in n + 1 }
     * }
     * ```
     */
    final Function getEnclosingFunction() { result = Cached::getEnclosingFunction(this) }

    /**
     * Gets the nearest declaration that contains this AST node, if any.
     *
     * Note that the nearest declaration may be an extension of a type declaration. If you always
     * want the type declaration and not the extension, use `getEnclosingDecl().asNominalTypeDecl()`.
     */
    final Decl getEnclosingDecl() { result = Cached::getEnclosingDecl(this) }

    /**
     * Gets the nearest `Callable` that contains this AST node, if any.
     * This includes (auto)closures, functions, methods, (de)initializers, and accessors.
     *
     * For example, in the following code, the AST node for `n + 1` has the closure
     * `{(n : Int) in n + 1 }` as its enclosing callable.
     *
     * ```swift
     * func foo() {
     *   var f = { (n : Int) in n + 1 }
     * }
     * ```
     */
    final Callable getEnclosingCallable() {
      if exists(Cached::getEnclosingClosure(this))
      then result = Cached::getEnclosingClosure(this)
      else result = Cached::getEnclosingFunction(this)
    }
  }
}
