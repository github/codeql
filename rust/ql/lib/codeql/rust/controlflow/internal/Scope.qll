private import rust
private import Completion
private import ControlFlowGraphImpl
private import codeql.rust.elements.internal.generated.ParentChild

/**
 * A control-flow graph (CFG) scope.
 */
abstract private class CfgScopeImpl extends AstNode {
  abstract predicate scopeFirst(AstNode first);

  abstract predicate scopeLast(AstNode last, Completion c);
}

final class CfgScope = CfgScopeImpl;

final class AsyncBlockScope extends CfgScopeImpl, AsyncBlockExpr {
  override predicate scopeFirst(AstNode first) {
    first(this.(ExprTrees::AsyncBlockExprTree).getFirstChildNode(), first)
  }

  override predicate scopeLast(AstNode last, Completion c) {
    last(this.(ExprTrees::AsyncBlockExprTree).getLastChildElement(), last, c)
  }
}

/**
 * A CFG scope for a callable (a function or a closure) with a body.
 */
final class CallableScope extends CfgScopeImpl, Callable {
  CallableScope() {
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

  override predicate scopeFirst(AstNode first) {
    first(this.(CallableScopeTree).getFirstChildNode(), first)
  }

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  override predicate scopeLast(AstNode last, Completion c) { last(this.getBody(), last, c) }
}

/** Gets the CFG scope that encloses `node`, if any. */
CfgScope getEnclosingCfgScope(AstNode node) {
  exists(AstNode p | p = node.getParentNode() |
    result = p
    or
    not p instanceof CfgScope and
    result = getEnclosingCfgScope(p)
  )
}
