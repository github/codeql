private import codeql.swift.generated.AstNode
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.elements.decl.Decl
private import codeql.swift.elements.expr.AbstractClosureExpr
private import codeql.swift.elements.Callable
private import codeql.swift.generated.ParentChild

private module Cached {
  private Element getEnclosingDeclStep(Element e) {
    not e instanceof Decl and
    result = getImmediateParent(e)
  }

  cached
  Decl getEnclosingDecl(AstNode ast) { result = getEnclosingDeclStep*(getImmediateParent(ast)) }

  private Element getEnclosingFunctionStep(Element e) {
    not e instanceof AbstractFunctionDecl and
    result = getEnclosingDecl(e)
  }

  cached
  AbstractFunctionDecl getEnclosingFunction(AstNode ast) {
    result = getEnclosingFunctionStep*(getEnclosingDecl(ast))
  }

  private Element getEnclosingClosureStep(Element e) {
    not e instanceof Callable and
    result = getImmediateParent(e)
  }

  cached
  AbstractClosureExpr getEnclosingClosure(AstNode ast) {
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
  final AbstractFunctionDecl getEnclosingFunction() { result = Cached::getEnclosingFunction(this) }

  /**
   * Gets the nearest declaration that contains this AST node, if any.
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
