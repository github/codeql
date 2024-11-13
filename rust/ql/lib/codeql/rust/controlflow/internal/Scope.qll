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
