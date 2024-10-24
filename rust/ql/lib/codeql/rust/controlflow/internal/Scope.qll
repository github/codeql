private import rust
private import Completion
private import ControlFlowGraphImpl
private import codeql.rust.elements.internal.generated.ParentChild

/**
 * A control-flow graph (CFG) scope.
 *
 * A CFG scope is a callable with a body.
 */
class CfgScope extends Callable {
  CfgScope() {
    // A function without a body corresponds to a trait method signature and
    // should not have a CFG scope.
    this.(Function).hasBody()
    or
    this instanceof ClosureExpr
  }

  /** Gets the body of this callable. */
  AstNode getBody() {
    result = this.(Function).getBody()
    or
    result = this.(ClosureExpr).getBody()
  }
}

/**
 * Gets the immediate parent of a non-`AstNode` element `e`.
 *
 * We restrict `e` to be a non-`AstNode` to skip past non-`AstNode` in
 * the transitive closure computation in `getParentOfAst`. This is
 * necessary because the parent of an `AstNode` is not necessarily an `AstNode`.
 */
private Element getParentOfAstStep(Element e) {
  not e instanceof AstNode and
  result = getImmediateParent(e)
}

/** Gets the nearest enclosing parent of `ast` that is an `AstNode`. */
private AstNode getParentOfAst(AstNode ast) {
  result = getParentOfAstStep*(getImmediateParent(ast))
}

/** Gets the enclosing scope of a node */
cached
AstNode scopeOfAst(AstNode n) {
  exists(AstNode p | p = getParentOfAst(n) |
    if p instanceof CfgScope then p = result else result = scopeOfAst(p)
  )
}
