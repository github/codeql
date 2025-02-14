private import rust
private import Completion
private import ControlFlowGraphImpl
private import codeql.rust.elements.internal.generated.ParentChild

/**
 * A control flow graph (CFG) scope.
 */
abstract private class CfgScopeImpl extends AstNode {
  /** Holds if `first` is executed first when entering `scope`. */
  abstract predicate scopeFirst(AstNode first);

  /** Holds if `scope` is exited when `last` finishes with completion `c`. */
  abstract predicate scopeLast(AstNode last, Completion c);
}

final class CfgScope = CfgScopeImpl;

final class AsyncBlockScope extends CfgScopeImpl, AsyncBlockExpr instanceof ExprTrees::AsyncBlockExprTree
{
  override predicate scopeFirst(AstNode first) { first(super.getFirstChildNode(), first) }

  override predicate scopeLast(AstNode last, Completion c) {
    last(super.getLastChildElement(), last, c)
    or
    last(super.getChildNode(_), last, c) and
    not c instanceof NormalCompletion
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
